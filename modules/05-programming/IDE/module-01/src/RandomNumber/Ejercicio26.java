package RandomNumber;

import java.util.Scanner;

public class Ejercicio26 {
    public static void main(String[] args) {
        int counter = 0;
        boolean control = false;
        int randomNbr = (int) (Math.random() * 100);

        while (!control) {
            System.out.println("Please enter a number (0 - 99)");
            Scanner sc = new Scanner(System.in);
            int nbr = sc.nextInt();
            if (randomNbr == nbr) {
                control = true;
                System.out.printf("Correcto lo has conseguido en intento %d", counter);
                break;
            } else if (nbr > randomNbr) {
                System.out.println("mas bajo");
            } else {
                System.out.println("mas alto");
            }
            counter++;
        }
    }
}
