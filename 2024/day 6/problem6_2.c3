// --- Part Two ---

// While The Historians begin working around the guard's patrol route, you borrow their fancy device and step outside the lab. From the safety of a supply closet, you time travel through the last few months and record the nightly status of the lab's guard post on the walls of the closet.

// Returning after what seems like only a few seconds to The Historians, they explain that the guard's patrol area is simply too large for them to safely search the lab without getting caught.

// Fortunately, they are pretty sure that adding a single new obstruction won't cause a time paradox. They'd like to place the new obstruction in such a way that the guard will get stuck in a loop, making the rest of the lab safe to search.

// To have the lowest chance of creating a time paradox, The Historians would like to know all of the possible positions for such an obstruction. The new obstruction can't be placed at the guard's starting position - the guard is there right now and would notice.

// In the above example, there are only 6 different positions where a new obstruction would cause the guard to get stuck in a loop. The diagrams of these six situations use O to mark the new obstruction, | to show a position where the guard moves up/down, - to show a position where the guard moves left/right, and + to show a position where the guard moves both up/down and left/right.

// Option one, put a printing press next to the guard's starting position:

// ....#.....
// ....+---+#
// ....|...|.
// ..#.|...|.
// ....|..#|.
// ....|...|.
// .#.O^---+.
// ........#.
// #.........
// ......#...

// Option two, put a stack of failed suit prototypes in the bottom right quadrant of the mapped area:

// ....#.....
// ....+---+#
// ....|...|.
// ..#.|...|.
// ..+-+-+#|.
// ..|.|.|.|.
// .#+-^-+-+.
// ......O.#.
// #.........
// ......#...

// Option three, put a crate of chimney-squeeze prototype fabric next to the standing desk in the bottom right quadrant:

// ....#.....
// ....+---+#
// ....|...|.
// ..#.|...|.
// ..+-+-+#|.
// ..|.|.|.|.
// .#+-^-+-+.
// .+----+O#.
// #+----+...
// ......#...

// Option four, put an alchemical retroencabulator near the bottom left corner:

// ....#.....
// ....+---+#
// ....|...|.
// ..#.|...|.
// ..+-+-+#|.
// ..|.|.|.|.
// .#+-^-+-+.
// ..|...|.#.
// #O+---+...
// ......#...

// Option five, put the alchemical retroencabulator a bit to the right instead:

// ....#.....
// ....+---+#
// ....|...|.
// ..#.|...|.
// ..+-+-+#|.
// ..|.|.|.|.
// .#+-^-+-+.
// ....|.|.#.
// #..O+-+...
// ......#...

// Option six, put a tank of sovereign glue right next to the tank of universal solvent:

// ....#.....
// ....+---+#
// ....|...|.
// ..#.|...|.
// ..+-+-+#|.
// ..|.|.|.|.
// .#+-^-+-+.
// .+----++#.
// #+----++..
// ......#O..

// It doesn't really matter what you choose to use as an obstacle so long as you and The Historians can put it into position without the guard noticing. The important thing is having enough options that you can find one that minimizes time paradoxes, and in this example, there are 6 different positions you could choose.

// You need to get the guard stuck in a loop by adding a single new obstruction. How many different positions could you choose for this obstruction?
import std::io::file;
import std::collections::map;
import std::core::string;

fn void print_matrix(String[] lines) {
  for(int i = 0; i < lines.len; i++) {
    for(int j = 0; j < lines[i].len; j++) {
      io::printf("%c", lines[i][j]);
    }
    io::printfn("");
  }
}

