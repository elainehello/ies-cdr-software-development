package CocheOOP;

public class Coche {
    // attributes private (encapsulation principle) do not allow access
    private int ruedas;
    private int largo;
    private int ancho;
    private int motor;
    private int peso_plataforma;
    private String color;
    private int peso_total;
    private boolean asientos_cuero;
    private boolean climatizador;

    public Coche () {
        this.ruedas = 4;
        this.largo = 2000;
        this.ancho = 300;
        this.motor = 1600;
        this.peso_plataforma = 500;
    }

    public String dimeDatosGenerales() {
        return "El coche tiene " + this.ruedas + " ruedas " + "de largo" + this.largo +
                " de ancho " + this.ancho + " su motor tiene " + this.motor + "cc" +
                " y peso de plataforma de " + this.peso_plataforma;
    }

    public void estableceColor(String colorCoche) {
        this.color = colorCoche;
    }

    public String dimeColor() {
        return color;
    }


}
