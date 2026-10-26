package CajeroAutomaticoOOP;

import java.util.Scanner;

public class ProbarCajero {
    public static void main(String[] args) {
        CuentaBancaria ct1 = new CuentaBancaria("Elaine", 1234, 1000);
        Scanner sc = new Scanner(System.in);
        int option;

        do {
            String cajeroStr = """
                ======= CAJERO AUTOMÁTICO =======
                1. Consultar saldo
                2. Ingresar dinero
                3. Retirar dinero
                4. Cambiar PIN
                5. Salir
                """;


            System.out.printf("%s\n\nPick a number:\n", cajeroStr);
            option = sc.nextInt();

            // clean buffer skipping line break \n
            sc.nextLine();

            switch(option) {
                case 1:
                    ct1.consultarSaldo();
                    break;
                case 2:
                    System.out.println("Enter quantity to deposit:\n");
                    ct1.ingresar(sc.nextDouble());
                    break;
                case 3:
                    System.out.println("Enter quantity to withdraw:\n");
                    ct1.retirar(sc.nextDouble());
                    break;
                case 4:
                    System.out.println("Enter new PIN:\n");
                    ct1.cambiarPin(sc.nextInt());
                    break;
                case 5:
                    break;
                default:
                    System.out.println("Invalid number\n");
                    break;
            }

        } while (option != 5);
    }
}
