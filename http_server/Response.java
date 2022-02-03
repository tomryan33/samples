import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class Response {

    // Handles Socket response for upgraded connection
    static void sendSocketResponse(Socket client, String webSocketKey) throws IOException, NoSuchAlgorithmException {
        String key = generateResponseKey(webSocketKey);                           // Calls function to generate response key
        OutputStream clientOutput = client.getOutputStream();                     // Starts the output stream
        clientOutput.write(("HTTP/1.1 101 Switching Protocols\r\n").getBytes());  // Response Header
        clientOutput.write(("Upgrade: websocket \r\n").getBytes());               // Upgrade connection to websocket
        clientOutput.write(("Connection: Upgrade\r\n").getBytes());               // Connection upgrade
        clientOutput.write(("Sec-WebSocket-Accept: " + key + "\r\n").getBytes()); // Websocket key
        clientOutput.write("\r\n".getBytes());                                    // Write blank line for end of header
        clientOutput.flush();                                                     // Send immediately
    }


    // Builds response header for normal connection
    public static void sendResponse(Socket client, String status, String contentType, byte[] content) throws IOException {
        OutputStream clientOutput = client.getOutputStream();                     // Starts output stream
        clientOutput.write(("HTTP/1.1 \r\n" + status).getBytes());                // Response Header with status
        clientOutput.write(("ContentType: " + contentType + "\r\n").getBytes());  // Connection type
        clientOutput.write("\r\n".getBytes());                                    // Write blank line for end of header
        clientOutput.write(content);                                              // Write out requested content
        clientOutput.flush();                                                     // Send immediately
        client.close();                                                           // Close current connection

    }

    // Function to return the requested file bath
    public static Path getFilePath(String path) {
        // If no path name, response with default index.html
        if ("/".equals(path)) {
            path = "/index.html";
        }

        // Change this file path with location of files
        return Paths.get("/Users/ryanc/gitRepo/CS6011/Week3/Day14/resources/", path);
    }

    // Gets type of content
    public static String contentType(Path filePath) throws IOException {
        return Files.probeContentType(filePath);  // This takes best guess for content type
    }

    // Generates the response key for web socket request
    public static String generateResponseKey(String requestKey) throws NoSuchAlgorithmException {
        String provided = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
        requestKey += provided; // Concatenates two string to make magic string
        MessageDigest md = MessageDigest.getInstance("SHA-1");

        byte[] hashed = md.digest( requestKey.getBytes() );             // hashes the string to SHA-1
        String result = Base64.getEncoder().encodeToString( hashed );   // Converts string to Base64

        return result;
    }
}
