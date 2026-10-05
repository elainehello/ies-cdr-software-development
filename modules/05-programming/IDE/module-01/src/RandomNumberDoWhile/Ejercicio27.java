package RandomNumberDoWhile;

import java.util.Scanner;

public class Ejercicio27 {
    public static void main(String[] args) {

        int nbrRandom =(int) (Math.random() * 100);
        boolean control = false;
        int counter = 0;
        System.out.println("Please enter a number between 0-99");
        do {
            Scanner sc = new Scanner(System.in);
            int nbr = sc.nextInt();
            if (nbrRandom == nbr) {
                System.out.printf("Correct, you got it in the try number %d", counter);
                control = true;
                break;
            } else if (nbr > nbrRandom) {
                System.out.println("It's lower");
            } else
                System.out.println("It's higher");
            counter++;
        } while (!control);
    }
}
