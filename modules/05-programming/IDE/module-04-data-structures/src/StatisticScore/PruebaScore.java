package StatisticScore;

import java.util.Scanner;

public class PruebaScore {
    public static void main(String[] args) {
        CalculateScore cs = new CalculateScore();
        Scanner sc = new Scanner(System.in);
        int students;

        System.out.println("Indica el número de alumnos:\n");
        students = sc.nextInt();
        cs.leerNotas(sc, students);
        sc.nextLine();

        sc.close();
    }
}
