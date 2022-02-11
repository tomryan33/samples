import java.io.*;

/**
 * DNS Header Object
 * @author Ryan Clayton
 * Description: This the header object for the DNS Message.  This class decode the header from a byte array store
 *              the values in object variables, and also rebuild the byte array from those object variables.
 *
 * Methods:
 *  DNSHeader decodeHeader(ByteArrayInputStream is);
 *  DNSHeader buildResponseHeader(DNSMessage request, DNSMessage response);
 *  writeBytes(ByteArrayOutputStream os);
 *  byte[] toBytes(int num, int numBytes);
 *  int getNBytes(ByteArrayInputStream is, int numBytes);
 *  String toString();
 *
 * Getters:
 *  public int getId();
 *  public int getQdCount();
 *  public int getAnCount();
 *  public int getNsCount();
 *  public int getArCount();
 */
public class DNSHeader {

    /**
     * The method takes in the byte array from the request and converts the first 12 bytes into a header object.
     * @param is input stream containing the bytes from the request.
     * @return a header object with all the parts of the header.
     */
    public static DNSHeader decodeHeader(ByteArrayInputStream is) {
        DNSHeader header = new DNSHeader();         // New header object

        header.id_ = getNBytes(is, 2);              // Get ID from first two bytes

        int byte3 = is.read();
        header.qr_ = (byte3 & 0x80) >> 7;           // Get QR from first bit from byte 3
        header.opCode_ = (byte3 & 0x78) >> 3;       // Get OP Code from the next 4 bits
        header.aa_ = (byte3 & 0x04) >> 2;           // Get AA from the next bit
        header.tc_ = (byte3 & 0x02) >> 1;           // Get TC from next bit
        header.rd_ = byte3 & 0x01;                  // Get RD from next bit

        int byte4 = is.read();
        header.ra_ = (byte4 & 0x80) >> 7;           // Get RA from first bit from byte 3
        header.z_ = (byte4 & 0x70) >> 4;            // Get Z from next 3 bits
        header.rCode_ = byte4 & 0x0f;               // Get R Code from next 4 bits

        header.qdCount_ = getNBytes(is, 2);         // Get QD Count from bytes 5 and 6
        header.anCount_ = getNBytes(is, 2);         // Get AN Count from bytes 7 and 8
        header.nsCount_ = getNBytes(is, 2);         // Get NS Count from bytes 9 and 10
        header.arCount_ = getNBytes(is, 2);         // Get AR Count from bytes 11 and 12

        return header;                              // Return new header object
    }

    /**
     * This method, similar to decodeHeader(), builds a new header object with response values.
     * @param request the original request message with the original request objects
     * @param response the response message with its response objects
     * @return a new header object with the updated objects
     */
    public static DNSHeader buildResponseHeader(DNSMessage request, DNSMessage response){
        DNSHeader output = new DNSHeader();                 // New header object
        output.id_ = request.getHeader().getId();           // Get ID from original message
        output.qr_ = 1;                                     // Default values
        output.opCode_ = 0;
        output.aa_ = 0;
        output.tc_ = 0;
        output.rd_ = 1;
        output.ra_ = 1;
        output.z_ = 0;
        output.rCode_ = 0;
        output.qdCount_ = response.getQuestions().size();   // Get number of questions
        output.anCount_ = response.getAnswers().size();     // Get number of answers
        output.nsCount_ = response.getNsRecords().size();   // Get number of NS records
        output.arCount_ = response.getArRecords().size();   // Get number of AR records

        return output;                                      // Return new header object
    }

    /**
     * This method write the variables of this object to a byte array.
     * @param os the output stream where we will write the bytes to.
     * @throws IOException throws any errors with output stream.
     */
    public void writeBytes(ByteArrayOutputStream os) throws IOException {
        os.write(toBytes(id_, 2));          // Write the ID to first two bytes
        os.write(toBytes(33152, 2));        // Write '1 0000 0 0 1' + '1 000 0000' to the next two bytes
        os.write(toBytes(qdCount_, 2));     // Write QD count to the nxt two bytes
        os.write(toBytes(anCount_, 2));     // Write AN count to the next two bytes
        os.write(toBytes(nsCount_, 2));     // Write NS count to the next two bytes
        os.write(toBytes(arCount_, 2));     // Write AR count the next two bytes
    }

    /**
     * This is a helper function.  It takes an integer and converts it into a byte array.
     * @param num the integer to be converted.
     * @param numBytes how many bytes should this integer use.
     * @return a byte array of the product of our conversion.
     */
    public static byte[] toBytes(int num, int numBytes) {
        byte[] output = new byte[numBytes];         // Create a byte array with the proper amount of bytes
        int y = numBytes-1;                         // Used for bit manipulation calculations
        for (int i = 0; i < numBytes; i++){         // Loop through each byte
            output[i] = (byte) (num >> (y * 8));    // Shift the correct bits into each byte
            y--;
        }
        return output;                              // Return final byte array
    }

