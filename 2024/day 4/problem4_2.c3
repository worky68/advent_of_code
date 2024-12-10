// --- Part Two ---

// The Elf looks quizzically at you. Did you misunderstand the assignment?

// Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

// M.S
// .A.
// M.S

// Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

// Here's the same example from before, but this time all of the X-MASes have been kept instead:

// .M.S......
// ..A..MSMS.
// .M.S.MAA..
// ..A.ASMSM.
// .M.S.M....
// ..........
// S.S.S.S.S.
// .A.A.A.A..
// M.M.M.M.M.
// ..........

// In this example, an X-MAS appears 9 times.

// Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?
import std::io::file;

fn void main(String[] args) {
  String inputFile = args[1];
  String input = (String) file::load_temp(inputFile)!!;

  String[] lines = input.tsplit("\n");

  int sum = 0;
  int rows = lines.len;
  int cols = lines[0].len;
  for (int row = 1; row < rows - 1; ++row) {
    for (int col = 1; col < cols - 1; ++col) {
      if (
          lines[row][col] == 'A'
       && 
          ((lines[row - 1][col - 1] == 'M' && lines[row + 1][col + 1] == 'S')
        || (lines[row - 1][col - 1] == 'S' && lines[row + 1][col + 1] == 'M'))
       && 
          ((lines[row - 1][col + 1] == 'M' && lines[row + 1][col - 1] == 'S')
        || (lines[row - 1][col + 1] == 'S' && lines[row + 1][col - 1] == 'M')))
       {
          sum++;
      }
    }
  }

  io::printfn("sum = %s", sum);

}