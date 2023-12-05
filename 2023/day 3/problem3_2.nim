# --- Part Two ---

# The engineer finds the missing part and installs it in the engine! As the engine springs to life, you jump in the closest gondola, finally ready to ascend to the water source.

# You don't seem to be going very fast, though. Maybe something is still wrong? Fortunately, the gondola has a phone labeled "help", so you pick it up and the engineer answers.

# Before you can explain the situation, she suggests that you look out the window. There stands the engineer, holding a phone in one hand and waving with the other. You're going so slowly that you haven't even left the station. You exit the gondola.

# The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result of multiplying those two numbers together.

# This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.

# Consider the same engine schematic again:

# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..

# In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a gear because it is only adjacent to one part number.) Adding up all of the gear ratios produces 467835.

# What is the sum of all of the gear ratios in your engine schematic?

import std/strutils
import std/strformat

let lines = readFile("input3_2.txt").splitLines();
var sum = 0;

var j = 0;
while j in 0..<lines.len:
    # echo(j+1);
    var line = lines[j];
    var i = 0;
    # echo(fmt"line = {line}")
    while(i < line.len):
        if(line[i] == '*'):
            var start = i;
            var first = "";
            var second = "";
            # check current line
            if(start-1 >= 0 and start+1 < line.len):
                if(isDigit(line[start-1]) and isDigit(line[start+1])):
                    var k = start-1;
                    while(k >= 0 and isDigit(line[k])):
                        first.insert($line[k]);
                        dec k;
                    
                    k = start+1;
                    while(k < line.len and isDigit(line[k])):
                        second &= $line[k];
                        inc k;
                elif(isDigit(line[start-1])):
                    var k = start-1;
                    while(k >= 0 and isDigit(line[k])):
                        first.insert($line[k]);
                        dec k;
                elif(isDigit(line[start+1])):
                    var k = start+1;
                    while(k < line.len and isDigit(line[k])):
                        first &= $line[k];
                        inc k;

            # scan previous line
            if(j-1 >= 0):
                if(first == ""):
                    if(isDigit(lines[j-1][start])):
                        var k = start;
                        while(k >= 0 and isDigit(lines[j-1][k])):
                            first.insert($lines[j-1][k]);
                            dec k
                        k = start+1;
                        while(k < lines[j-1].len and isDigit(lines[j-1][k])):
                            first &= lines[j-1][k];
                            inc k;
                    elif(start+1 < lines[j-1].len and isDigit(lines[j-1][start+1]) and start-1 >= 0 and isDigit(lines[j-1][start-1])):
                        var k = start-1;
                        while(k >= 0 and isDigit(lines[j-1][k])):
                            first.insert($lines[j-1][k]);
                            dec k;
                        
                        k = start+1;
                        while(k < line.len and isDigit(lines[j-1][k])):
                            second &= $lines[j-1][k];
                            inc k;
                    elif(start-1 >= 0  and isDigit(lines[j-1][start-1])):
                        var k = start-1;
                        while(k >= 0 and isDigit(lines[j-1][k])):
                            first.insert($lines[j-1][k]);
                            dec k
                    elif(start+1 < lines[j-1].len and isDigit(lines[j-1][start+1])):
                        var k = start+1;
                        while(k < lines[j-1].len and isDigit(lines[j-1][k])):
                            first &= $lines[j-1][k];
                            inc k
                else:
                    if(isDigit(lines[j-1][start])):
                        var k = start;
                        while(k >= 0 and isDigit(lines[j-1][k])):
                            second.insert($lines[j-1][k]);
                            dec k
                        k = start+1;
                        while(k < lines[j-1].len and isDigit(lines[j-1][k])):
                            second &= lines[j-1][k];
                            inc k;
                    elif(start-1 >= 0  and isDigit(lines[j-1][start-1])):
                        var k = start-1;
                        while(k >= 0 and isDigit(lines[j-1][k])):
                            second.insert($lines[j-1][k]);
                            dec k
                    elif(start+1 < lines[j-1].len and isDigit(lines[j-1][start+1])):
                        var k = start+1;
                        while(k < lines[j-1].len and isDigit(lines[j-1][k])):
                            second &= $lines[j-1][k];
                            inc k

            # scan next line
            if(j+1 <= lines.len-1):
                if(isDigit(lines[j+1][start])):
                    var k = start;
                    while(k >= 0 and isDigit(lines[j+1][k])):
                        second.insert($lines[j+1][k]);
                        dec k
                    k = start+1;
                    while(k < lines[j+1].len and isDigit(lines[j+1][k])):
                        second &= lines[j+1][k];
                        inc k;
                elif(start+1 < lines[j+1].len and isDigit(lines[j+1][start+1]) and start-1 >= 0 and isDigit(lines[j+1][start-1])):
                    var k = start-1;
                    while(k >= 0 and isDigit(lines[j+1][k])):
                        first.insert($lines[j+1][k]);
                        dec k;
                    
                    k = start+1;
                    while(k < line.len and isDigit(lines[j+1][k])):
                        second &= $lines[j+1][k];
                        inc k;
                elif(start-1 >= 0  and isDigit(lines[j+1][start-1])):
                    var k = start-1;
                    while(k >= 0 and isDigit(lines[j+1][k])):
                        second.insert($lines[j+1][k]);
                        dec k
                elif(start+1 < lines[j+1].len and isDigit(lines[j+1][start+1])):
                    var k = start+1;
                    while(k < lines[j+1].len and isDigit(lines[j+1][k])):
                        second &= $lines[j+1][k];
                        inc k

            # echo(fmt"first = {first} second = {second}")
            if(first != "" and second != ""):
                sum += parseInt(first) * parseInt(second);

        inc i;
    inc j;

echo(fmt"sum = {sum}");