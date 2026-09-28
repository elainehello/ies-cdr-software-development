package AuxVar;

public class Ejercicio24 {
    public static void main(String [] args) {
        int myVarOne = 5;
        int myVarTwo = 10;
        int aux = myVarOne;
        myVarOne = myVarTwo;
        myVarTwo = aux;

        System.out.printf("var one %d second var %d", myVarOne, myVarTwo);

    }
}
