// --- Part Two ---

// By the time you calculate the answer to the Elves' question, they've already realized that the Elf carrying the most Calories of food might eventually run out of snacks.

// To avoid this unacceptable situation, the Elves would instead like to know the total Calories carried by the top three Elves carrying the most Calories. That way, even if one of those Elves runs out of snacks, they still have two backups.

// In the example above, the top three Elves are the fourth Elf (with 24000 Calories), then the third Elf (with 11000 Calories), then the fifth Elf (with 10000 Calories). The sum of the Calories carried by these three elves is 45000.

// Find the top three Elves carrying the most Calories. How many Calories are those Elves carrying in total?

const std = @import("std");
const Order =  std.math.Order;
const AllocPrintError = std.fmt.AllocPrintError;

const elf = struct {
    name: []u8,
    calories: u32
};

const MaxHeap = std.PriorityQueue(elf, void, greaterThan);

pub fn greaterThan(context: void, elf1: elf, elf2: elf) Order {
    _ = context;
    return std.math.order(elf1.calories, elf2.calories).invert();
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var maxHeap = MaxHeap.init(allocator, {});
    defer maxHeap.deinit();
    var elf_num: u16 = 1;

    var file = try std.fs.cwd().openFile("input1_2.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in = buf_reader.reader();
    var current_elf = elf {
        .name = try std.fmt.allocPrint(allocator, "{s}{}", .{"elf", elf_num}),
        .calories = 0
    };
    var buf: [1024]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});

        if(line.len == 0) {
            try maxHeap.add(current_elf);
            elf_num = elf_num + 1;
            current_elf = elf {
                .name = try std.fmt.allocPrint(allocator, "{s}{}", .{"elf", elf_num}),
                .calories = 0
            };
            continue;
        } else {
            current_elf.calories = current_elf.calories + try std.fmt.parseInt(u32, line, 0);
        }

    }
    const maxElf1 = maxHeap.remove();
    std.debug.print("{s} with {}\n", .{maxElf1.name , maxElf1.calories});

    const maxElf2 = maxHeap.remove();
    std.debug.print("{s} with {}\n", .{maxElf2.name , maxElf2.calories});

    const maxElf3 = maxHeap.remove();
    std.debug.print("{s} with {}\n", .{maxElf3.name , maxElf3.calories});
    
    const total: u32 = maxElf1.calories + maxElf2.calories + maxElf3.calories;
    std.debug.print("Total {}\n", .{total});
}