# --- Part Two ---

# Your calculation isn't quite right. It looks like some of the digits are actually 
# spelled out with letters: one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".

# Equipped with this new information, you now need to find the real first and last digit on each line.

# For example:

# two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen

# In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.

# What is the sum of all of the calibration values?


import std/strutils
import std/strformat
import std/tables

let digits = {"zero": "0", "one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"}.toTable();

proc findFirstDigit(line: string): (int, string) =
    var i = 0;
    while i < line.len:
        if(isDigit(line[i])):
            return (i, $line[i]);
        inc i;
    return (-1, "");

proc findFirstDigitWord(line: string): (int, string) =
    var first = (line.len, "");
    for digit in digits.keys:
        var index = line.find(digit, 0);
        if index != -1 and index < first[0]:
            first = (index, digit)

    if first[0] == line.len:
        return (-1, "")
    else:
        return first; 

proc findLastDigit(line: string): (int, string) =
    var j = line.len-1;
    while j >= 0:
        if(isDigit(line[j])):
            return (j, $line[j]);
        dec j;
    return (-1, "");

proc findLastDigitWord(line: string): (int, string) =
    var last = (-1, "");
    for digit in digits.keys:
        var index = line.rfind(digit, 0);
        # echo(fmt"digt = {digit} index = {index}")
        if index != -1 and index > last[0]:
            last = (index, digit)
    return last; 


let lines = readFile("input1_2.txt").splitLines();

var i = 1;
var sum = 0;
for line in lines:
    var first = "";
    var last = "";
    var firstDigitWord = findFirstDigitWord(line);
    var firstDigit = findFirstDigit(line);
    # echo(fmt"firstDigitWord = {firstDigitWord} firstDigit = {firstDigit}");
    if(firstDigitWord[0] == -1):
        first = firstDigit[1];
    elif(firstDigit[0] == -1):
        first = digits[firstDigitWord[1]];
    else:
        if(firstDigit[0] < firstDigitWord[0]):
            first = firstDigit[1];
        else:
            first = digits[firstDigitWord[1]];

    var lastDigitWord = findLastDigitWord(line);
    var lastDigit = findLastDigit(line);
    # echo(fmt"lastDigitWord = {lastDigitWord} lastDigit = {lastDigit}");
    if(lastDigitWord[0] == -1):
        last = lastDigit[1];
    elif(lastDigit[0] == -1):
        last = digits[lastDigitWord[1]];
    else:
        if(lastDigit[0] > lastDigitWord[0]):
            last = lastDigit[1];
        else:
            last = digits[lastDigitWord[1]];
    echo(fmt"line {i} first = {first} last = {last}");
    sum += parseInt(first & last);
    inc i;
echo(fmt"sum = {sum}");

