package PasswordValidator;

import javax.swing.*;

public class Ejercicio25 {
    public static void main(String[] args) {
        String msg = "Please enter password";
        boolean control = false;
        String user = JOptionPane.showInputDialog(msg);

        String valid = "Elaine";
        boolean validPwd= valid.equals(user);
        while (validPwd && !control) {
            System.out.println("Password correct!");
        }
        System.out.println("Invalid password");
    }
}
