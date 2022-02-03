package assignment05;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

class BinarySearchTreeTest {

    BinarySearchTree<String> stringTreeSet_;
    BinarySearchTree<Integer> intTreeSet_;

    @BeforeEach
    void setUp() {
        buildStringSet();
        buildIntSet();
    }

    @AfterEach
    void tearDown() {

    }

    @Test
    void addNewItem() {
        assertTrue(stringTreeSet_.add("CDE"));
        assertFalse(stringTreeSet_.add("BCD"));
    }

    @Test
    void containsItem(){
        assertTrue(stringTreeSet_.contains("BCD"));
        assertFalse(stringTreeSet_.contains("XYZ"));
    }

    @Test
    void getFirstItem(){
        assertEquals("ABC", stringTreeSet_.first());
    }

    @Test
    void isEmptyAndClearSet(){
        assertFalse(stringTreeSet_.isEmpty());
        stringTreeSet_.clear();
        assertTrue(stringTreeSet_.isEmpty());
    }

    @Test
    void getLastItem(){
        assertEquals("NOP", stringTreeSet_.last());
    }

    @Test
    void removeItem(){
        assertFalse(intTreeSet_.remove(-1));

        int indexCheck = randomNum(1, intTreeSet_.size());
        //intTreeSet_.writeDot("src/assignment05/dot/intTreeBefore.dot");
        assertTrue(intTreeSet_.remove(indexCheck));
        //intTreeSet_.writeDot("src/assignment05/dot/intTreeAfter.dot");

        ArrayList<Integer> ints = new ArrayList<>();
        for (int i = 1; i < intTreeSet_.size()+2; i ++){
            if (i != indexCheck){
                ints.add(i);
            }
        }
        assertTrue(intTreeSet_.containsAll(ints));
    }

    @Test
    void removeSingleItemFromSingArray(){
        BinarySearchTree<String> singleItem = new BinarySearchTree<>();
        assertTrue(singleItem.add("Hello"));
        assertTrue(singleItem.remove("Hello"));
        assertEquals(0, singleItem.size());
    }

    @Test
    void size(){
        int size = stringTreeSet_.size();
        stringTreeSet_.add("SIZE");
        assertEquals(size+1, stringTreeSet_.size());
        stringTreeSet_.remove("SIZE");
        assertEquals(size, stringTreeSet_.size());
        stringTreeSet_.clear();
        assertEquals(0, stringTreeSet_.size());
    }

    @Test
    void toArrayList(){
        ArrayList<Integer> arrayOfInts = intTreeSet_.toArrayList();
        for (int i = 0; i < arrayOfInts.size(); i++){
            assertEquals(i+1, arrayOfInts.get(i));
        }
    }


    /**
     * Helper Functions:
     */
    private void buildStringSet() {
        stringTreeSet_ = new BinarySearchTree<>();
        stringTreeSet_.add("GHI");
        stringTreeSet_.add("LMN");
        stringTreeSet_.add("EFG");
        stringTreeSet_.add("KLM");
        stringTreeSet_.add("NOP");
        stringTreeSet_.add("IJK");
        stringTreeSet_.add("ABC");
        stringTreeSet_.add("MNO");
        stringTreeSet_.add("BCD");
        stringTreeSet_.add("JKL");
        stringTreeSet_.add("HIJ");
        stringTreeSet_.add("DEF");
    }

    private void buildIntSet() {
        intTreeSet_ = new BinarySearchTree<>();
        int qt = 100; // size of nums
        int[] nums = new int[qt];

        // Initializes the list (1-qt)
        for (int i = 0; i < qt; i++){
            nums[i] = i+1;
        }

        // Randomizes the list
        for (int i = 0; i < 5000; i++){
            int index1 = randomNum(0, qt-1);
            int index2 = randomNum(0, qt-1);
            int tmpNum = nums[index1];
            nums[index1] = nums[index2];
            nums[index2] = tmpNum;
        }

        // Add random list to tree.
        for (int num : nums) {
            intTreeSet_.add(num);
        }
    }

    public static int randomNum(int min, int max){
        return (int)Math.floor(Math.random()*(max-min+1)+min);
    }
}