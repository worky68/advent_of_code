// --- Part Two ---

// The engineers seem concerned; the total calibration result you gave them is nowhere close to being within safety tolerances. Just then, you spot your mistake: some well-hidden elephants are holding a third type of operator.

// The concatenation operator (||) combines the digits from its left and right inputs into a single number. For example, 12 || 345 would become 12345. All operators are still evaluated left-to-right.

// Now, apart from the three equations that could be made true using only addition and multiplication, the above example has three more equations that can be made true by inserting operators:

//     156: 15 6 can be made true through a single concatenation: 15 || 6 = 156.
//     7290: 6 8 6 15 can be made true using 6 * 8 || 6 * 15.
//     192: 17 8 14 can be made true using 17 || 8 + 14.

// Adding up all six test values (the three that could be made before using only + and * plus the new three that can now be made by also using ||) produces the new total calibration result of 11387.

// Using your new knowledge of elephant hiding spots, determine which equations could possibly be true. What is their total calibration result?

import std::io::file;
import std::collections::list;
import std::core::string;

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

  return permute(index+1, test_value, total+values[index], values) || permute(index+1, test_value, total*values[index], values) 
  || permute(index+1, test_value, string::tformat("%s%s", total, values[index]).to_ulong()!!, values);

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