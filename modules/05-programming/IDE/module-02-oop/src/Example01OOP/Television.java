package Example01OOP;

public class Television {
    // attribute
    private int channel;

    // constructor
    public Television () {
        this.channel = 1;
    }

    // contructor receiving parameters
    public Television(int channelValue) {
        this.channel = channelValue;
    }

    // Getter and Setter
    public void increaseChannel() {
        this.channel++;
    }

    public void decreaseChannel() {
        this.channel--;
    }

    public int getChannel() {
        return channel;
    }

    public void setChannel(int channelValue) {
        if (channelValue > 0 && channelValue < 100) {
            this.channel = channelValue;
        } else {
            this.channel = 1;
        }
    }
}
