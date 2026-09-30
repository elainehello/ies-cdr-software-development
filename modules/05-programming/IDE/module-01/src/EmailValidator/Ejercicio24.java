package EmailValidator;

import javax.swing.*;

public class Ejercicio24 {
    public static void main(String[] args) {
        String msg = "Please enter your email\n";
        String user = JOptionPane.showInputDialog(msg);

        int countAt = 0;
        int countDot = 0;


        for (int i = 0; i < user.length(); i++) {
            char c = user.charAt(i);
            if (c == '@') {
                countAt++;
            } else if (c == '.') {
                countDot++;
            }
        }
        if (countAt != 1 || countDot != 1) {
            System.out.println("No es correcto");
        } else {
            System.out.println("Es correcto");
        }
    }
}