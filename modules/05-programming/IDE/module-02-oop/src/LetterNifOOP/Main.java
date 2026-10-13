package LetterNifOOP;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
          Nif nif = new Nif();
//        nif.read();
//        System.out.printf("\n%s", nif.toString());

//        Nif nif = new Nif();
//        nif.read();
//        System.out.printf("\n%s", nif.toString());

        Scanner sc = new Scanner(System.in);
        System.out.println("Please, enter your NIF number");
        int number = sc.nextInt();
        nif.read(number);
        System.out.println();
        System.out.println(nif.toString());

        sc.close();
    }
}
