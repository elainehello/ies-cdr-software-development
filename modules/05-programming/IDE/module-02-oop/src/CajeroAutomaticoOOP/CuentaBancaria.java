package CajeroAutomaticoOOP;

public class CuentaBancaria {
    //attributes
    private String titular;
    private int pin;
    private double saldo;

    // constructor with parameters
    public CuentaBancaria(String titular, int pin, double saldo) {
        this.titular = titular;
        this.pin = pin;
        this.saldo = saldo;
    }

    //methods
    public boolean comprobarPin(int pinIntroducido) {
        return (pin == pinIntroducido);
    }

    public void ingresar(double cantidad) {
        if (cantidad > 0) {
            saldo += cantidad;
            System.out.printf("Current balance after ingresar(): %.2f", this.saldo);
        } else {
            System.out.printf("The quantity must be positive, user input %.2f", cantidad);
        }
    }

    public void retirar(double cantidad) {
        if (saldo >= cantidad) {
            saldo -= cantidad;
            System.out.printf("Current balance after retirar(): %.2f", this.saldo);
        } else if (cantidad > saldo) {
            System.out.println("Insufficient balance\n");
        }
    }

    public void consultarSaldo() {
        System.out.printf("Current balance consultarSaldo called %.2f\n\n", this.saldo);
    }

    public void cambiarPin(int nuevoPin) {
        if (nuevoPin > 0 && nuevoPin < 9999) {
            this.pin = nuevoPin;
            System.out.println("Pin changed successfully!");
        } else {
            System.out.println("Pin must remain in 4 digits!\n");
        }
    }

    @Override
    public String toString() {
        return "Titular: " + this.titular +
                " | " + "Saldo :" + this.saldo;
    }
}
