package ChainManipulation;



public class ManipulaCadenas {
    public static void main(String[] args) {
        String miNombre = "Elaine";

        // muestra por pantalla tu nombre
        System.out.printf("Hola, mi nombre es %s\n", miNombre);
        // muestra la longitud de tu nombre
        System.out.printf("La longitud de la cadena es %d\n", miNombre.length());
        // muestra por pantalla la tercera letra de tu nombre
        System.out.printf("La tercera letra de mi nombre es %s\n", miNombre.charAt(2));
        //System.out.printf("La tercera letra de mi nombre es %d\n", miNombre.indexOf('a'));

        // calcula y muestra la ultima letra de tu nombre utilizando el metodo .length() y .chatAt()
        System.out.printf("la ultima letra de mi nombre es %s\n", miNombre.charAt(miNombre.length()-1));

        // Declara una variable String frase con el valor "En un lugar de la Mancha"
        // extrae con .substring() un trozo de la frase (desde la posicion 5 hasta la 15) y muestralo por pantalla
        String textPhrase =  "En un lugar de la Mancha";
        System.out.printf("original: %s\nafter .substring() usage >>>%s<<<<\n", textPhrase, textPhrase.substring(5, 15));


        String nombreUno = "Elaine";
        String nombreDos = "ELaine";
        // Declara dos cadenas de texto, nombre1, nombre2, asignandoles tu nombre en mayusculas y minusculas, respectivamente
        System.out.printf("\n%b", nombreUno.equals(nombreDos));
        System.out.printf("\n%b", nombreUno.equalsIgnoreCase(nombreDos));
        //


    }
}
