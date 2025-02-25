/*
    Given a list of time intervals [(start), (end)] and want to find how many intervals overlap at any point in time.
*/

import java.util.*

fun maxOverlappingIntervals(intervals: Array<IntArray>): Int {
    val events = mutableListOf<Pair<Int, Int>>()

    // convert intervals into events (start: +1, end: -1)
    for (interval in intervals) {
        // start event
        events.add(Pair(interval[0], 1)) 
        // end event
        events.add(Pair(interval[1], -1))
    }
    
    // sort by time; if the same time, and events (-1) come first
    events.sortWith(compareBy({ it.first }, { it.second }))

    var maxOverlap = 0
    var currentOverlap = 0

    for((_, value) in events) {
        currentOverlap += value
        maxOverlap = maxOf(maxOverlap,  currentOverlap)
    }

    return maxOverlap
}

fun main() {
    val intervals = arrayOf (
        intArrayOf(1, 5),
        intArrayOf(2, 6),
        intArrayOf(3, 7),
        intArrayOf(4, 8),
        intArrayOf(5, 9),
    )

    // output: 4
    println(maxOverlappingIntervals(intervals))
}

/*
    class breakdown

    import java.util.*
        this imports the java.util.* package, which provides access to utility classes such as Pair, List and sorting functions.

    fun maxOverlappingIntervals(intervals: Array<IntArray>): Int {...}
        takes an array of intervals as input 
        each interval is represented as an array of [start, end] 
            start is when the interval begins
            end is when the interval ends
        the functio returns the maximum number of overlapping intervals at any time.

    val events = mutableListOf<Pair<Int, Int>>()
        we create a list of events, where each event repreesnts either
            the start of an interval -> (+1)
            the end of an interval -> (-1)

    for (interval in intervals) {
        events.add(Pair(interval[0], 1)) // start event
        events.add(Pair(interval[1], -1)) // end event
    }
        transforms each interval [start, end] into two separate events
        1 Pair(start, 1) start of an interval +1
        2 Pair(end, -1) end of an interval -1

    // give intervals 
    [(1,5), (2,6), (3,7), (4,8), (5,9)]
    // generated intervals
    [(1, 1), (5, -1), (2, 1), (6, -1), (3, 1), (7, -1), (4, 1), (8, -1), (5, 1), (9, -1)]
    // start have +1 and end have -1 as y values, given is time interval

    events.SortWith(compareBy({ it.first }, { it.second }))
        // sort events based on
        // first by x (time) process earlier times first
        // if times are the same, sort by value
            // start events +1 come before end events -1 
            // ensures correct overlap counting
    // sorted with sort by first value, andy ties are sortee by second value
    [(1, 1), (2, 1), (3, 1), (4, 1), (5, -1), (5, 1), (6, -1), (7, -1), (8, -1), (9, -1)]
    // now when two events occur at the sam time, start events are processed first, sorted by time, 1,2,3... if 3,3 then -1 first for event y value (3, -1), then (3, 1)

    var maxOverlap = 0
    var currentOverlap = 0
    // currentOverlap number of overlapping intervals at any given time
    // maxOverlap stores the max value of currentOverlap

    for((_, value) in evnets) {
        currentOverlap += value
        maxOverlap = maxOf(maxOverlap, currentOverlap)
    }
    // add 1 for a start event, increase overlap
    // sub 1 for end event, decrease overalp
    // update maxOverlap whenever a new max is found

    // given the input, we get...
        time 1 as +1 curr 1 max 1
        time 2 as +1 curr 2 max 2
        time 3 as +1 curr 3 max 3
        time 4 as +1 curr 4 max 4
        time 5 as -1 curr 3 max 4
        time 5 as +1 curr 4 max 4
        time 6 as -1 curr 3 max 4
        time 7 as -1 curr 2 max 4
        time 8 as -1 curr 1 max 4
        time 9 as -1 curr 0 max 4

    return max as 4 set from the four start intervals until and end is met or end of time marker at 5, 4 other intervals started

    // splitting the events into new proccessing items helps make the problem solvable by allowing the algorithm to determine the result expected from the logic it needs to compute it, we are given a start and end interval. we need the number of intervals that overlap. it is useful to then split th start and stop points and mark them as such, count the start's that occur before the end at this point sub the end as they come to reduce intervals
*/