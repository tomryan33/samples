import java.io.*;
import java.net.Socket;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Scanner;

public class Room {
    private String roomName_;                                 // Contains room name
    private ArrayList<Socket> clients_ = new ArrayList<>();  // Contains list of clients in room
    private File logFile_;

	// Constructor for room
    public Room(Socket client, String roomName) throws IOException {
	    roomName_ = roomName;    // Sets room name
	    clients_.add(client);    // Adds client to this room;
        Path path = Response.getFilePath(roomName_ + ".txt");
        logFile_ = new File(String.valueOf(path));
        if (logFile_.exists()){
            // ** Write out log file for client
            processLogFile(client); // Print out past messages from log file
        }
    }

    // Helper method to return this room name
    public synchronized String getName(){ return roomName_; }

    // Function to add client to this room
    public synchronized void joinUser(Socket client, String user) throws IOException {
        clients_.add(client);   // Adds client to ArrayList
        // ** Notifying other users that user is joining chat
        for (Socket c : clients_){
            notifyNewUser(c, user);
        }

        // ** Write out log file for client
        processLogFile(client);
    }

    // Remove user from this room
    public void removeUser(Socket client) {
        clients_.remove(client);
    }

    // Handles letting other users know a user joined the room
    public void notifyNewUser(Socket client, String user) throws IOException {
        // Build JSON response
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        outputStream.write("{ \"join\" : \"".getBytes());
        outputStream.write(roomName_.getBytes());  // Room Name
        outputStream.write("\", \"user\" : \"".getBytes());
        outputStream.write(user.getBytes());  // Username
        outputStream.write("\" }".getBytes());

        ChatSocket.sendMessageBack(client, outputStream.toByteArray());    // After joined room let user know they've joined room
    }

    private void processLogFile(Socket client) throws IOException {
        // ** After new client is added this returns all the past messages from the room to the client
        Scanner log = new Scanner(logFile_);
        while (log.hasNext()){
            ChatSocket.sendMessageBack(client, log.nextLine().getBytes());
        }
    }

    // Handles incoming new message
	public void newMessage(Socket client, String user, String message) throws IOException {
	   boolean thisRoom = false;
	   for (Socket c : clients_){
		   if (c.equals(client)){
               // We are working with this room
               ByteArrayOutputStream output = JSONMessage(user, message);   // Build JSON response

               for (Socket cl : clients_) {
                   // Sending JSON response of message to all clients
                   ChatSocket.sendMessageBack(cl, output.toByteArray()); // Sends JSON message to client
               }

               writeMessageToFile(output.toString());   // Add message to log file
		   }
	   }
	}

    // Handles building a JSON response
	private ByteArrayOutputStream JSONMessage(String user, String message) throws IOException {
        // Get Timestamp
        String arr[] = message.split("-", 2);
        String timestamp = arr[0];
        message = arr[1];

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();   // Starts new output stream
        outputStream.write("{ ".getBytes());                    //  {
        outputStream.write("\"user\" : \"".getBytes());         //      "user" :
        outputStream.write(user.getBytes());                    //          "USERNAME",
        outputStream.write("\", \"timestamp\" : \"".getBytes());//      "timestamp" :
        outputStream.write(timestamp.getBytes());               //          "TIMESTAMP",
        outputStream.write("\", \"message\" : \"".getBytes());  //      "message" :
        outputStream.write(message.getBytes());                 //          "MESSAGE"
        outputStream.write("\" }".getBytes());                  //  }
        return outputStream;
	}

    // Write message to log file to be used later
    private void writeMessageToFile(String JSON) throws IOException {
        PrintWriter outputTo = new PrintWriter(new FileWriter(logFile_, true));
        outputTo.write(JSON);
        outputTo.write("\r\n");
        outputTo.flush();
        outputTo.close();
    }
}
