package StatementDemo;

import java.util.Scanner;

public class Ejercicio21 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Please enter age\n>");
        int userAge = sc.nextInt();

        if (userAge < 18) {
            System.out.println("You are an Adolescent");
        } else if (userAge > 18 && userAge <= 39) {
            System.out.println("You are young");
        } else if (userAge >= 40 && userAge <= 64) {
            System.out.println("You are an Adult");
        } else if (userAge >= 65)  {
            System.out.println("Take care!");
        }
    }
}
