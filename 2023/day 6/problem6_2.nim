# --- Part Two ---

# As the race is about to start, you realize the piece of paper with race times and record distances you got earlier actually just has very bad kerning. There's really only one race - ignore the spaces between the numbers on each line.

# So, the example from before:

# Time:      7  15   30
# Distance:  9  40  200

# ...now instead means this:

# Time:      71530
# Distance:  940200

# Now, you have to figure out how many ways there are to win this single race. In this example, the race lasts for 71530 milliseconds and the record distance you need to beat is 940200 millimeters. You could hold the button anywhere from 14 to 71516 milliseconds and beat the record, a total of 71503 ways!

# How many ways can you beat the record in this one much longer race?

import std/strutils
import std/strformat

let lines = readFile("input6_2.txt").splitLines();

var total = 1;

proc getInput(line: string): int =
    var input = "";
    var nums = line.split(":")[1].strip().split(" ");
    for num in nums:
        if(num.isEmptyOrWhitespace()):
            continue;
        input &= num;
    return parseInt(input);

var time = getInput(lines[0]);
var rec_dist = getInput(lines[1]);

var num = 0;
for i in 0..time:
    var dist = (time - i) * i;
    if(dist > rec_dist):
        inc num;
if(num != 0):
    total *= num;

echo(fmt"total = {total}");