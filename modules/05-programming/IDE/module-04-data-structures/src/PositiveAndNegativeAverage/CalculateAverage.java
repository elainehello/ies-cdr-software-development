package PositiveAndNegativeAverage;

import java.util.Scanner;

public class CalculateAverage {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int[] arrayNbr = new int [5];
        int negCont = 0;
        int posCont = 0;
        double res = 0;
        int aux = 0;

        for (int i = 0; i < arrayNbr.length; i++) {
            System.out.println("Enter number:\n");
            int value = sc.nextInt();
            sc.nextLine();
            if (value < 0) {
                arrayNbr[i] = value;
                negCont++;
            }
            if (value > 0) {
                arrayNbr[i] = value;
                posCont++;
            }
        }
        for (int j : arrayNbr) {
            aux += j;
            System.out.printf("aux value %d", aux);
        }
        if (posCont != 0) {
            res = (double)aux / posCont;
            System.out.printf("\nAverage positive: %d", res);
        } else if (negCont != 0) {
            res = (double)aux / negCont;
            System.out.printf("\nAverage negative: %d", res);
        }
        sc.close();
    }
}
