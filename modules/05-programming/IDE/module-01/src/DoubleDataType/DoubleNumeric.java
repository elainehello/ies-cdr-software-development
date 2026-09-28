package DoubleDataType;

import javax.swing.*;

public class DoubleNumeric {
    public static void main(String[] args) {
        Double nbr = 1000.0;
        String userAge;
        double ageParsed;
        double sqrtNbr;

        System.out.printf("%.4f%n", nbr/3);

        userAge = JOptionPane.showInputDialog("Please enter your Age");
        ageParsed = Double.parseDouble(userAge);

        sqrtNbr = Math.sqrt(ageParsed);
        System.out.printf("The square root is %f", sqrtNbr);

    }


}
