package ParkingManagementOOP;

public class Coche {
    //attributes
    private String matricula;
    private String marca;
    private boolean aparcado = false;

    // constructor
    public Coche(String matricula, String marca) {
        this.matricula = matricula;
        this.marca = marca;
        this.aparcado = false;
    }

    public void aparcar() {
        if (!aparcado) {
            aparcado = true;
        }
    }

    public void salir() {
        if (aparcado) {
            aparcado = false;
        }
    }

    public boolean estaAparcado() {
        return aparcado;
    }

    @Override
    public String toString() {
        String str;
        if (estaAparcado()) {
            str = "Aparcado";
        } else {
            str = "No Aparcado";
        }
        return "Matrícula: " + matricula +
                "\nMarca: " + marca +
                "\nEstado: " + str;
    }
}
