package ParkingManagementOOP;

public class Aparcamiento {
    //attributes
    private String nombre;
    private int plazasTotales;
    private int plazasOcupadas;
    private boolean plazasLibres = false;

    //constructor
    public Aparcamiento(String nombre, int plazasTotales) {
        this.nombre = nombre;
        this.plazasTotales = plazasTotales;
        this.plazasOcupadas = 0;
    }

    public boolean hayPlazas() {
        if (plazasTotales - plazasOcupadas > 0) {
            plazasLibres = true;
            return plazasLibres;
        } else {
            return plazasLibres;
        }

    }

    public void aparcharCoche(Coche coche) {
        if (hayPlazas() && !coche.estaAparcado()) {
            coche.aparcar();
            plazasOcupadas++;
        }
    }

    public void sacarCoche(Coche coche) {
        if (coche.estaAparcado()) {
            coche.salir();
            plazasOcupadas--;
        }
    }

    public void mostrarEstado() {

        System.out.println("Parking Central" +
                "\nPlazas ocupadas: " + this.plazasOcupadas +
                "\nPlazas Libres: " + (this.plazasTotales - this.plazasOcupadas));
    }

    @Override
    public String toString() {
        return String.format("Parking Central: %d/%d plazas ocupadas", plazasOcupadas, plazasTotales);
    }

}
