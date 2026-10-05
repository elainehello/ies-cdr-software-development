package CalculateFactorialNumber;

import javax.swing.*;

public class Ejercicio28 {
    public static void main(String[] args) {
        String msg = "Enter a number";
        int nbr = Integer.parseInt(JOptionPane.showInputDialog(msg));
        System.out.printf("%d\n", nbr);
        long fac = 1;

        for(int i = nbr; i > 0; i--) {
            fac *= i;
        }
        System.out.printf("the factorial of the number %d\tis\t%d", nbr, fac);
    }
}
