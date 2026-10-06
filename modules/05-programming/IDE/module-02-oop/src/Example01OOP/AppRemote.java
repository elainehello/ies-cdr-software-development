package Example01OOP;

public class AppRemote {
    public static void main(String[] args) {
        // object creation
        Television tv1 = new Television();
        Television tv2 = new Television(8);

        // call to increase method from Television (class)
        tv1.increaseChannel();
        System.out.printf("current channel number tv1 %d\n", tv1.getChannel());
        // call to decrease method from Television (class)
        tv1.decreaseChannel();
        System.out.println("channel decrease " + tv1.getChannel());
        //====================================================================
        System.out.println();
        tv2.increaseChannel();
        System.out.printf("Current channel tv2 %d", tv2.getChannel());
        System.out.println();
        tv2.setChannel(19);
        System.out.println("Channel changed to " + tv2.getChannel());
    }
}