fn bool loop_detected(int i, int j, char dir, String[] lines) {

  HashMap(<String, char>) seen;
  seen.temp_init();

  while(i < lines.len && i >= 0 && j >= 0 && j < lines[0].len) {
    char c = lines[i][j];
    String key = string::tformat("%s,%s,%s", i, j, dir);
    
    if(seen.has_key(key)) {
      return true;
    }

    if(lines[i][j] == '#' || lines[i][j] == 'O') {
      if(dir == '^') {
        dir = '>';
        j++;
        i++;
      } else if(dir == 'v') {
        dir = '<';
        j--;
        i--;
      } else if(dir == '>') {
        dir = 'v';
        i++;
        j--;
      } else if(dir == '<') {
        dir = '^';
        i--;
        j++;
      }
    } else {

      if(dir == '^') {
        i--;
      } else if(dir == 'v') {
        i++;
      } else if(dir == '>') {
        j++;
      } else if(dir == '<') {
        j--;
      }

      seen.set(key, 0);

    }
  }

  return false;
}

fn void main(String[] args) {
  String inputFile = args[1];
  String input = (String) file::load_temp(inputFile)!!;

  String[] lines = input.tsplit("\n");
  
  int i = 0;
  int j = 0;
  while OUT: (i < lines.len) {
    String line = lines[i];
    j = 0;
    while(j < line.len) {
      if(line[j] == '^' || line[j] == '>' || line[j] == '<' || line[j] == 'v') {
        break OUT;
      }
      j++;
    }
    i++;
  }

  char dir = lines[i][j];
  char startDir = dir;

  if(dir == '^') {
    i--;
  } else if(dir == 'v') {
    i++;
  } else if(dir == '>') {
    j++;
  } else if(dir == '<') {
    j--;
  }

  int starti = i;
  int startj = j;
  int sum  = 0;
  HashMap(<String, char>) seen;
  seen.temp_init();

  while(i < lines.len && i >= 0 && j >= 0 && j < lines[0].len) {
    char c = lines[i][j];

    if(lines[i][j] == '#') {
      if(dir == '^') {
        dir = '>';
        j++;
        i++;
      } else if(dir == 'v') {
        dir = '<';
        j--;
        i--;
      } else if(dir == '>') {
        dir = 'v';
        i++;
        j--;
      } else if(dir == '<') {
        dir = '^';
        i--;
        j++;
      }
    } else {
      
      // left
      if(j-1 >= 0) {
        String key = string::tformat("%s,%s", i, j-1);
        if(!seen.has_key(key)) {
          char temp = lines[i][j-1];
          lines[i][j-1] = 'O';
          if(loop_detected(starti, startj, startDir, lines)) {
            // io::printfn("loop detected:");
            // print_matrix(lines);
            sum += 1;
          }
          lines[i][j-1] = temp;
          seen.set(key, 0);
        }
      }

      // right
      if(j+1 < lines[i].len) {
        String key = string::tformat("%s,%s", i, j+1);
        if(!seen.has_key(key)) {
          char temp = lines[i][j+1];
          lines[i][j+1] = 'O';
          if(loop_detected(starti, startj, startDir, lines)) {
            // io::printfn("loop detected:");
            // print_matrix(lines);
            sum += 1;
          }
          lines[i][j+1] = temp;
          seen.set(key, 0);
        }
      }

      // front
      if(i-1 >= 0) {
        String key = string::tformat("%s,%s", i-1, j);
        char temp = lines[i-1][j];
        if(!seen.has_key(key)) {
          lines[i-1][j] = 'O';
          if(loop_detected(starti, startj, startDir, lines)) {
            // io::printfn("loop detected:");
            // print_matrix(lines);
            sum += 1;
          }
          lines[i-1][j] = temp;
          seen.set(key, 0);
        }
      }
      
      // back
      if(i != starti && i+1 < lines.len) {
        String key = string::tformat("%s,%s", i+1, j);
        char temp = lines[i+1][j];
        if(!seen.has_key(key)) {
          lines[i+1][j] = 'O';
          if(loop_detected(starti, startj, startDir, lines)) {
            // io::printfn("loop detected:");
            // print_matrix(lines);
            sum += 1;
          }
          lines[i+1][j] = temp;
          seen.set(key, 0);
        }
      }

      if(dir == '^') {
        i--;
      } else if(dir == 'v') {
        i++;
      } else if(dir == '>') {
        j++;
      } else if(dir == '<') {
        j--;
      }

    }
  }

  io::printfn("sum = %s", sum);

}