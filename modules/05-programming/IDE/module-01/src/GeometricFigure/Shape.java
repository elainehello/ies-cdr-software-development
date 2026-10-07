package GeometricFigure;

import java.util.Locale;
import java.util.Scanner;

enum shapeType {
    Cuadrado,
    Rectangulo,
    Triangulo,
    Circulo
}

public class Shape {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in); // accepts 2.5 instead of 2,5

        System.out.println("--- MENÚ DE FIGURAS GEOMÉTRICAS ---");
        System.out.println("1. Cuadrado (Square)");
        System.out.println("2. Rectángulo (Rectangle)");
        System.out.println("3. Triángulo (Triangle)");
        System.out.println("4. Círculo (Circle)");
        System.out.print("Seleccione una opción (1-4) o escriba el nombre: ");

        String input = sc.next().toLowerCase();

        // Convert the text into the enum
        shapeType type = switch (input) {
            case "1", "cuadrado" -> shapeType.Cuadrado;
            case "2", "rectangulo" -> shapeType.Rectangulo;
            case "3", "triangulo" -> shapeType.Triangulo;
            case "4", "circulo" -> shapeType.Circulo;
            default -> throw new IllegalArgumentException("Tipo no soportado");
        };

        shape(type, sc);
        sc.close();
    }

    public static void shape(shapeType type, Scanner sc) {
        // Declarations go BEFORE the switch, not inside it
        double area = 0.0;

        switch (type) {
            case Cuadrado:
                System.out.println("Enter square side");
                double side = sc.nextDouble();
                area = side * side;
                System.out.printf("The square area is %.2f%n", area);
                break;
            case Rectangulo:
                System.out.println("Enter rectangle width");
                double width = sc.nextDouble();
                System.out.println("Enter rectangle height");
                double height = sc.nextDouble();
                area = width * height;
                System.out.printf("The rectangle area is %.2f%n", area);
                break;
            case Triangulo:
                System.out.println("Enter triangle base");
                double base = sc.nextDouble();
                System.out.println("Enter triangle height");
                double h = sc.nextDouble();
                area = (base * h) / 2;
                System.out.printf("The triangle area is %.2f%n", area);
                break;
            case Circulo:
                System.out.println("Enter circle radius");
                double radius = sc.nextDouble();
                // Math.PI aka 3.14 value
                area = Math.PI * Math.pow(radius, 2);
                System.out.printf("The circle area is %.2f%n", area);
                break;
            default:
                System.out.println("Incorrect option\n");
                break;
        }
    }
}