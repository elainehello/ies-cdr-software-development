package BibliotecaOOP;

import java.util.Scanner;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {
        Book libro1 = new Book("El Quijote", "Cervantes", 1, 0);
        System.out.printf("%s\n", libro1.getBook());

        Book libro2 = new Book("Charlotte", "David Foenkino", 1, 0);
        System.out.printf("%s\n", libro2.getBook());

        Book libro3 = new Book();
        Scanner sc = new Scanner(System.in);
        System.out.println("Please enter title: ");
        String title2 = sc.nextLine();
        System.out.println("Enter author: ");
        String author2 = sc.nextLine();
        System.out.println("Enter exemplars: ");
        int exemplar2 = sc.nextInt();
        System.out.println("Enter borrowed: ");
        int borrewed2 = sc.nextInt();

        libro2.setBook(title2, author2);
        System.out.printf("Book borrowed %b", libro2.prestamo());
        System.out.printf("%s\n", libro2.toString());
    }
}