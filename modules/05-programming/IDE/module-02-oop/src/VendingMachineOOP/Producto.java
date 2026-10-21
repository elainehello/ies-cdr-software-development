package VendingMachineOOP;

public class Producto {
    //attributes
    private String name;
    private double price;
    private int stock;
    private double coke = 1.0;

    //constructor
    public Producto(String name, double price, int stock) {
        this.name = name;
        this.price = price;
        this.stock = stock;
    }

    public void mostrarInformacion() {
        System.out.println("\nNombre: " + name +
                "\nPrecio: " + price + "\nUnidades disponibles: " + stock
                );
    }

    public boolean hayStock() {
        if (stock > 0) {
            return true;
        } else {
            return false;
        }
    }

    public void venderProducto() {
        if (stock != 0) {
            stock -= 1;
            price -= coke;
            System.out.printf("Your change is %.2f €", price);
            System.out.printf("Unit left %d units", stock);
        } else {
            return ;
        }
    }

    public void addProducto() {
        stock += 1;
    }

    public void updateStock(int userStock) {

        System.out.printf("Before updating stock %d\n", stock);
        if (userStock > 0) {
            stock += userStock;
            System.out.printf("Current units: %d\n", stock);
        } else {
            return ;
        }
    }

    public double getPrecio() {
        return price;
    }

    @Override
    public String toString() {
        return "Product descripcion\nNombre: " + name;
    }

}
