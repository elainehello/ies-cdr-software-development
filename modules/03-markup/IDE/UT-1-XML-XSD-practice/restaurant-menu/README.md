# Restaurant Menu

A simple client-server application for creating and validating restaurant menus using XML and XSD.

## Project Structure

```text
restaurant-menu/
├── client/          # Web interface (HTML, CSS, JavaScript)
├── examples/        # Example menu XML
├── schemas/         # XML Schema (XSD)
├── server/          # C HTTP server
└── Makefile         # Build and run commands
```

## Requirements

- GCC
- Make
- libxml2
- libmicrohttpd
- xmllint

## Build

Compile the server from the project root:

```bash
make
```

## Run

Start the server:

```bash
make run
```

The server listens at:

```text
http://localhost:8080
```

Open `client/index.html` in your browser to use the menu interface.

## Validate Example XML

Validate the sample menu against the XSD schema:

```bash
make validate
```

## Clean

Remove the compiled server binary:

```bash
make clean
```