import java.util.Scanner;

public class Calculadora {
    public static void main(String[] args) {
        Scanner miScan = new Scanner(System.in);
        System.out.println("Calculadora que suma dos números enteros");
        System.out.print("Introduce el primer número: ");
        int num1 = Integer.parseInt(miScan.nextLine());
        System.out.print("Introduce el segundo número: ");
        int num2 = Integer.parseInt(miScan.nextLine());
        int resultado = num1 + num2;
        System.out.println("El resultado es: " + resultado);
    }
}
