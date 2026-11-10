package BubbleSort;

import java.util.Arrays;
import java.util.Scanner;

public class Exercise4_4 {
    public static void main(String[] args) {
        System.out.println("Indica el número de alumnos: ");

        Scanner sc = new Scanner(System.in);
        int numAlumnos = sc.nextInt();
        double[] notas = leerNotas(sc, numAlumnos);
        System.out.println("Notas originales:");
        mostrarNotas(notas);
        System.out.println("Notas ordenadas (menor a mayor):");
        bubbleSort(notas);

    }

    public static double[] leerNotas(Scanner sc, int numAlumnos) {
        double[] arrNotas = new double[numAlumnos];
        for (int i = 0; i < arrNotas.length; i++) {
            System.out.printf("Introduce la nota del alumno %d: ", i+1);
            arrNotas[i] = sc.nextDouble();
        }
        return arrNotas;
    }

    // functional programming if im not mistaken
    //    public static void mostrarNotas(double[] notas) {
    //        Arrays.stream(notas).forEach(System.out::println);
    //    }


    public static void mostrarNotas(double[] notas) {

        System.out.print("[");

        for (int i = 0; i < notas.length; i++) {
            System.out.print(notas[i]);

            if (i < notas.length - 1) {
                System.out.print(", ");
            }
        }

        System.out.println("]\n");
    }

    // sorting algorithm bubble sort
    public static void bubbleSort(double[] notas) {
        double temp;
        int arrLength = notas.length;
        boolean flag_control = false;

        for (int i = 0; i < arrLength - 1; i++) {
            flag_control = false;
            for (int j = 0; j < arrLength - i - 1; j++) {
                if (notas[j] > notas[j+1]) {
                    temp = notas[j];
                    notas[j] = notas[j+1];
                    notas[j+1] = temp;
                    flag_control=true;
                 }
            }
            if (!flag_control)
                break ;
        }
        mostrarNotas(notas);
    }
}
