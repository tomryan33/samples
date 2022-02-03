package assignment05;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.NoSuchElementException;

/**
 * This is a binary tree class that adds new nodes in sorted order for easy
 * search and add/remove capabilities.
 * @param <T> Generic type
 *
 * @author Ryan Clayton
 */
public class BinarySearchTree<T extends Comparable<? super T>> implements SortedSet<T> {

    private Node<T> root_;
    private int size_ = 0;

    /**
     * Default Constructor
     */
    public BinarySearchTree(){
        root_ = null;
    }

    /**
     * Node Class
     * @param <E> The type of data being used
     */
    private class Node<E> {

        public E data;
        public Node<T> left, right;

        /**
         * Node Constructor
         * Nodes are added with no children
         * @param item The item to be added to this new node
         */
        public Node(E item) {
            data = item;
            size_++;
            left = null;
            right = null;
        }
    }

    /**
     * Ensures that this set contains the specified item.
     *
     * @param item - the item whose presence is ensured in this set
     * @return true if this set changed as a result of this method call (that is, if
     * the input item was actually inserted); otherwise, returns false
     * @throws NullPointerException if the item is null
     */
    @Override
    public boolean add(T item) {
        if (item == null) throw new NullPointerException();
        int tmp_size = size_;
        root_ = insert(root_, item);
        return tmp_size != size_;
    }

    /**
     * Recursive Function for adding a new Node
     * @param node The current node being looked at.
     * @param item The item to be added to the set.
     * @return The first return: Returns a new node added to the tree.
     *         The second return: If the node already exists, returns the original node.
     *                            Does not create a new node.
     */
    public Node<T> insert(Node<T> node, T item){
        if (node == null){
            node = new Node<>(item);
            return node;
        }

        if (item.compareTo(node.data) < 0){
            node.left = insert(node.left, item);
        } else if (item.compareTo(node.data) > 0){
            node.right = insert(node.right, item);
        }
        return node;
    }

    /**
     * Ensures that this set contains all items in the specified collection.
     *
     * @param items - the collection of items whose presence is ensured in this set
     * @return true if this set changed as a result of this method call (that is, if
     * any item in the input collection was actually inserted); otherwise,
     * returns false
     * @throws NullPointerException if any of the items is null
     */
    @Override
    public boolean addAll(Collection<? extends T> items) {
        boolean changed = false;
        for (T item : items){
            if (add(item)) changed = true;
        }
        return changed;
    }

    /**
     * Removes all items from this set. The set will be empty after this method
     * call.
     */
    @Override
    public void clear() {
        root_ = null;
        size_ = 0;
    }

    /**
     * Determines if there is an item in this set that is equal to the specified
     * item.
     *
     * @param item - the item sought in this set
     * @return true if there is an item in this set that is equal to the input item;
     * otherwise, returns false
     * @throws NullPointerException if the item is null
     */
    @Override
    public boolean contains(T item) {
        if (item == null) throw new NullPointerException();
        Node<T> node = root_;
        while (true){
            if (node == null) return false;
            if (item.equals(node.data)) return true;
            if (item.compareTo(node.data) < 0){
                node = node.left;
            } else if (item.compareTo(node.data) > 0){
                node = node.right;
            }
        }
    }

    /**
     * Determines if for each item in the specified collection, there is an item in
     * this set that is equal to it.
     *
     * @param items - the collection of items sought in this set
     * @return true if for each item in the specified collection, there is an item
     * in this set that is equal to it; otherwise, returns false
     * @throws NullPointerException if any of the items is null
     */
    @Override
    public boolean containsAll(Collection<? extends T> items) {
        for (T item : items){
            if (!contains(item)) {
                System.out.println(item);
                return false;
            }
        }
        return true;
    }

    /**
     * Returns the first (i.e., smallest) item in this set.
     *
     * @throws NoSuchElementException if the set is empty
     */
    @Override
    public T first() throws NoSuchElementException {
        if (size_ == 0) throw new NoSuchElementException();

        Node<T> node = root_;
        while (true){
            if (node.left == null) return node.data;
            node = node.left;
        }

    }

    /**
     * Returns true if this set contains no items.
     */
    @Override
    public boolean isEmpty() {
        return size_ == 0;
    }

