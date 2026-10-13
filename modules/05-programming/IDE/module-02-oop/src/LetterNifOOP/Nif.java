package LetterNifOOP;

import javax.swing.*;
import java.text.Format;

public class Nif {
    // attributes
    private char letra;
    private int nif;

    //  constructor without parameters
    public Nif () {
    }

    // constructor with parameters
    public Nif(int num, char letra) {
        this.nif = num;
        this.letra = letra;
    }

    public void read(int n) {
        //String msg = "Please, enter your NIF number\n";
        //this.nif = Integer.parseInt(JOptionPane.showInputDialog(msg));
        //calculateLetter(this.nif);

        //calculateLetterEnhanced(this.nif);
        this.nif = n;
        calculateLetterEnhanced(n);
        System.out.printf("The complete NIF is: %d-%c", this.nif, this.letra);
    }

    private void calculateLetter(int n) {
        int letterToChar = n % 23;

        switch (letterToChar) {
            case 0:
                this.letra = 'T';
                break;
            case 1:
                this.letra = 'R';
                break;
            case 2:
                this.letra = 'W';
                break;
            case 3:
                this.letra = 'A';
                break;
            case 4:
                this.letra = 'G';
                break;
            case 5:
                this.letra = 'M';
                break;
            case 6:
                this.letra = 'Y';
                break;
            case 7:
                this.letra = 'F';
                break;
            case 8:
                this.letra = 'P';
                break;
            case 9:
                this.letra = 'D';
                break;
            case 10:
                this.letra = 'X';
                break;
            case 11:
                this.letra = 'B';
                break;
            case 12:
                this.letra = 'N';
                break;
            case 13:
                this.letra = 'J';
                break;
            case 14:
                this.letra = 'Z';
                break;
            case 15:
                this.letra = 'S';
                break;
            case 16:
                this.letra = 'Q';
                break;
            case 17:
                this.letra = 'V';
                break;
            case 18:
                this.letra = 'H';
                break;
            case 19:
                this.letra = 'L';
                break;
            case 20:
                this.letra = 'C';
                break;
            case 21:
                this.letra = 'K';
                break;
            case 22:
                this.letra = 'E';
                break;
        }
    }

    private void calculateLetterEnhanced(int n) {
        char[] isAlphabet = {'T', 'R', 'W', 'A', 'G',
                            'M', 'Y', 'F', 'P', 'D',
                            'X', 'B', 'N', 'J', 'Z',
                            'S', 'Q', 'V', 'H', 'L',
                            'C', 'K', 'E'};

        int letterToChar = n % 23;
        this.letra = isAlphabet[letterToChar];
    }

    @Override
    public String toString() {
        return "The complete NIF is: " + this.nif + "-" + this.letra;
    }
}
