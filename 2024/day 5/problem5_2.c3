// --- Part Two ---

// While the Elves get to work printing the correctly-ordered updates, you have a little time to fix the rest of them.

// For each of the incorrectly-ordered updates, use the page ordering rules to put the page numbers in the right order. For the above example, here are the three incorrectly-ordered updates and their correct orderings:

//     75,97,47,61,53 becomes 97,75,47,61,53.
//     61,13,29 becomes 61,29,13.
//     97,13,75,29,47 becomes 97,75,47,29,13.

// After taking only the incorrectly-ordered updates and ordering them correctly, their middle page numbers are 47, 29, and 47. Adding these together produces 123.

// Find the updates which are not in the correct order. What do you get if you add up the middle page numbers after correctly ordering just those updates?
import std::io::file;
import std::collections::map;
import std::collections::list;

def Rules = HashMap(<int, List(<char>)>);
def Values = List(<List(<char>)>);

fn void main(String[] args) {

  String inputFile = args[1];
  String input = (String) file::load_temp(inputFile)!!;

  String[] lines = input.tsplit("\n");
  
  Rules rules;
  rules.temp_init();

  int i = 0;
  while(i < lines.len) {
    String line = lines[i];
    if(line == "") {
      break;
    }
    String[] rule = line.tsplit("|");

    char rule1 = rule[0].to_uchar()!!;
    char rule2 = rule[1].to_uchar()!!;

    if(rules.has_key(rule1)) {
      List(<char>) l = rules.get(rule1)!!;
      l.push(rule2);
      rules.set(rule1, l);
    } else {
      List(<char>) l;
      l.temp_init();
      l.push(rule2);

      rules.set(rule1, l);
    }
    i++;
  }

  i++;

  Values valid;
  valid.temp_init();

  HashMap(<char, int>) memory;
  memory.temp_init();

  while(i < lines.len) {
    memory.clear();
    String[] split = lines[i].tsplit(",");
    List(<char>) updates;
    updates.temp_init();

    foreach(s : split) {
      updates.push(s.to_uchar()!!);
    }

    bool was_invalid = false;
    for(int j = 0; j < updates.len(); j++) {
      char update = updates[j];

      int l = j - 1;
      while(l >= 0 && (rules.has_key(update) && rules.get(update)!!.contains(updates[l]))) {
        was_invalid = true;
        updates[(long) l + 1] = updates[l];
        l = l - 1;
      }
      updates[(long) l + 1] = update;

    }

    if(was_invalid) {
      valid.push(updates);
    }

    i++;
  }

  int sum = 0;

  foreach(v : valid) {
    char m = v[(v.len()-1)/2];
    sum += m;
  }

  io::printfn("sum = %s", sum);

}