    /**
     * Returns the last (i.e., largest) item in this set.
     *
     * @throws NoSuchElementException if the set is empty
     */
    @Override
    public T last() throws NoSuchElementException {
        if (size_ == 0) throw new NoSuchElementException();

        Node<T> node = root_;
        while (true){
            if (node.right == null) return node.data;
            node = node.right;
        }
    }

    /**
     * Ensures that this set does not contain the specified item.
     *
     * @param item - the item whose absence is ensured in this set
     * @return true if this set changed as a result of this method call (that is, if
     * the input item was actually removed); otherwise, returns false
     * @throws NullPointerException if the item is null
     */
    @Override
    public boolean remove(T item) {
        if (item == null) throw new NullPointerException();

        // Step 1: Find item in array.
        boolean foundItem = false;
        Node<T> node = root_;       // Where we are at in the tree.
        Node<T> prevNode = root_;   // The node before the current node.
        while (!foundItem){
            if (node == null) return false;  // If no item exist: return false.
            if (item.compareTo(node.data) < 0){
                prevNode = node;
                node = node.left;
            } else if (item.compareTo(node.data) > 0){
                prevNode = node;
                node = node.right;
            } else {
                foundItem = true;
            }
        }

        /*
         * Step 2: Find the smallest item on right branch and replace with deleted node.
         *         Repeat this process if that node also has a child.
         */
        while (node.right != null) {
            Node<T> nodeToDelete = node;
            prevNode = node;
            node = node.right;
            while (node.left != null) {
                prevNode = node;
                node = node.left;
            }
            nodeToDelete.data = node.data;
        }

        /*
         * Step 3: Remove the pointer from the smallest previous node to mark its
         *         child to be deleted.
         */
        if (prevNode.left != null) {
            if (prevNode.left.data.equals(node.data)) {
                prevNode.left = node.left;
            }
        }
        if (prevNode.right != null) {
            if (prevNode.right.data.equals(node.data)) {
                prevNode.right = node.left;
            }
        }

        size_--;
        return true;
    }

    /**
     * Ensures that this set does not contain any of the items in the specified
     * collection.
     *
     * @param items - the collection of items whose absence is ensured in this set
     * @return true if this set changed as a result of this method call (that is, if
     * any item in the input collection was actually removed); otherwise,
     * returns false
     * @throws NullPointerException if any of the items is null
     */
    @Override
    public boolean removeAll(Collection<? extends T> items) {
        boolean changed = false;
        for (T item : items){
            if (remove(item)){
                changed = true;
            }
        }
        return changed;
    }

    /**
     * Returns the number of items in this set.
     */
    @Override
    public int size() {
        return size_;
    }

    /**
     * Returns an ArrayList containing all of the items in this set, in sorted
     * order.
     */
    @Override
    public ArrayList<T> toArrayList() {
        ArrayList<T> arr = new ArrayList<>();
        traverseTree(arr, root_);
        return arr;
    }

    /**
     * Recursive function for toArrayList()
     * Travels the tree starting on the right and adds each node to the array of nodes.
     * @param arr The array being built in sorted order.
     * @param node The current node the recursive function is working with.
     */
    private void traverseTree(ArrayList<T> arr, Node<T> node){
        if (node != null) {
            traverseTree(arr, node.left);
            arr.add(node.data);
            traverseTree(arr, node.right);
        }
    }

    /**
     * Helper function to write a dot fil of our tree.
     * @param filename The output name of our dot file.
     */
    public void writeDot(String filename) {
        try {
            PrintWriter output = new PrintWriter(new FileWriter(filename));
            output.println("graph g {");
            if (root_ != null)
                output.println(root_.hashCode() + "[label=\"" + root_.data + "\"]");
            writeDotRecursive(root_, output);
            output.println("}");
            output.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Recursively traverse the tree, outputting each node to the .dot file
    private void writeDotRecursive(Node<T> n, PrintWriter output) {
        if (n == null)
            return;
        if (n.left != null) {
            output.println(n.left.hashCode() + "[label=\"" + n.left.data + "\"]");
            output.println(n.hashCode() + " -- " + n.left.hashCode());
        }
        if (n.right != null) {
            output.println(n.right.hashCode() + "[label=\"" + n.right.data + "\"]");
            output.println(n.hashCode() + " -- " + n.right.hashCode());
        }

        writeDotRecursive(n.left, output);
        writeDotRecursive(n.right, output);
    }
}
