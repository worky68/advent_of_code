// --- Part Two ---

// As you scan through the corrupted lex, you notice that some of the conditional statements are also still intact. If you handle some of the uncorrupted conditional statements in the program, you might be able to get an even more accurate result.

// There are two new instructions you'll need to handle:

//     The do() instruction enables future mul instructions.
//     The don't() instruction disables future mul instructions.

// Only the most recent do() or don't() instruction applies. At the beginning of the program, mul instructions are enabled.

// For example:

// xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))

// This corrupted lex is similar to the example from before, but this time the mul(5,5) and mul(11,8) instructions are disabled because there is a don't() instruction before them. The other mul instructions function normally, including the one at the end that gets re-enabled by a do() instruction.

// This time, the sum of the results is 48 (2*4 + 8*5).

// Handle the new instructions; what do you get if you add up all of the results of just the enabled multiplications?

import std::io;
import std::core::dstring;
import std::ascii;

struct Lexer {
  char* start;
  char* current;
  int length;
  bool do_mul;
}

fn char Lexer.peek(&self) {
  if(self.isAtEnd()) return '\0';
  return *self.current;
}

fn char Lexer.advance(&self) {
  self.current++;
  return self.current[-1];
}

fn bool Lexer.isAtEnd(&self) {
  return *self.current == '\0';
}

fn int Lexer.number(&self) {
  self.start = self.current;
  while(ascii::is_digit(self.peek())) self.advance();

  return ((String)self.start[:(int)(self.current - self.start)]).to_int()!!;
}

fn String! readFile(String filename) {

  File file = file::open(filename, "rb")!;
  defer (void)file.close();
  usz len = file.seek(0, END)! + 1;
  file.seek(0, SET)!;
  char* data = allocator::malloc_try(allocator::temp(), len)!;
  defer catch allocator::free(allocator::temp(), data);
  usz read = 0;
  while (read < len - 1)
  {
    read += file.read(data[read:len - read])!;
  }
  data[len - 1] = '\0';
  return (String) data[:len];
}

fn int main(String[] args) {
  String inputFile = args[1];
  
  String input = readFile(inputFile)!!;
  int sum = 0;
  int i = 0;

  Lexer lex;
  lex.start = (char*) &input[0];
  lex.current = (char*) &input[0];
  lex.length = input.len;
  lex.do_mul = true;

  while(!lex.isAtEnd()) {
    lex.start = lex.current;
    char c = lex.advance();

    if OUT: (c == 'm' && lex.do_mul) {

      if(lex.advance() == 'u' && lex.advance() == 'l') {

        char lparen = lex.advance();
        if(lparen != '(') {
          break OUT;
        }

        int num1 = lex.number();

        char comma = lex.advance();
        if(comma != ',') {
          break OUT;
        }

        int num2 = lex.number();

        char rparen = lex.advance();
        if(rparen != ')') {
          break OUT;
        }

        sum = sum + (num1 * num2);
      }
    } else if(c == 'd') {
      if(lex.advance() == 'o') {;
        if(lex.peek() == '(') {
          lex.advance();
          if(lex.peek() == ')') {
            lex.advance();
            lex.do_mul = true;
          }
        } else if(lex.peek() == 'n') {
          lex.advance();
          if(lex.peek() == '\'') {
            lex.advance();
            if(lex.peek() == 't') {
              lex.advance();
              if(lex.advance() == '(' && lex.advance() == ')') {
                lex.do_mul = false;
              }
            }
          }
        }
      }
    }
  }

  io::printfn("sum = %s", sum);
  return 0;
}