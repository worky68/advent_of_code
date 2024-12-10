// --- Part Two ---

// The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.

// The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report. It's like the bad level never happened!

// Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.

// More of the above example's reports are now safe:

//     7 6 4 2 1: Safe without removing any level.
//     1 2 7 8 9: Unsafe regardless of which level is removed.
//     9 7 6 2 1: Unsafe regardless of which level is removed.
//     1 3 2 4 5: Safe by removing the second level, 3.
//     8 6 4 4 1: Safe by removing the third level, 4.
//     1 3 6 7 9: Safe without removing any level.

// Thanks to the Problem Dampener, 4 reports are actually safe!

// Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?
import std::collections::list;
import std::io::file;
import std::math;

fn bool safety_check(String[] data) {
  bool is_decreasing = false;
  int i = 0;
  while(i < data.len - 1) {

    int cur = data[i].to_integer(int)!!;
    int next = data[i+1].to_integer(int)!!;
    
    if(math::abs(cur - next) < 1 || math::abs(cur - next) > 3) {
      return false;
    }

    if(i == 0) {
      is_decreasing = cur > next;
    }

    if(i != 0 && is_decreasing) {
      if(cur < next) {
        return false;
      }
    } else if(i != 0 && !is_decreasing) {
      if(cur > next) {
        return false;
      }
    }

    i = i + 1;
  }

  return true;
}

fn int main(String[] args) {
  String inputFile = args[1];
  String input = ((String) file::load_new(inputFile)!!).trim();
  defer input.free();

  String[] lines = input.split("\n");
  int sum = 0;
  foreach(line : lines) {
    String[] data = line.split(" ");
    bool is_safe = safety_check(data);

    if(!is_safe) {

      for(int j = 0; j < data.len; j++) {
        List(<String>) slice;
        slice.temp_init_with_array(data);
        slice.remove_at(j);

        if(safety_check(slice.array_view())) {
          is_safe = true;
          break;
        }
      }
    }

    if(is_safe) {
      sum = sum + 1;
    }

  }

  io::printfn("sum = %d", sum);

  return 0;
}