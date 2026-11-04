package AverageMarkAndOutstanding;

import java.util.Scanner;

public class CalculateMark {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Please enter the student class numbers\n");
        int studentNbr = sc.nextInt();
        int[] arrayNbr = new int[studentNbr];
        System.out.printf("Class number %d\n", studentNbr);
        sc.nextLine();

        // class's Marks
        for (int i = 0; i < arrayNbr.length; i++) {
            System.out.println("Please enter mark:\n");
            arrayNbr[i] = sc.nextInt();
            sc.nextLine();
        }

        // average score
        double isAverage;
        int res = 0;
        for (int i = 0; i < arrayNbr.length; i++) {
            res += arrayNbr[i];
        }
        isAverage = (double)res/arrayNbr.length;
        System.out.printf("\nAverage %.2f\n", isAverage);

        // find high score
        for (int i = 0; i < arrayNbr.length; i++) {
            if (arrayNbr[i] > isAverage) {
                System.out.printf("Array position [%d] Score: %d\n", i, arrayNbr[i]);
            }
        }

        sc.close();
    }
}
