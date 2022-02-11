import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * DNS Message Object
 * @author Ryan Clayton
 * Description: This class object contains the objects of the various sections of the message.
 *
 * Methods:
 *  DNSMessage decodeMessage(byte[] buf);
 *  DNSMessage buildResponse(DNSMessage request, ArrayList<DNSRecord> answers);
 *  String[] readDomainName(ByteArrayInputStream input);
 *  String[] readDomainName(int address);
 *  String octectsToString(String[] octets);
 *  byte[] toBytes();
 *  void writeDomainName(ByteArrayOutputStream os, HashMap<String,Integer> domainLocations, String[] domainPieces);
 *  String toString();
 *
 * Getters:
 *  byte[] getBuf();
 *  DNSHeader getHeader();
 *  ArrayList<DNSQuestion> getQuestions();
 *  ArrayList<DNSRecord> getAnswers();
 *  ArrayList<DNSRecord> getNsRecords();
 *  ArrayList<DNSRecord> getArRecords();
 */
public class DNSMessage {

    /**
     * This function decodes incoming messages by decoding the various parts of the
     * message including the header, questions, answers, and additional records.
     * @param buf byte array of the incoming message
     * @return a message object containing all the parts of the message
     * @throws IOException throws any errors with input stream.
     */
    public static DNSMessage decodeMessage(byte[] buf) throws IOException {
        DNSMessage message = new DNSMessage();
        ByteArrayInputStream input = new ByteArrayInputStream( buf );   // Turn byte array into Input Stream

        message.buf_ = buf;                                             // Save byte array

        message.header_ = DNSHeader.decodeHeader( input );              // Decode header section

        message.questions_ = new ArrayList<>();
        for (int i = 0; i < message.header_.getQdCount(); i++) {        // Decode question section(s)
            message.questions_.add( DNSQuestion.decodeQuestion( input, message ) );
        }

        message.answers_ = new ArrayList<>();
        for (int i = 0; i < message.header_.getAnCount(); i++){         // Decode answer section(s)
            message.answers_.add( DNSRecord.decodeRecord( input, message ) );
        }

        message.nsRecords_ = new ArrayList<>();
        for (int i = 0; i < message.header_.getNsCount(); i++){         // Decode additional recode section(s)
            message.nsRecords_.add( DNSRecord.decodeRecord( input, message ) );
        }

        message.arRecords_ = new ArrayList<>();
        for (int i = 0; i < message.header_.getArCount(); i++){         // Decode additional recode section(s)
            message.arRecords_.add( DNSRecord.decodeRecord( input, message ) );
        }

        return message;
    }

    /**
     * Builds a response message linking all the child objects.
     * @param request the original request message containing a lot of the information needed.
     * @param answers the array of answers asked by the original request.
     * @return the response message object.
     */
    public static DNSMessage buildResponse(DNSMessage request, ArrayList<DNSRecord> answers) {
        DNSMessage response = new DNSMessage();                               // The response message object
        response.questions_ = request.questions_;                             // Add question objects to response
        response.answers_ = answers;                                          // Add answer objects to response
        response.nsRecords_ = request.nsRecords_;                             // Add ns record objects to response
        response.arRecords_ = request.arRecords_;                             // Add ar record objects to response
        response.header_ = DNSHeader.buildResponseHeader(request, response);  // Add header object to response
        return response;                                                      // Return response message object
    }

    /**
     * This method interprets an input stream and translates that to a string array.
     * First byte of the input is the number of bytes of the domain section.
     * After reading a section, repeats the process until there is a zero byte length read.
     * @param input the message stream containing the domain to translate.
     * @return a string array with each part of the domain string.
     * @throws IOException throws any errors with input stream.
     */
    public String[] readDomainName(ByteArrayInputStream input) throws IOException {
        int length = input.read();                      // Length of first section

        // If length equals 0xC0 == pointer to domain
        // Read domain at pointer (earlier in the message)
        if (length == 0xC0) return readDomainName( input.read() );

        ArrayList<String> strings = new ArrayList<>();
        while (length != 0) {                           // Loop through sections
            StringBuilder sb = new StringBuilder();

            // Loop through section -> Add byte to string builder
            for (int i = 0; i < length; i++) sb.append( (char)input.read() );

            strings.add(sb.toString());                 // Add string builder to array list
            length = input.read();                      // Read in next byte == length of next section
        }

        // Add strings to string array
        String[] output = new String[strings.size()];
        for (int i = 0; i < strings.size(); i++) output[i] = strings.get( i );

        return output;                                  // return string array
    }

