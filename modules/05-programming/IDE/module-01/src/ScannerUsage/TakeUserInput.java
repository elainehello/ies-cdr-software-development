package ScannerUsage;

import java.util.Scanner;

public class TakeUserInput {
    public static void main(String[] args) {
        double area;

        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter the side length for the square");
        double side = scanner.nextDouble();
        System.out.printf("The square area is: %f\n", Math.pow(side, 2));

        area =  side * side;

        System.out.printf("The square area i: %f\n", area);
    }
}
