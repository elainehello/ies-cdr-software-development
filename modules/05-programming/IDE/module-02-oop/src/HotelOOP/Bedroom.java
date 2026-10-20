package HotelOOP;

public class Bedroom {
    //atributes
    private int number;
    private double nightPrice;
    private boolean busy;
    private String client;

    //constructor
    public Bedroom(int number, double nightPrice, boolean busy, String client) {
        this.number = number;
        this.nightPrice = nightPrice;
        this.busy = busy;
        this.client = client;
    }

    public Bedroom(int habitacion, double precio) {
        this.number = habitacion;
        this.nightPrice = precio;
    }

    public String reservar(String clientName) {
        if (!busy) {
           this.client = clientName;
           this.busy = true;
           return "Bedroom reserved to: " + client;
        } else {
            return "Failed to reserved bedroom";
        }
    }

    public void liberar() {
        if (busy) {
            this.busy = false;
            this.client = "";
        }
    }

    public String consultarEstado() {
        if (busy) {
            return "\nHabitacion: " + number +
                "\n Precio: " + nightPrice +
                "\n Estado" + busy +
                "\n Cliente: " + client;

        } else {
            return "\n Habitacion: " + number +
                    "\n Precio: " + nightPrice +
                    "\n Estado: " + busy;
        }
    }

    public int calcularPrecio(int noches) {
        return (int) nightPrice * noches;
    }
}