    /**
     * This method finds the domain in the input stream using the address given.
     * @param address the location of the first byter of the domain.
     * @return a string array with each part of the domain string.
     * @throws IOException throws any errors with input stream.
     */
    public String[] readDomainName(int address) throws IOException {
        ByteArrayInputStream is = new ByteArrayInputStream( buf_ ); // Turn byte array into Input Stream
        is.readNBytes( address );                                   // Move to location of domain
        return readDomainName( is );                                // Call readDomainName() with new input stream
    }

    /**
     * This method converts a domain string array into a single readable domain name.
     * @param octets string array of the different sections of the domain.
     * @return a single string with the full domain.
     */
    public static String octectsToString(String[] octets){
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < octets.length; i++){         // Loop through the different sections
            sb.append( octets[i] );                      // Add section to string builder
            if (i != octets.length-1) sb.append( "." );  // If we are between two sections, add a '.'
        }
        return sb.toString();                            // Return newly built string
    }

    /**
     * This method builds a response packet (of bytes) with all the information of the message.
     * @return a byte array containing the decoded message.
     * @throws IOException throws any errors with output stream.
     */
    public byte[] toBytes() throws IOException {
        ByteArrayOutputStream os = new ByteArrayOutputStream();         // Stream of bytes for building response
        header_.writeBytes(os);                                         // Write header bytes to stream

        HashMap<String, Integer> domainNameLocations = new HashMap<>(); // Storage of domain locations
        for (DNSQuestion question : questions_){
            question.writeBytes(os, domainNameLocations);               // Write question bytes to stream
        }

        for (DNSRecord answer : answers_){
            answer.writeBytes(os, domainNameLocations);                 // Write answer bytes to stream
        }

        for (DNSRecord nsRecord : nsRecords_){
            nsRecord.writeBytes(os, domainNameLocations);               // Write ns record bytes to stream
        }

        for (DNSRecord arRecord : arRecords_){
            arRecord.writeBytes(os, domainNameLocations);               // Write ar record bytes to stream
        }

        return os.toByteArray();                                        // Convert stream to bytes and return
    }

    /**
     * Function that converts the domain, or it's location from previous address in the message, to bytes then pushes
     * them into the output stream.
     * @param os output stream containing all the bytes for the response.
     * @param domainLocations hash map of the location of the first address where the domain appears.
     * @param domainPieces string array containing the parts of the domain.
     */
    public static void writeDomainName(ByteArrayOutputStream os, HashMap<String,Integer> domainLocations, String[] domainPieces){
        String domainName = octectsToString(domainPieces);      // Convert domain pieces into single string
        if (domainLocations.containsKey(domainName)){           // If domain has already appeared
            os.write(0xC0);                                     // Indicated that precedes the pointer
            os.write(domainLocations.get(domainName));          // Address of domain location
        } else {
            domainLocations.put(domainName, os.size());         // Add domain location to hash map
            for(String domain : domainPieces) {
                os.write(domain.length());                      // Write domain piece size
                for (int i = 0; i < domain.length(); i++) {
                    os.write(domain.charAt(i));                 // Write each character
                }
            }
            os.write(0);                                        // Write single byte to indicate end of domain
        }
    }

    /**
     * -*- Method generated by the IDE. -*-
     * Converts message and its parts into a string
     * @return a long string with all the parts of the message.
     */
    @Override
    public String toString() {
        return "DNSMessage{" +
                "header_=" + header_ +
                ", questions_=" + questions_ +
                ", answers_=" + answers_ +
                ", nsRecords_=" + nsRecords_ +
                ", arRecords_=" + arRecords_ +
                '}';
    }

    /**
     * Getters
     *  getBub(): returns the byte array of the original request.
     *  getHeader(): returns the header object of the message.
     *  getQuestions(): returns an array list of all the questions in the message.
     *  getAnswers(): returns an array list of all the answers in the message.
     *  getNsRecords(): returns an array list of all the NS Records in the message.
     *  getArRecords(): returns an array list of all the AR Records in the message.
     */
    public byte[] getBuf() { return buf_; }
    public DNSHeader getHeader() { return header_; }
    public ArrayList<DNSQuestion> getQuestions() { return questions_; }
    public ArrayList<DNSRecord> getAnswers() { return answers_; }
    public ArrayList<DNSRecord> getNsRecords() { return nsRecords_; }
    public ArrayList<DNSRecord> getArRecords() { return arRecords_; }

    /**
     * Class Object Variables
     *  buf_: byte array of message
     *  header_: header object of message
     *  answers_: answer objects of message
     *  nsRecords_: ns record objects of message
     *  arRecords_: ar record objects of message
     */
    private byte[] buf_;
    private DNSHeader header_;
    private ArrayList<DNSQuestion> questions_;
    private ArrayList<DNSRecord> answers_;
    private ArrayList<DNSRecord> nsRecords_;
    private ArrayList<DNSRecord> arRecords_;
}
