const NUM_BOXES = 4;
const NUM_SHEETS = 5;

// 1. We create the boxes once the body exists <body>
document.addEventListener('DOMContentLoaded', function() {
    const container = document.querySelector('.container');
    const text = document.querySelector('.text');

    for (let i = 1; i <= NUM_BOXES; i++) {
        const box = document.createElement('div');
        box.className = 'box b' + i;
        box.textContent = i;
        container.insertBefore(box,text);
    }
});

// 2. We swap stylesheet by key event listener -- with keys 1..NUM_SHEETS
document.addEventListener('keydown', function(e){
    const n = Number(e.key); //"3" -> parse to 3, "a" -> NaN
    if (n >= 1 && n <= NUM_SHEETS) {
        console.log('Loading styles' + n);
        document.getElementById('theme').href = 'css/styles' + n + '.css'; 
    }
});