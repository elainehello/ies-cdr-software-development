package VendingMachineOOP;

import java.util.Scanner;

public class TestMachine {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        Producto producto = new Producto("Refresco", 1.50, 10);

        int option;
        do {
            System.out.println("""
                \n===== MÁQUINA EXPENDEDORA =====
                1. Ver producto
                2. Comprar producto
                3. Vender producto
                4. Rellenar stock
                5. Salir
                """);
            System.out.println("Pick a number");
            option = sc.nextInt();
            sc.nextLine();

            switch(option) {
                case 1:
                    producto.mostrarInformacion();
                    break;
                case 2:
                    producto.venderProducto();
                    break;
                case 3:
                    producto.addProducto();
                    break;
                case 4:
                    System.out.println("Enter hay many units you want to add\n");
                    producto.updateStock(sc.nextInt());
                case 5:
                    break;
                default:
                    break;
            }


        } while (option != 5);
    }
}
