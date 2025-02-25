/*
    sweep line
        sweep a line, in this problem its vertical across a 2D plane and maintaining an active set of objects that interact with the line.

        convert problem into events, find critical points where changes occur, convert into start and end events

        sort the events, use x for left to right, if x is the same, process start events before end events

        use a data structure to track active elements
            bst balanced search tree, treeset
            max heap or priority queue
            set/hashmap for simpler problems

        process events sequentially
            update the active set of objects
            detect changes, new max height in skyline
            store important transitions

    max heap
        a binary heap where the parent node is always greater than or equal to int children. it is implemented as a binary tree but stored efficiently in an array.
            complete binary tree -> all levels are fully filled except possibly the last one
            heap property -> the parent is always >= its children
            efficient operations
                insertion - O(log N)
                    insert new elements at the end of the heap
                    maintain complete tree property
                    heapify up - bubble up
                        compare the inserted elements with its parent
                        if the inserted element > parent, swap them
                        repeat process until heap property is restored
                    worst case: inserted element moves up the root
                    height of heap is O(log N)
                    element moves at most the height of the heap
                    time complexity is O(log N)
                    swap up tree is with parent nodes at most height
                    height of a heap is O(log N)
                deletion - extract max O(log N)
                    extract max operation
                    remove the root, this is max element in max heap
                    move the last elelement of the heap to the root
                    heapify down, bubble down
                        compare this new root with its largest child
                        if the new root is smaller, swap it with largest child
                        repeat this process until the heap property is restored
                        height is O (log N) worst case it moves at most of the height of the tree
                        since each swap takes constant time, O(1), time complexity is O (log N)
                peek - (max value) O(1)
                    max value is always root
                    accessing arr[0] is constant at O(1)

    process events
        convert building into two types of events
        start is x = left, height > 0
        end is x = right, height < 0 (use the negative to differentiate)

    sort the events
        first by x coord
        if x is the same, prioritize higher heights for start events and lower heights for end events

    use a max heap 
        to track the current highest building as we process the sorted events

    iterate through the events
        add heights to the heap when encountering a start
        remove heights when encountering an end
        compare max height in the heap with the last recorded height to detect a change in skyline
*/

import java.util.*

fun getSkyline(buildings: Array<IntArray>): List<List<Int>> {

    val events = mutableListOf<Pair<Int, Int>>() // x, height

    // create building events
    for (b in buildings) {
        events.add(Pair(b[0], -b[2])) // start
        events.add(Pair(b[1], b[2])) // end
    }

    // by x coord, if x is same process -'s first then +'s
    events.sortWith(compareBy({ it.first }, { it.second }))

    val result = mutableListOf<List<Int>>()
    val maxHeap = PriorityQueue<Int>( compareByDescending { it })
    maxHeap.add(0) // init ground level
    var prevMax = 0 // init starting at ground as max height 0 events

    for ((x, height) in events) {
        // differentiate start from end of building
        if (height < 0) { // start will need a max heap add
            maxHeap.add(-height) // start may be valid point
        } else { // we aren't concerned about end points
            maxHeap.remove(height) // end no longer needs
        }

        // use the latest adjusted heap with this x
        // check for it to not be equal to the height we just got
        val currMax = maxHeap.peek() ?: 0
        // we can skip a point on the same x with sme height
        if (currMax != prevMax) {
            result.add(listOf(x, currMax))
            prevMax = currMax
        }
    }

    return result
}