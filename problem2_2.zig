// --- Part Two ---

// The Elf finishes helping with the tent and sneaks back over to you. "Anyway, the second column says how the round needs to end: X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"

// The total score is still calculated in the same way, but now you need to figure out what shape to choose so the round ends as indicated. The example above now goes like this:

//     In the first round, your opponent will choose Rock (A), and you need the round to end in a draw (Y), so you also choose Rock. This gives you a score of 1 + 3 = 4.
//     In the second round, your opponent will choose Paper (B), and you choose Rock so you lose (X) with a score of 1 + 0 = 1.
//     In the third round, you will defeat your opponent's Scissors with Rock for a score of 1 + 6 = 7.

// Now that you're correctly decrypting the ultra top secret strategy guide, you would get a total score of 12.

// Following the Elf's instructions for the second column, what would your total score be if everything goes exactly according to your strategy guide?

const std = @import("std");

const Move = enum {
    ROCK,
    PAPER,
    SCISSORS,
    pub fn ordinal(self: Move) u8 {
        return @as(u8, 1 + @enumToInt(self));
    }
};

const Outcome = enum {
    LOSS,
    DRAW,
    WIN
};

fn mapMove(move: u8) Move {
    return switch(move) {
        'A' => Move.ROCK,
        'B' => Move.PAPER,
        'C' => Move.SCISSORS,
        else => unreachable
    };
}

fn mapOutcome(outcome: u8) Outcome {
    return switch(outcome) {
        'X' => Outcome.LOSS,
        'Y' => Outcome.DRAW,
        'Z' => Outcome.WIN,
        else => unreachable
    };
}


fn score(theirs: Move, req_outcome: Outcome) u8 {
    var result: u8 = 1;

    result += switch(theirs) {
        Move.ROCK => {
            if(req_outcome == Outcome.LOSS) {
                return  Move.SCISSORS.ordinal();
            } else if(req_outcome == Outcome.DRAW) {
                return  theirs.ordinal() + 3;
            } else {
                return  Move.PAPER.ordinal() + 6;
            }
        },
        Move.PAPER => {
            if(req_outcome == Outcome.LOSS) {
                return Move.ROCK.ordinal();
            } else if(req_outcome == Outcome.DRAW) {
                return theirs.ordinal() + 3;
            } else {
                return Move.SCISSORS.ordinal() + 6;
            }
        },
        Move.SCISSORS => {
            if(req_outcome == Outcome.LOSS) {
                return Move.PAPER.ordinal();
            } else if(req_outcome == Outcome.DRAW) {
                return theirs.ordinal() + 3;
            } else {
                return Move.ROCK.ordinal() + 6;
            }
        },
    };

    return result;
}

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input2_2.txt", .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in = buf_reader.reader();

    var theirs: Move = undefined;
    var req_outcome: Outcome = undefined;
    var total: u16 = 0;

    var buf: [1024]u8 = undefined;

    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        theirs = mapMove(line[0]);
        req_outcome = mapOutcome(line[2]);
        total += score(theirs, req_outcome);
    }

    std.debug.print("Total Score: {}", .{total});
}