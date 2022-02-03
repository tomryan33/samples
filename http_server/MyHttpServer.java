import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.security.NoSuchAlgorithmException;

// Start of HTTP Server
// Created by Ryan Clayton
// NOTES:
// • This is an HTTP server that can handle simple web requests
// • This server can also handle web socket upgrades
// • The main purpose of this server is to handle a simple unsecure chat room
// • Features of the chat room server include:
//    - Creation of room log files to store past messages
//    - When new user joins room they receive past messages from log files
//    - Store timestamp of messages
//    - Notify Users when a new user joins the chat
//    - JSON response includes additional data ('join' JSON includes "user" and 'message' JSON includes "timestamp")

public class MyHttpServer {

    // Runner class for a new thread
    private static class oneConnection implements Runnable {
        Socket request_; // incoming request variable

        // Constructor
        public oneConnection(Socket request){ request_ = request; }

        // Run method
        @Override
        public void run() {
            try {
                // Calls Request class (See Request.java)
                Request.incomingRequest(request_);
            } catch (IOException | NoSuchAlgorithmException e) {
                e.printStackTrace();
            }
        }
    }


    // Main Class Start Function
    public static void main( String[] args ) throws Exception {

        // Check to see if server socket is open
        try (ServerSocket serverSocket = new ServerSocket(8080)) {

            // Start Running Server
            while (true) {
                Socket clientSocket = null;
                try {
                    // Accept & Attached server socket to client socket variable
                    clientSocket = serverSocket.accept();
                } catch (IOException e){
                    // Print out any errors with server socket accept
                    System.out.println("I/O Error: " + e.getMessage());
                }

                // When a new client connects start a new thread
                new Thread( new oneConnection(clientSocket) ).start();
            }
        } catch (Exception e){
            // Print out any errors with server socket
            System.out.println("Error: " + e.getMessage());
        }
    }

}