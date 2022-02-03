import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

public class Request {

    // Handles Incoming Request
    public static void incomingRequest(Socket client) throws IOException, NoSuchAlgorithmException {
        BufferedReader br = new BufferedReader(new InputStreamReader(client.getInputStream()));

        // Converts the incoming stream into a single string
        StringBuilder requestBuilder = new StringBuilder();
        String line;
        while (!(line = br.readLine()).isBlank()) {
            requestBuilder.append(line + "\r\n");
        }

        // Gets information out of the request string
        String request = requestBuilder.toString();
        String[] requestsLines = request.split("\r\n");     // Splits up headers into individual lines
        String[] requestLine = requestsLines[0].split(" "); // Splits up first line into components
        String method = requestLine[0];                           // Gets Method
        String path = requestLine[1];                             // Gets File Path
        String version = requestLine[2];                          // Gets Version
        String host = requestsLines[1].split(" ")[1];      // Gets Host

        // Moves Headers info into an array list
        Map<String, String> headerMap = new HashMap<>();  // Map array to split content up to key - value
        for (int h = 2; h < requestsLines.length; h++) {
            String[] headerContent = requestsLines[h].split(": ");
            headerMap.put(headerContent[0], headerContent[1]);
        }

        // Logs Header
        String accessLog = String.format("Client %s, method %s, path %s, version %s, host %s, headers %s",
                client.toString(), method, path, version, host, headerMap.toString());
        System.out.println(accessLog);

        String webSocketKey = "";

        // Check to see if connection is upgraded
        // If upgraded, connection is a websocket
        if (headerMap.get("Connection").equals("Upgrade")) {
            webSocketKey = headerMap.get("Sec-WebSocket-Key"); // Get the web socket key
        }

        // Check to see if there is a web socket key
        // If not run as normal request
        if (webSocketKey != ""){
            // Run sendSocketResponse (See Response.java)
            Response.sendSocketResponse(client, webSocketKey);
            // Start running web socket connection
            while (true){
                // handles incoming request from socket stream (See ChatSocket.java)
                ChatSocket.handleSocketStream(client);
            }
        } else {
            // Gets File path and checks if it exists
            Path filePath = Response.getFilePath(path);
            if (Files.exists(filePath)) {
                // File exist
                String contentType = Response.contentType(filePath);

                // Handles response to client with file information (see Response.java)
                Response.sendResponse(client, "200 OK", contentType, Files.readAllBytes(filePath));
            } else {
                // 404
                byte[] notFoundContent = "<h1>404 Not Found</h1>".getBytes();

                // Handles response to client with 404 error (See Response.java)
                Response.sendResponse(client, "404 Not Found", "text/html", notFoundContent);
            }
        }
    }
}
