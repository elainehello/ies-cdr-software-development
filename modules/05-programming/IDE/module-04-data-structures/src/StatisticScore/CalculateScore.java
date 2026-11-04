package StatisticScore;

import java.util.Scanner;

public class CalculateScore {

    public void leerNotas(Scanner sc, int numAlumnos) {
        double[] arrayNbr = new double[numAlumnos];
        //System.out.println("Indica el número de alumnos:\n");
        for (int i = 0; i < arrayNbr.length; i++) {
            System.out.println("\nIntroduce la notas del alumno:\n");
            arrayNbr[i] = sc.nextDouble();
            sc.nextLine();
        }

        System.out.print("\nNotas introducidas: [");
        for (int i = 0; i < arrayNbr.length; i++) {
            System.out.printf("%.1f,", arrayNbr[i]);
        }
        System.out.print("]\n");
        System.out.printf("Nota media del grupo: %.2f\n", calcularMedia(arrayNbr));
        System.out.printf("Nota máxima: %.2f\n", obtenerMaximo(arrayNbr));
        System.out.printf("Nota minima: %.2f\n", obtenerMinimo(arrayNbr));
        mostrarSuperior(arrayNbr, calcularMedia(arrayNbr));
    }

    public double calcularMedia(double[] notas) {
        double avg = 0;

        for (int i = 0; i < notas.length; i++) {
            avg += notas[i];
        }
        return (avg /= notas.length);
    }

    public double obtenerMinimo(double[] notas) {
        double aux = notas[0];

        for (int i = 0; i < notas.length; i++) {
            if (aux > notas[i]) {
                aux = notas[i];
            }
        }
        return (aux);
    }

    public double obtenerMaximo(double[] notas) {
        double aux = notas[0];

        for (int i = 0; i < notas.length; i++) {
            if (aux < notas[i]) {
                aux = notas[i];
            }
        }
        return (aux);
    }

    public void mostrarSuperior(double[] notas, double media) {
        System.out.println("Alumnos con nota superior a la media:\n");
        for (int i = 0; i < notas.length; i++) {
            if (notas[i] > media) {
                System.out.printf("Alumno %d -> Nota: %.2f\n", i, notas[i]);
            }

        }
    }

}
