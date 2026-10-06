package Example02OOP;

public class Main {
    public static void main(String[] args) {
        Circle circle = new Circle();
        Circle circle2 = new Circle(100, "blue", 100, 100);

        System.out.printf("Radio " + circle.getRadio());
        System.out.println();
        circle.decreaseRadio();
        System.out.printf("\nRadio decrease method %f\n", circle.getRadio());
        System.out.println("Circle area " + circle.area());
        System.out.println(circle.toString());
        //==================================================================
        System.out.printf("Circle 2: radio size %f\n", circle2.getRadio());
        System.out.printf("Circle 2 area: %f\n",circle2.area());
        circle2.setRadio(42);
        System.out.printf("new area circle 2: %f", circle2.area());
    }
}
