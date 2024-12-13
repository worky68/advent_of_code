// --- Day 3: Mull It Over ---

// "Our computers are having issues, so I have no idea if we have any Chief Historians in stock! You're welcome to check the warehouse, though," says the mildly flustered shopkeeper at the North Pole Toboggan Rental Shop. The Historians head out to take a look.

// The shopkeeper turns to you. "Any chance you can see why our computers are having issues again?"

// The computer appears to be trying to run a program, but its lex (your puzzle input) is corrupted. All of the instructions have been jumbled up!

// It seems like the goal of the program is just to multiply some numbers. It does that with instructions like mul(X,Y), where X and Y are each 1-3 digit numbers. For instance, mul(44,46) multiplies 44 by 46 to get a result of 2024. Similarly, mul(123,4) would multiply 123 by 4.

// However, because the program's lex has been corrupted, there are also many invalid characters that should be ignored, even if they look like part of a mul instruction. Sequences like mul(4*, mul(6,9!, ?(12,34), or mul ( 2 , 4 ) do nothing.

// For example, consider the following section of corrupted lex:

// xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))

// Only the four highlighted sections are real mul instructions. Adding up the result of each instruction produces 161 (2*4 + 5*5 + 11*8 + 8*5).

// Scan the corrupted lex for uncorrupted mul instructions. What do you get if you add up all of the results of the multiplications?
import std::io;
import std::core::dstring;
import std::ascii;

struct Lexer {
  char* start;
  char* current;
  int length;
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

  while(!lex.isAtEnd()) {
    lex.start = lex.current;
    char c = lex.advance();

    if OUT: (c == 'm') {

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
    }
  }

  io::printfn("sum = %s", sum);
  return 0;
}