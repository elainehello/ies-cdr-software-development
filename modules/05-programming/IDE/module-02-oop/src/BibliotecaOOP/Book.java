package BibliotecaOOP;

public class Book {
    // attrbutes
    private String title;
    private String author;
    private int exemplars;
    private int borrowed;

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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getExemplars() {
        return exemplars;
    }

    public void setExemplars(int exemplars) {
        this.exemplars = exemplars;
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
        if (borrowed > 0) {
            this.borrowed -= 1;
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
