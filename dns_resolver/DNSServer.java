import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.ArrayList;

/**
 * A simple DNS Resolver Server
 * @author Ryan Clayton
 * Description: This DNS resolver take a DNS request, decodes it, finds the answer, and response with the answer.
 *
 * Server Flow:
 *  - Request through port 8053
 *  - Converts request from byte array to message object
 *    - Builds a header object
 *    - Builds record objects for questions, answers, and addiontal records
 *  - Takes the question and checks to see if the answer is already in the cache
 *    - If it is not in the cache, send same request to google for answers
 *    - Store googles answer into the cache
 *  - Build a response message object with orginal information, including the new answer
 *  - Encode that message object into a byte array
 *  - Respond back to requester
 */
public class DNSServer {

    /**
     * This is the main call to start the DNS server.
     * @param args this program does not use any command line arguments
     * @throws IOException catch all of any input stream errors
     */
    public static void main(String[] args) throws IOException {
        DatagramSocket ds = new DatagramSocket(8053);                       // This DNS server datagram socket
        DatagramSocket gs = new DatagramSocket(53);                         // Google datagram socket

        while (true) {                                                      // Continuous running server
            byte[] buf = new byte[512];                                     // Byte array to write the DNS request on
            DatagramPacket dp = new DatagramPacket(buf, 512);
            ds.receive(dp);                                                 // Wait for incoming request

            DNSMessage message = DNSMessage.decodeMessage(buf);             // Turn byte array into a message object
            System.out.println("Incoming Header: " + message);

            ArrayList<DNSRecord> answers = new ArrayList<>();               // Storage for answers of request questions
            for (DNSQuestion question : message.getQuestions()){            // Loop through each question
                if (cache_.contains(question)){                             // Check to see if we have the answer already
                    DNSRecord answer = cache_.getRecord(question);          // Get answer from cache
                    answers.add(answer);                                    // Store the answer
                } else {                                                    // If we don't have the answer, ask google

                    // ** Start Talks with Google ** //
                    InetAddress google = InetAddress.getByName("8.8.8.8");
                    DatagramPacket output = new DatagramPacket(message.getBuf(), message.getBuf().length, google, 53);
                    gs.send(output);                                        // Send request to google
                    byte[] googleBuf = new byte[512];
                    DatagramPacket googlePacket = new DatagramPacket(googleBuf, 512);
                    gs.receive(googlePacket);                               // Receive and store response
                    // -- End Talks with Google -- //

                    // Turn response into message object
                    DNSMessage googleMessage = DNSMessage.decodeMessage(googleBuf);
                    System.out.println("Google Header: " + googleMessage);

                    if (googleMessage.getAnswers().size() != 0) {           // Check to see if we received an answer
                        cache_.addRecord(question, googleMessage.getAnswers().get(0));
                        answers.add(googleMessage.getAnswers().get(0));     // Store the answer (also in cache)
                    }
                }
            }
            DNSMessage response = DNSMessage.buildResponse(message, answers);   // Build response message object
            byte[] responseBytes = response.toBytes();                          // Convert message object to byte array
            DatagramPacket responsePacket = new DatagramPacket(responseBytes, responseBytes.length, dp.getAddress(), dp.getPort());
            ds.send(responsePacket);                                            // Send byte array back to requester
        }
    }

    /**
     * Class Object Variables
     * cache_: Cache of all recorded DNS Answers
     */
    private static final DNSCache cache_ = new DNSCache();

}