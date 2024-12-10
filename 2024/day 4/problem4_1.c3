// --- Day 4: Ceres Search ---

// "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!

// As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

// This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:

// ..X...
// .SAMX.
// .A..A.
// XMAS.S
// .X....

// The actual word search will be full of letters instead. For example:

// MMMSXXMASM
// MSAMXMSMSA
// AMXSXMAAMM
// MSAMASMSMX
// XMASAMXAMM
// XXAMMXXAMA
// SMSMSASXSS
// SAXAMASAAA
// MAMMMXMMMM
// MXMXAXMASX

// In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

// ....XXMAS.
// .SAMXMS...
// ...S..A...
// ..A.A.MS.X
// XMASAMX.MM
// X.....XA.A
// S.S.S.S.SS
// .A.A.A.A.A
// ..M.M.M.MM
// .X.X.XMASX

// Take a look at the little Elf's word search. How many times does XMAS appear?
import std::io::file;
import std::core::dstring;

fn void main(String[] args) {
  String inputFile = args[1];
  String input = (String) file::load_new(inputFile)!!;
  String[] lines = input.split("\n");

  int sum = 0;

  int i = 0;
  while(i < lines.len) {
    for(int j = 0; j < lines[i].len; j++) {
      
      if(lines[i][j] == 'X') {
        // scan current line
        if(j+3 < lines[i].len) {
          
          if(lines[i][j..j+3] == "XMAS") {
            sum++;
          }
        }

        if(j-3 >= 0) {
          
          if(lines[i][j-3..j] == "SAMX") {
            sum++;
          }
        }

        // scan up
        if(i-3 >= 0) {
          // straight up
          DString mas = dstring::temp_with_capacity(3);
          int start = 1;
          while(start < 4) {
            mas.append_char(lines[i-start][j]);
            start++;
          }
          
          if(mas.str_view() == "MAS") {
            sum++;
          }
            
          // scan diagonal top right
          if(j+3 < lines[i].len) {
            mas.clear();
            start = 1;
            while(start < 4) {
              mas.append_char(lines[i-start][j+start]);
              start++;
            }

            if(mas.str_view() == "MAS") {
              sum++;
            }
          }

          // scan diagonal top left
          if(j-3 >= 0) {
            mas.clear();
            start = 1;
            while(start < 4) {
              mas.append_char(lines[i-start][j-start]);
              start++;
            }

            if(mas.str_view() == "MAS") {
              sum++;
            }
          }
        }

        // scan down
        if(i+3 < lines.len) {

          // straight down
          DString mas = dstring::temp_with_capacity(3);
          int start = 1;
          while(start < 4) {
            mas.append_char(lines[i+start][j]);
            start++;
          }

          if(mas.str_view() == "MAS") {
            sum++;
          }

          // scan diagonal bottom left
          if(j-3 >= 0) {
            mas.clear();
            start = 1;
            while(start < 4) {
              mas.append_char(lines[i+start][j-start]);
              start++;
            }

            if(mas.str_view() == "MAS") {
              sum++;
            }
          }

          // scan diagonal bottom right
          if(j+3 < lines[i].len) {
            mas.clear();
            start = 1;
            while(start < 4) {
              mas.append_char(lines[i+start][j+start]);
              start++;
            }

            if(mas.str_view() == "MAS") {
              sum++;
            }
          }
        }
      }
    }
    i++;
  }

  io::printfn("sum = %s", sum);

}