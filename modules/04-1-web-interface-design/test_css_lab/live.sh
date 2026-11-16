#!/usr/bin/env bash
# live.sh - live preview for a folder of HTML/CSS/JS: save a file, the browser updates.
#
# Usage:
#   ./live.sh                          serve the current folder
#   ./live.sh <folder>                 serve that folder (quotes for spaces: "responsive imagenes")
#   ./live.sh <folder> <page.html>     open that page directly
#   ./live.sh -p 8080 <folder>         choose the port (default: first free from 5500)
#   ./live.sh -e python <folder>       force an engine: browser-sync | live-server | python
#   ./live.sh -h                       help
#
# Engines, tried in this order:
#   1. browser-sync  (Node) CSS changes are injected without reloading the page,
#                    so :hover states, open modals and scroll position survive.
#   2. live-server   (Node) full reload on every save.
#   3. python3       (no install needed) built-in server below, full reload on save.
#
# Stop with Ctrl+C.

set -euo pipefail

PORT=""
ENGINE=""
usage() { sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while getopts ":p:e:h" opt; do
  case "$opt" in
    p) PORT="$OPTARG" ;;
    e) ENGINE="$OPTARG" ;;
    h) usage 0 ;;
    \?) echo "Unknown option -$OPTARG" >&2; usage 1 ;;
    :)  echo "Option -$OPTARG needs a value" >&2; usage 1 ;;
  esac
done
shift $((OPTIND - 1))

DIR="${1:-.}"
PAGE="${2:-}"

# ---------- checks ----------
[[ -d "$DIR" ]] || { echo "Folder not found: $DIR" >&2; exit 1; }
DIR="$(cd "$DIR" && pwd)"

# ---------- pick the page to open ----------
if [[ -z "$PAGE" ]]; then
  mapfile -t PAGES < <(cd "$DIR" && find . -maxdepth 2 -type f \( -iname '*.html' -o -iname '*.htm' \) \
                        | sed 's|^\./||' | sort)
  if [[ ${#PAGES[@]} -eq 0 ]]; then
    echo "No .html/.htm files in $DIR (serving the folder listing)."
  elif [[ ${#PAGES[@]} -eq 1 ]]; then
    PAGE="${PAGES[0]}"
  else
    # prefer an index file, otherwise ask
    for cand in index.html index.htm; do
      for p in "${PAGES[@]}"; do [[ "$p" == "$cand" ]] && PAGE="$p"; done
      [[ -n "$PAGE" ]] && break
    done
    if [[ -z "$PAGE" ]] && [[ -t 0 ]]; then
      echo "Several pages found. Which one should open first?"
      PS3="Number: "
      select p in "${PAGES[@]}"; do [[ -n "${p:-}" ]] && { PAGE="$p"; break; }; done
    fi
    PAGE="${PAGE:-${PAGES[0]}}"
  fi
fi
[[ -z "$PAGE" || -f "$DIR/$PAGE" ]] || { echo "Page not found: $DIR/$PAGE" >&2; exit 1; }

# ---------- free port ----------
port_busy() {
  if command -v nc >/dev/null 2>&1; then nc -z 127.0.0.1 "$1" >/dev/null 2>&1
  else (exec 3<>"/dev/tcp/127.0.0.1/$1") >/dev/null 2>&1; fi
}
if [[ -z "$PORT" ]]; then
  PORT=5500
  while port_busy "$PORT"; do PORT=$((PORT + 1)); done
fi

URL="http://localhost:$PORT/${PAGE// /%20}"

open_browser() {
  sleep 1.5
  if command -v xdg-open >/dev/null 2>&1; then xdg-open "$1" >/dev/null 2>&1 &
  elif command -v open >/dev/null 2>&1; then open "$1"
  elif command -v cmd.exe >/dev/null 2>&1; then cmd.exe /c start "" "$1" >/dev/null 2>&1   # WSL / Git Bash
  else echo "Open this address in your browser: $1"; fi
}

# ---------- choose engine ----------
have_npx() { command -v npx >/dev/null 2>&1; }
if [[ -z "$ENGINE" ]]; then
  if have_npx; then ENGINE="browser-sync"
  elif command -v python3 >/dev/null 2>&1; then ENGINE="python"
  else echo "Install Node.js (for npx) or Python 3." >&2; exit 1; fi
fi

echo "──────────────────────────────────────────────"
echo " Folder : $DIR"
echo " Page   : ${PAGE:-(folder listing)}"
echo " URL    : $URL"
echo " Engine : $ENGINE"
echo " Edit and save any .html/.htm/.css/.js file: the browser updates."
echo " Stop   : Ctrl+C"
echo "──────────────────────────────────────────────"

cd "$DIR"
case "$ENGINE" in
  browser-sync)
    # --yes: let npx download the package the first time without asking
    exec npx --yes browser-sync start --server --port "$PORT" \
      --files "**/*.html" "**/*.htm" "**/*.css" "**/*.js" \
      --startPath "/${PAGE}" --no-notify --no-ui
    ;;
  live-server)
    exec npx --yes live-server --port="$PORT" --open="/${PAGE}" --wait=100
    ;;
  python)
    command -v python3 >/dev/null 2>&1 || { echo "python3 not found" >&2; exit 1; }
    open_browser "$URL" &
    # Small server: serves the folder and adds a script to every HTML page that
    # asks every 0.8 s whether any file changed, and reloads the page if so.
    exec python3 - "$PORT" <<'PY'
import http.server, os, sys, json, functools
PORT = int(sys.argv[1])
WATCH = ('.html', '.htm', '.css', '.js', '.json', '.jpg', '.jpeg', '.png', '.gif', '.svg', '.webp')
SNIPPET = b"""<script>/* live reload (live.sh) */(function(){var last=null;setInterval(function(){
fetch('/__changes',{cache:'no-store'}).then(function(r){return r.json()}).then(function(d){
if(last!==null&&d.t!==last){location.reload()}last=d.t}).catch(function(){})},800)})();</script>"""

def newest():
    t = 0.0
    for root, dirs, files in os.walk('.'):
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != 'node_modules']
        for f in files:
            if f.lower().endswith(WATCH):
                try: t = max(t, os.path.getmtime(os.path.join(root, f)))
                except OSError: pass
    return t

class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()
    def do_GET(self):
        if self.path.startswith('/__changes'):
            body = json.dumps({'t': newest()}).encode()
            self.send_response(200); self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(body))); self.end_headers(); self.wfile.write(body); return
        path = self.translate_path(self.path)
        if os.path.isdir(path):
            for idx in ('index.html', 'index.htm'):
                if os.path.exists(os.path.join(path, idx)): path = os.path.join(path, idx); break
        if path.lower().endswith(('.html', '.htm')) and os.path.isfile(path):
            data = open(path, 'rb').read()
            low = data.lower()
            i = low.rfind(b'</body>')
            data = data[:i] + SNIPPET + data[i:] if i >= 0 else data + SNIPPET
            self.send_response(200); self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', str(len(data))); self.end_headers(); self.wfile.write(data); return
        super().do_GET()
    def log_message(self, fmt, *args):
        if '__changes' not in (args[0] if args else ''): sys.stderr.write('  ' + (fmt % args) + '\n')

http.server.ThreadingHTTPServer.allow_reuse_address = True
try:
    http.server.ThreadingHTTPServer(('127.0.0.1', PORT), H).serve_forever()
except KeyboardInterrupt:
    print('\nStopped.')
PY
    ;;
  *) echo "Unknown engine: $ENGINE (use browser-sync, live-server or python)" >&2; exit 1 ;;
esac
