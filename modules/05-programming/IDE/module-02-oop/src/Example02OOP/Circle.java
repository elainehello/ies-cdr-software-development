package Example02OOP;

public class Circle {
    //attributes
    final double PI = 3.14;
    private double radio;
    private String color;
    private int centreX;
    private int centreY;

    //constructor
    public Circle(double radio, String color, int centreX, int centreY) {
        this.radio = radio;
        this.color = color;
        this.centreX = centreX;
        this.centreY = centreY;
    }

    // constructor empty
    public Circle() {
        this.radio = 50;
        this.color = "negro";
        this.centreX = 100;
        this.centreY = 100;
    }

    // getters and setter
    public double getRadio () {
        return radio;
    }

    public void setRadio(double radioValue) {
        this.radio = radioValue;
    }

    public void decreaseRadio() {
        this.radio = radio / 1.3;
    }

    public double area() {
        return PI * Math.pow(radio, 2);
    }

    @Override
    public String toString() {
        return String.format("Radio circle %f, color %s, and centreX %d centreY %d", radio, color, centreX, centreY);
    }
}
