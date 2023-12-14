# --- Part Two ---

# Of course, it would be nice to have even more history included in your report. Surely it's safe to just extrapolate backwards as well, right?

# For each history, repeat the process of finding differences until the sequence of differences is entirely zero. Then, rather than adding a zero to the end and filling in the next values of each previous sequence, you should instead add a zero to the beginning of your sequence of zeroes, then fill in new first values for each previous sequence.

# In particular, here is what the third example history looks like when extrapolating back in time:

# 5  10  13  16  21  30  45
#   5   3   3   5   9  15
#    -2   0   2   4   6
#       2   2   2   2
#         0   0   0

# Adding the new values on the left side of each sequence from bottom to top eventually reveals the new left-most history value: 5.

# Doing this for the remaining example data above results in previous values of -3 for the first history and 0 for the second history. Adding all three new values together produces 2.

# Analyze your OASIS report again, this time extrapolating the previous value for each history. What is the sum of these extrapolated values?

import std/strutils;
import std/strformat;
import std/deques;

let lines = readFile("input9_2.txt").splitLines();
var total: int = 0;

proc computePattern(nums: Deque[int], numSeq: var seq[Deque[int]]) =
    var steps = initDeque[int]();
    for i in 0..nums.len-2:
        steps.addLast(nums[i+1] - nums[i]);
    numSeq.insert(steps);
    var allZero = true;
    for i in 0..steps.len-1:
        if(steps[i] != 0):
            allZero = false;
    
    if(allZero):
        return;
    
    computePattern(steps, numSeq);

proc getNextValue(nums: Deque[int]): int =
    var next = 0;
    var numsSeq = newSeq[Deque[int]]();
    numsSeq.insert(initDeque[int]());
    for i in 0..nums.len-1:
        numsSeq[0].addLast(nums[i]);
        
    computePattern(nums, numsSeq);

    var last = initDeque[int]();
    for s in numsSeq:
        last.addLast(s[0]);

    for n in last:
        next = n - next;

    return next;

for line in lines:
    var nums = initDeque[int]();
    var values = line.split(" ");

    for value in values:
        nums.addLast(parseInt(value));

    total += getNextValue(nums);

echo(fmt"total = {total}");