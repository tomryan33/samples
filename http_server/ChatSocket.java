import java.io.DataInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;
import java.util.ArrayList;

public class ChatSocket {

    // Contains the list of rooms currently on the server
    private static ArrayList<Room> rooms_ = new ArrayList<>();

    // Handles client's request to join a chat room
    public synchronized static void joinRoom(Socket client, String name, String user) throws IOException {
        Room roomToJoin = null;

        // Loops through rooms to see if the joining room already exists
        for (Room room : rooms_){
            room.removeUser(client);    // Remove client from other rooms
            if (room.getName().equals(name)){
                // Room already exists
                roomToJoin = room;
                room.joinUser(client, user);  // Add user to that room
            }
        }
        if (roomToJoin == null){
            // Room does not exist
            roomToJoin = new Room(client, name);  // Create new room
            rooms_.add(roomToJoin);               // Add room to rooms_ array
            roomToJoin.notifyNewUser(client, user);
        }
    }

    // Handles an incoming socket stream
    static void handleSocketStream(Socket client) throws IOException {

        // Put socket stream into a DataInputStream for better use
        DataInputStream stream = new DataInputStream(client.getInputStream());

        byte[] b1 = stream.readNBytes(1);       // Get Byte 1
        int opcode = b1[0] & 0x0F;                  // Get Opcode from byte 1
        if (opcode == 8){ client.close(); }         // If opcoade == 8 close the connection

        byte[] b2 = stream.readNBytes(1);       // Get Byte 2
        boolean masked = (b2[0] & 0x80) != 0;       // Check to see if the payload is masked

        int lenGuess = b2[0] & 0x7F;                // Get the length of the payload
        if (lenGuess == 126) {
            // if length == 126 then the payload length follows
            byte[] b3_4 = stream.readNBytes(2);
            lenGuess = b3_4[0] + b3_4[1];
        } else if (lenGuess == 127){
            // If length == 127 then the payload length follows
            byte[] b3_10 = stream.readNBytes(7);
            lenGuess = 0;
            for (byte b : b3_10){
                lenGuess += b;
            }
        }

        byte[] maskKey = new byte[4];
        if (masked){  maskKey = stream.readNBytes(4); }         // Get the mask key

        byte[] payload = stream.readNBytes(lenGuess);               // Read in payload

        if (masked){
            // The payload is masked
            byte[] decoded = new byte[lenGuess];                    // Create a new decoded byte array
            for (int i = 0; i < payload.length; i++){
                decoded[i] = (byte) (payload[i] ^ maskKey[i % 4]);  // decode a byte of the encoded payload
            }
            payload = decoded;
        }

        printsBytesToChar(payload);

        // Process the message
        processMessage(client, payload);
    }

    // Handles processing socket message
    private static void processMessage(Socket client, byte[] msg) throws IOException {
        String message = bytesToCharString(msg);            // Converts incoming byte message to string
        String arr[] = message.split(" ", 2);   // Split array (first word : message)
        if (arr[0].equals("join")){
            // First word == join
            String joinArr[] = arr[1].split(" ", 2); // Split array (roomname, username)
            joinRoom(client, joinArr[0], joinArr[1]);       // Calls join room function
        } else {
            // First word is probably username
            // Loops through rooms, if client is in that room sends message to current client
            for (Room r : rooms_){
                r.newMessage(client, arr[0], arr[1]);   // Send message to current client
            }
        }


    }

    // Handles sending message back to client
    public static void sendMessageBack(Socket client, byte[] msg) throws IOException {
        OutputStream msgOutput = client.getOutputStream();  // Starts output stream
        msgOutput.write((byte) 0x81);                       // First byte (includes opcode)

        // Check the message length
        if (msg.length < 126 ) {
            // Less than 126 - write out length
            msgOutput.write((byte) msg.length);
        } else if (msg.length == 126){
            // Equals 126 - write out 126 then length
            msgOutput.write((byte) 126);
            msgOutput.write((byte) msg.length);
        } else {
            // Greater than 126 - Write out 127 then length
            msgOutput.write((byte) 127);
            msgOutput.write((byte) msg.length);
        }
        msgOutput.write(msg);   // Write out message
        msgOutput.flush();      // Send full response to client
    }

    // This is a helper function that prints out byte array
    public static void printsBytesToChar(byte[] bytes){
        for (byte b : bytes){
            System.out.print((char)b);
        }
        System.out.println();
    }

    // This is a helper function to convert byte array to string
    public static String bytesToCharString(byte[] bytes){
        String output = "";
        for (byte b : bytes){
            output += (char)b;
        }
        return  output;
    }
}