    /**
     * This is a helper function.  This function takes an input stream of bytes, takes a selected number of
     * bytes and converts them into an integer.
     * @param is the input stream used to pull the bytes out of.
     * @param numBytes  the number of bytes needed to build an integer.
     * @return an integer of the binary value of the selected number of bytes.
     */
    public static int getNBytes(ByteArrayInputStream is, int numBytes){
        int output = 0;                             // Start with the number at Zero
        for (int i = numBytes-1; i >= 0; i--){
            int byt = is.read();                    // Read in byte
            byt = byt << (8 * i);                   // Shift byte over to make room for next byte
            output = output | byt;                  // Combine this byte with the output bytes
        }
        return output;                              // Return the final integer
    }

    /**
     * -*- Method generated by the IDE. -*-
     * Convert the header variables into a human-readable string.
     * @return a string representing the header object.
     */
    @Override
    public String toString() {
        return "DNSHeader{" +
                "id_=" + id_ +
                ", qr_=" + qr_ +
                ", opCode_=" + opCode_ +
                ", aa_=" + aa_ +
                ", tc_=" + tc_ +
                ", rd_=" + rd_ +
                ", ra_=" + ra_ +
                ", z_=" + z_ +
                ", rCode_=" + rCode_ +
                ", qdCount_=" + qdCount_ +
                ", anCount_=" + anCount_ +
                ", nsCount_=" + nsCount_ +
                ", arCount_=" + arCount_ +
                '}';
    }

    /**
     * Getters
     *  getId(): returns the header id (id for the message).
     *  getQdCount(): returns the amount of questions asked.
     *  getAnCount(): returns the amount of answers we currently have.
     *  getNsCount(): returns the amount of NS records we have.
     *  getArCount(): returns the amount of additional records we have.
     */
    public int getId(){ return id_; }
    public int getQdCount(){ return qdCount_; }
    public int getAnCount() { return anCount_; }
    public int getNsCount() { return nsCount_; }
    public int getArCount() { return arCount_; }

    /**
     * Object Variables:
     * Disclaimer: Definitions pulled straight from the 1987 "DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION"
     *             specification guide: https://www.ietf.org/rfc/rfc1035.txt
     *
     *  id_: A 16 bit identifier assigned by the program that generates any kind of query.  This identifier
     *       is copied the corresponding reply and can be used by the requester to match up replies to
     *       outstanding queries.
     *  qr_: A one bit field that specifies whether this message is a query (0), or a response (1).
     *  opCode_: A four bit field that specifies kind of query in this message.  This value is set by the
     *           originator of a query and copied into the response.  The values are:
     *              0: a standard query (QUERY)
     *              1: an inverse query (IQUERY)
     *              2: a server status request (STATUS)
     *              3-15: reserved for future use
     *  aa_: Authoritative Answer - this bit is valid in responses, and specifies that the responding name
     *       server is an  authority for the domain name in question section.
     *  tc_: TrunCation - specifies that this message was truncated due to length greater than that
     *       permitted on the transmission channel.
     *  rd_: Recursion Desired - this bit may be set in a query and is copied into the response.  If RD is
     *       set, it directs the name server to pursue the query recursively. Recursive query support is optional.
     *  ra_: Recursion Available - this be is set or cleared in a response, and denotes whether recursive
     *       query support is available in the name server.
     *  z_: Reserved for future use.  Must be zero in all queries and responses.
     *  rCode_: Response code - this 4 bit field is set as part of responses.  The values have the
     *          following interpretation:
     *              0: No error condition
     *              1: Format error - The name server was unable to interpret the query.
     *              2: Server failure - The name server was unable to process this query due to a problem with
     *                 the name server.
     *              3: ame Error - Meaningful only for responses from an authoritative name server, this code
     *                 signifies that the domain name referenced in the query does not exist.
     *              4: Not Implemented - The name server does not support the requested kind of query.
     *              5: Refused - The name server refuses to perform the specified operation for policy reasons.
     *                 For example, a name server may not wish to provide the information to the particular
     *                 requester, or a name server may not wish to perform a particular operation (e.g., zone
     *                 transfer) for particular data.
     *              6-15: Reserved for future use.
     *  qdCount_: an unsigned 16-bit integer specifying the number of entries in the question section.
     *  anCount_: an unsigned 16-bit integer specifying the number of resource records in the answer section.
     *  nsCount_: an unsigned 16-bit integer specifying the number of name server resource records in the
     *            authority records section.
     *  arCount_: an unsigned 16-bit integer specifying the number of resource records in the additional
     *            records section.
     */
    private int id_;
    private int qr_, opCode_, aa_, tc_, rd_, ra_, z_, rCode_;
    private int qdCount_, anCount_, nsCount_, arCount_;
}


// DNS Header Format:
//                                 1  1  1  1  1  1
//   0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
// +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
// |                      ID                       |
// +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
// |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
// +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
// |                    QDCOUNT                    |
// +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
// |                    ANCOUNT                    |
// +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
// |                    NSCOUNT                    |
// +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
// |                    ARCOUNT                    |
// +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+