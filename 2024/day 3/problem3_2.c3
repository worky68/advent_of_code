// --- Part Two ---

// As you scan through the corrupted memory, you notice that some of the conditional statements are also still intact. If you handle some of the uncorrupted conditional statements in the program, you might be able to get an even more accurate result.

// There are two new instructions you'll need to handle:

//     The do() instruction enables future mul instructions.
//     The don't() instruction disables future mul instructions.

// Only the most recent do() or don't() instruction applies. At the beginning of the program, mul instructions are enabled.

// For example:

// xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))

// This corrupted memory is similar to the example from before, but this time the mul(5,5) and mul(11,8) instructions are disabled because there is a don't() instruction before them. The other mul instructions function normally, including the one at the end that gets re-enabled by a do() instruction.

// This time, the sum of the results is 48 (2*4 + 8*5).

// Handle the new instructions; what do you get if you add up all of the results of just the enabled multiplications?

import std::io;
import std::core::dstring;
import std::ascii;

struct Memory {
  char* start;
  char* current;
  int length;
  bool do_mul;
}

fn char Memory.peek(&self) {
  if(self.isAtEnd()) return '\0';
  return *self.current;
}

fn char Memory.advance(&self) {
  self.current++;
  return self.current[-1];
}

fn bool Memory.isAtEnd(&self) {
  return *self.current == '\0';
}

fn int Memory.number(&self) {
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

  Memory memory;
  memory.start = (char*) &input[0];
  memory.current = (char*) &input[0];
  memory.length = input.len;
  memory.do_mul = true;

  while(!memory.isAtEnd()) {
    memory.start = memory.current;
    char c = memory.advance();

    if OUT: (c == 'm' && memory.do_mul) {

      if(memory.advance() == 'u' && memory.advance() == 'l') {

        char lparen = memory.advance();
        if(lparen != '(') {
          break OUT;
        }

        int num1 = memory.number();

        char comma = memory.advance();
        if(comma != ',') {
          break OUT;
        }

        int num2 = memory.number();

        char rparen = memory.advance();
        if(rparen != ')') {
          break OUT;
        }

        sum = sum + (num1 * num2);
      }
    } else if(c == 'd') {
      if(memory.advance() == 'o') {;
        if(memory.peek() == '(') {
          memory.advance();
          if(memory.peek() == ')') {
            memory.advance();
            memory.do_mul = true;
          }
        } else if(memory.peek() == 'n') {
          memory.advance();
          if(memory.peek() == '\'') {
            memory.advance();
            if(memory.peek() == 't') {
              memory.advance();
              if(memory.advance() == '(' && memory.advance() == ')') {
                memory.do_mul = false;
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