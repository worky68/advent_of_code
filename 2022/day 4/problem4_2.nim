# --- Part Two ---

# 2-4,6-8
# 2-3,4-5
# 5-7,7-9
# 2-8,3-7
# 6-6,4-6
# 2-6,4-8

# It seems like there is still quite a bit of duplicate work planned. Instead, the Elves would like to know the number of pairs that overlap at all.

# In the above example, the first two pairs (2-4,6-8 and 2-3,4-5) don't overlap, while the remaining four pairs (5-7,7-9, 2-8,3-7, 6-6,4-6, and 2-6,4-8) do overlap:

#     5-7,7-9 overlaps in a single section, 7.
#     2-8,3-7 overlaps all of the sections 3 through 7.
#     6-6,4-6 overlaps in a single section, 6.
#     2-6,4-8 overlaps in sections 4, 5, and 6.

# So, in this example, the number of overlapping assignment pairs is 4.

# In how many assignment pairs do the ranges overlap?
import std/strutils
import std/strformat

proc overlap(assign1: string, assign2: string): bool =
    var start1 = parseInt(assign1.split('-')[0]);
    var end1 = parseInt(assign1.split('-')[1]);
    var start2 = parseInt(assign2.split('-')[0]);
    var end2 = parseInt(assign2.split('-')[1]);

    var contained1 = start1 in start2..end2 or end1 in start2..end2;
    var contained2 = start2 in start1..end1 or end2 in start1..end1;

    return contained1 or contained2;

let lines = readFile("input4_2.txt").splitLines();
var result = 0;

for line in lines:
    var assign1 = line.split(',')[0];
    var assign2 = line.split(',')[1];
    if overlap(assign1, assign2):
        result = result + 1;

echo(fmt"Result = {result}");