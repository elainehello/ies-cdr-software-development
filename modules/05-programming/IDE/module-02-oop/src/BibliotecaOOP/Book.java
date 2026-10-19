package BibliotecaOOP;

public class Book {
    // attrbutes
    private String title;
    private String author;
    private int exemplars = 9;
    private int borrowed = 2;

    // empty constructor
    public Book() {

    }

    // constructor
    public Book(String title, String author, int exemplars, int borrowed) {
        this.title = title;
        this.author = author;
        this.exemplars = exemplars;
        this.borrowed = borrowed;
    }

    public String getBook() {
        return title + " " + author;
    }

    public void setBook(String title, String author) {
        this.title = title;
        this.author = author;
    }

    public Boolean prestamo() {
        if (borrowed < exemplars) {
            this.borrowed += 1;
            return true;
        } else {
            return false;
        }
    }

    public Boolean devolucion() {
        if (exemplars > 0) {
            this.exemplars -= 1;
            return true;
        } else {
            return false;
        }
    }

    @Override
    public String toString() {
        return "\nTitulo: " + title + "\n" +
                "Autor: " + author + "\n" +
                "Ejemplares: " + exemplars+ "\n" +
                "Prestados: " + borrowed;
    }

}
