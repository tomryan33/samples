import java.util.HashMap;

/**
 * DNS Cache Object
 * @author Ryan Clayton
 * Description: This object store all the know records (answers) for the current server session.  If a answer
 *              is not in the cache then we can ask google for the answer then store it here for future use.
 *
 * Methods:
 *  boolean contains(DNSQuestion question);
 *
 * Setters:
 *  void addRecord(DNSQuestion question, DNSRecord answer);
 *
 * Getters:
 *  DNSRecord getRecord(DNSQuestion question);
 */
public class DNSCache {

    /**
     * This method takes a question and check to see if we already have the answer.
     * @param question the question for searching.
     * @return true if we have the answer, false if we do not.
     */
    public boolean contains(DNSQuestion question) {
        if (cache_.containsKey(question)){                  // Check if we have the question
            if (cache_.get(question).timestampValid()) {    // Check if it has past the time to live
                return true;
            } else {
                cache_.remove(question);                     // Remove answer if it has past its time
            }
        }
        return false;
    }

    /**
     * A setter method to add a new answer to the cache.
     * @param question the question being asked.
     * @param answer the answer to the question being asked.
     */
    public void addRecord(DNSQuestion question, DNSRecord answer) { cache_.put(question, answer); }

    /**
     * A getter method to get a specific record from the cache.
     * @param question the question we are returning the answer for.
     * @return the record object of the request.
     */
    public DNSRecord getRecord(DNSQuestion question) { return cache_.get(question); }

    /**
     * Object Variables:
     *  cache_: hash map of all the cached records.
     */
    private static HashMap<DNSQuestion, DNSRecord> cache_ = new HashMap<>();
}
