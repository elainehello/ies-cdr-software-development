package CastingUsage;

public class ProgramCasting {
    public static void main(String[] args) {
        // Using data type casting in var assigment
        double nbr1 = 9.15;
        int nbr2 = (int)nbr1;
        int nbr3 = 257;
        byte nbr4 = (byte)nbr3;
        float nbr5 = (float)nbr1;
        System.out.printf("%f\n%d\n%dª\n%c\n%f", nbr1, nbr2, nbr3, nbr4, nbr5);
    }
}
