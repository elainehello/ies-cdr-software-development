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

//        Book libro3 = new Book();
//        Scanner sc = new Scanner(System.in);
//        System.out.println("Please enter title: ");
//        String title2 = sc.nextLine();
//        System.out.println("Enter author: ");
//        String author2 = sc.nextLine();
//        System.out.println("Enter exemplars: ");
//        int exemplar2 = sc.nextInt();
//        System.out.println("Enter borrowed: ");
//        int borrewed2 = sc.nextInt();
//
//        libro2.setBook(title2, author2);
//        System.out.printf("Book borrowed %b", libro3.prestamo());
//        System.out.printf("%s\n", libro3.toString());
//        sc.close();


        Book libro4 = new Book("El Quijote2", "Miguel de Cervantes", 1, 0);
        System.out.println(libro4.toString());
        if (libro4.prestamo()) {
            System.out.println("Libro prestado");
        } else {
            System.out.println("no quedan ejemplares");
        }

        if (libro4.devolucion()) {
            System.out.println("Devolucion hecha");
        } else {
            System.out.println("no quedan ejemplares");
        }

        Scanner sc2 = new Scanner(System.in);
        Book libro5 = new Book();
        System.out.println("Enter title: ");
        libro5.setTitle(sc2.nextLine());
        System.out.println("Enter author: ");
        libro5.setAuthor(sc2.nextLine());
        System.out.println("Enter exemplars: ");
        libro5.setExemplars(sc2.nextInt());
        System.out.println(libro5.toString());

        if (libro5.prestamo()) {
            System.out.println("Libro prestado");
        } else {
            System.out.println("no quedan ejemplares");
        }

        if (libro5.devolucion()) {
            System.out.println("Devolucion hecha");
        } else {
            System.out.println("no quedan ejemplares");
        }
        System.out.println(libro5.toString());
        sc2.close();
    }
}