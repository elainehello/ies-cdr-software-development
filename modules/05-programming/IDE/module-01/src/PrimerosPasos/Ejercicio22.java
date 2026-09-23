package PrimerosPasos;

import java.util.Scanner;

/*
* Write a Java program we must declare a variable data type 'short', initialise it with the preference value,
* inside a main block, and must print in stardard out the string "The value of the short variable is: "
* followed by the value of the variable.
*/

public class Ejercicio22 {
    public static void main(String[] args) {
        short myValue = 377; // value assigned
        //System.out.println("The value of the short value is: " + " " + myValue);
        System.out.printf("The value of the short value is: %d%n", myValue);
        System.out.printf("%d%n", myValue);

        Scanner scanner = new Scanner(System.in);
        System.out.println("Welcome, whats your name?");
        String nameUser = scanner.nextLine();
        System.out.println("How old are you?");
        int ageUser = scanner.nextInt();
        System.out.printf("%s does have %d years old", nameUser, ageUser);

    }
}
