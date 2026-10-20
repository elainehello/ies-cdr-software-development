package HotelOOP;

import java.util.Scanner;

public class PruebaHotel {
    public static void main(String[] args) {
        Bedroom br1 = new Bedroom(101, 80.0);
        Scanner sc = new Scanner(System.in);
        System.out.println("""
                ===== HOTEL =====
                1. Consultar habitación
                2. Reservar habitación
                3. Liberar habitación
                4. Calcular precio de estancia
                5. Salir
                """);
        switch(sc.nextInt()) {
            case 1:
                System.out.printf("%s", br1.consultarEstado());
                break;
            case 2:
                System.out.println("Please enter your name\n");
                String name = sc.next();
                System.out.printf("%s", br1.reservar(name));
                break;
            case 3:
                br1.liberar();
                break;
            case 4:
                System.out.println("Please enter how many nights you want to stay");
                System.out.printf("%s", br1.calcularPrecio(sc.nextInt()));
                break;
            case 5:
                break;
            default:
                break;

        }
        sc.close();
    }

}
