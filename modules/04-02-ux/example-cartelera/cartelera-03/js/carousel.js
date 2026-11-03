const container = document.getElementById("movies-container");

const leftButton = document.getElementById("scroll-left");
const rightButton = document.getElementById("scroll-right");

leftButton.addEventListener("click", () => {
    container.scrollBy({
        left: -250,
        behavior: "smooth"
    });
});

rightButton.addEventListener("click", () => {
    container.scrollBy({
        left: 250,
        behavior: "smooth"
    });
});