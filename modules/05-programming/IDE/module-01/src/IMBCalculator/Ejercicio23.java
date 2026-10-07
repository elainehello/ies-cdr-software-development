package IMBCalculator;


import javax.swing.*;

public class Ejercicio23 {
    public static void main(String[] args) {
        String welcome = """
                Hello Enter your gender
                Either (Feminine or Masculine)
                options (F or M)
                """;

        String gender = JOptionPane.showInputDialog(welcome);
        System.out.printf("%s\n", gender);

        do {

        } while (!gender.equalsIgnoreCase("f") &&
        !gender.equalsIgnoreCase("m"));
    }
}
