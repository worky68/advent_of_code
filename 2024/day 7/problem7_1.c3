// --- Day 7: Bridge Repair ---

// The Historians take you to a familiar rope bridge over a river in the middle of a jungle. The Chief isn't on this side of the bridge, though; maybe he's on the other side?

// When you go to cross the bridge, you notice a group of engineers trying to repair it. (Apparently, it breaks pretty frequently.) You won't be able to cross until it's fixed.

// You ask how long it'll take; the engineers tell you that it only needs final calibrations, but some young elephants were playing nearby and stole all the operators from their calibration equations! They could finish the calibrations if only someone could determine which test values could possibly be produced by placing any combination of operators into their calibration equations (your puzzle input).

// For example:

// 190: 10 19
// 3267: 81 40 27
// 83: 17 5
// 156: 15 6
// 7290: 6 8 6 15
// 161011: 16 10 13
// 192: 17 8 14
// 21037: 9 7 18 13
// 292: 11 6 16 20

// Each line represents a single equation. The test value appears before the colon on each line; it is your job to determine whether the remaining numbers can be combined with operators to produce the test value.

// Operators are always evaluated left-to-right, not according to precedence rules. Furthermore, numbers in the equations cannot be rearranged. Glancing into the jungle, you can see elephants holding two different types of operators: add (+) and multiply (*).

// Only three of the above equations can be made true by inserting operators:

//     190: 10 19 has only one position that accepts an operator: between 10 and 19. Choosing + would give 29, but choosing * would give the test value (10 * 19 = 190).
//     3267: 81 40 27 has two positions for operators. Of the four possible configurations of the operators, two cause the right side to match the test value: 81 + 40 * 27 and 81 * 40 + 27 both equal 3267 (when evaluated left-to-right)!
//     292: 11 6 16 20 can be solved in exactly one way: 11 + 6 * 16 + 20.

// The engineers just need the total calibration result, which is the sum of the test values from just the equations that could possibly be true. In the above example, the sum of the test values for the three equations listed above is 3749.

// Determine which equations could possibly be true. What is their total calibration result?
import std::io::file;
import std::collections::list;

fn bool can_equal(ulong test_value, List(<ulong>) values) {

  if(permute(0, test_value, 0, values)) {
    return true;
  }

  return false;
}

fn bool permute(ulong index, ulong test_value, ulong total, List(<ulong>) values) {

  if((usz)index > values.len() - 1) {
    
    if(total == test_value) {
      return true;
    }
    else {
      return false;
    }
  }

  return permute(index+1, test_value, total+values[index], values) || permute(index+1, test_value, total*values[index], values);

}

fn void main(String[] args) {
  String inputFile = args[1];
  String input = (String) file::load_temp(inputFile)!!;

  String[] lines = input.tsplit("\n");

  ulong sum = 0;

  foreach(line : lines) {
    String[] split_eq = line.tsplit(":");
    ulong test_value = split_eq[0].to_ulong()!!;

    String[] split_vals = split_eq[1].trim().tsplit(" ");

    List(<ulong>) values;
    values.temp_init();

    foreach(val : split_vals) {
      values.push(val.to_ulong()!!);
    }

    if(can_equal(test_value, values)) {
      sum += test_value;
    }
    
  }

  io::printfn("sum = %s", sum);
}