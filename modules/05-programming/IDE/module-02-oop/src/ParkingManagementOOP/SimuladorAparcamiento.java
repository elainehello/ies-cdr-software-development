package ParkingManagementOOP;

import java.util.Scanner;

public class SimuladorAparcamiento {
    public static void main(String[] args) {
        Aparcamiento parking = new Aparcamiento("Parking Central", 10);
        Coche coche1 = new Coche("1234ABC", "Toyota");
        Coche coche2 = new Coche("5678XYZ", "Seat");

        Scanner sc = new Scanner(System.in);
        int option;
        do {
            String block= """
                ===== GESTIÓN DE APARCAMIENTO =====
                1. Aparcar Toyota
                2. Aparcar Seat
                3. Sacar Toyota
                4. Sacar Seat
                5. Ver estado del aparcamiento
                6. Ver información de los coches
                7. Salir
                """;
            System.out.printf("%s\nPick a number\n", block);

            option = sc.nextInt();
            sc.nextLine();
            switch (option) {
                case 1:
                    parking.aparcharCoche(coche1);
                    System.out.println(coche1.estaAparcado() ? "Aparcado" : "No Aparcado");
                    break;
                case 2:
                    parking.aparcharCoche(coche2);
                    System.out.println(coche2.estaAparcado() ? "Aparcado" : "No Aparcado");
                    break;
                case 3:
                    parking.sacarCoche(coche1);
                    System.out.println(coche1.toString());
                    break;
                case 4:
                    parking.sacarCoche(coche2);
                    System.out.println(coche2.toString());
                    break;
                case 5:
                    parking.mostrarEstado();
                    break;
                case 6:
                    System.out.println(coche1.toString());
                    System.out.println("===============");
                    System.out.println(coche2.toString());
                    break;
                case 7:
                    System.out.println("Closing program...\n");
                    break;
                default:
                    System.out.println("Invalid number");
                    break;
            }

        } while (option != 7);
        sc.close();

    }

}
