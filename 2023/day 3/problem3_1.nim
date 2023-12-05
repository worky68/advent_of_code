# --- Day 3: Gear Ratios ---

# You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you. You go inside.

# It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.

# "Aaah!"

# You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.

# The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.

# The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

# Here is an example engine schematic:

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

# In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

# Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?


import std/strutils
import std/strformat

let lines = readFile("input3_1.txt").splitLines();

var sum = 0;
var j = 0;
while j in 0..<lines.len:
    echo(j+1);
    var line = lines[j];
    var i = 0;
    # echo(fmt"line = {line}")
    while(i < line.len):
        var num = "";
        if(isDigit(line[i])):
            var start = i;
            while(i < line.len and isDigit(line[i])):
                num &= line[i];
                inc i;
                # echo(fmt"i = {i}")
            # echo(fmt"num = {num}")
            var add = false;
            # scan current line
            if(i <= line.len-1):
                # echo("checking current line next");
                # echo(fmt"line[i+1] = {line[i]}");
                if(line[i] != '.' and not isDigit(line[i])):
                    # echo(fmt"curret line add {num}")
                    add = true;
            if(start-1 >= 0):
                # echo("checking current line prev");
                if(line[start-1] != '.' and not isDigit(line[start-1])):
                    # echo(fmt"curret line add {num}")
                    add = true;

            # scan previous line
            if(j-1 >= 0):
                # echo("checking prev")
                for l in start-1..i:
                    if(l >= 0 and l < lines[j-1].len and lines[j-1][l] != '.' and not isDigit(lines[j-1][l])):
                        # echo(fmt"previous line add {num}")
                        add = true;

            # scan next line
            if(j+1 <= lines.len-1):
                # echo("checking next")
                for l in start-1..i:
                    if(l >= 0 and l < lines[j+1].len and lines[j+1][l] != '.' and not isDigit(lines[j+1][l])):
                        # echo(fmt"next line add {num}")
                        add = true;
            if(add):
                sum += parseInt(num);
        else:
            inc i;
    inc j;

echo(fmt"sum = {sum}");