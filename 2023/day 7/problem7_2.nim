# --- Part Two ---

# To make things a little more interesting, the Elf introduces one additional rule. Now, J cards are jokers - wildcards that can act like whatever card would make the hand the strongest type possible.

# To balance this, J cards are now the weakest individual cards, weaker even than 2. The other cards stay in the same order: A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J.

# J cards can pretend to be whatever card is best for the purpose of determining hand type; for example, QJJQ2 is now considered four of a kind. However, for the purpose of breaking ties between two hands of the same type, J is always treated as J, not the card it's pretending to be: JKKK2 is weaker than QQQQ2 because J is weaker than Q.

# Now, the above example goes very differently:

# 32T3K 765
# T55J5 684
# KK677 28
# KTJJT 220
# QQQJA 483

#     32T3K is still the only one pair; it doesn't contain any jokers, so its strength doesn't increase.
#     KK677 is now the only two pair, making it the second-weakest hand.
#     T55J5, KTJJT, and QQQJA are now all four of a kind! T55J5 gets rank 3, QQQJA gets rank 4, and KTJJT gets rank 5.

# With the new joker rule, the total winnings in this example are 5905.

# Using the new joker rule, find the rank of every hand in your set. What are the new total winnings?
import std/strutils;
import std/strformat;
import std/heapqueue;
import std/tables;

type Hand = object
    cards: string
    rank: int
    bid: int

const card_to_strength = {'A': 13, 'K': 12, 'Q': 11, 'T': 10, '9': 9, '8': 8, '7': 7, '6': 6, '5': 5, '4': 4, '3': 3, '2': 2, 'J': 1}.toTable;

proc `<`(this, that: Hand): bool =
    var i = 0;
    if(this.rank == that.rank):
        while(i < this.cards.len):
            var thisCard = card_to_strength[this.cards[i]];
            var thatCard = card_to_strength[that.cards[i]];
            if(thisCard == thatCard):
                inc i;
                continue;
            else:
                return thisCard > thatCard;
            inc i;
    else:
        return this.rank > that.rank;

proc isFiveOfAKind(hand: string): bool =
    var jokers = hand.count('J');

    if(jokers == 5):
        return true;

    for c in hand:
        if(c == 'J'):
            continue;
        var count = hand.count(c);
        if(count == 5 or count+jokers == 5):
            return true;
    return false;

proc isFourOfAKind(hand: string): bool =
    var jokers = hand.count('J');

    for c in hand:
        if(c == 'J'):
            continue;
        var count = hand.count(c);
        if(count == 4 or count+jokers == 4):
            return true;
    return false;

proc isFullHouse(hand: string): bool =
    var jokers = hand.count('J');
    var firstc: char;
    var first = 0;
    var usedJokers = false;
    for c in hand:
        if(c == 'J' or firstc == c):
            continue;
        var count = hand.count(c);
        if(count == 3):
            if(first == 2):
                return true;
            elif(first == 0):
                firstc = c;
                first = 3;
        elif(not usedJokers and count+jokers == 3):
            if(first == 2):
                return true;
            elif(first == 0):
                firstc = c;
                first = 3;
                usedJokers = true;
        elif(count == 2):
            if(first == 3):
                return true;
            elif(first == 0):
                firstc = c;
                first = 2;
        elif(not usedJokers and count+jokers == 2):
            if(first == 3):
                return true;
            elif(first == 0):
                firstc = c;
                first = 2;
                usedJokers = true;
    return false;

proc isThreeOfAKind(hand: string): bool =
    var jokers = hand.count('J');

    if(jokers == 3):
        return true;

    for c in hand:
        if(c == 'J'):
            continue;
        var count = hand.count(c);
        if(count == 3 or count+jokers == 3):
            return true;
    return false;

proc isTwoPair(hand: string): bool =
    var jokers = hand.count('J');
    var firstc: char;
    var first = false;
    var usedJokers = false;
    for c in hand:
        if(c == 'J' or firstc == c):
            continue;
        var count = hand.count(c);
        if(count == 2):
            if(first == true):
                return true;
            else:
                firstc = c;
                first = true;
        elif(not usedJokers and count+jokers == 2):
            if(first == true):
                return true;
            else:
                firstc = c;
                first = true;
                usedJokers = true;
    return false;

proc isOnePair(hand: string): bool =
    var jokers = hand.count('J');

    if(jokers == 2):
        return true;

    for c in hand:
        if(c == 'J'):
            continue;
        var count = hand.count(c);
        if(count == 2 or count+jokers == 2):
            return true;
    return false;

proc rank(hand: string): int =

    if(isFiveOfAKind(hand)):
        return 7;
    elif(isFourOfAKind(hand)):
        return 6;
    elif(isFullHouse(hand)):
        return 5;
    elif(isThreeOfAKind(hand)):
        return 4;
    elif(isTwoPair(hand)):
        return 3;
    elif(isOnePair(hand)):
        return 2;

    return 1;

let lines = readFile("input7_2.txt").splitLines();
var total = 0;
var rankings = initHeapQueue[Hand]();

for line in lines:
    var hand = line.split(" ")[0];
    var bid = parseInt(line.split(" ")[1]);
    var rank = rank(hand);

    rankings.push(Hand(cards: hand, rank: rank, bid: bid));

var i = rankings.len;
while(i > 0):
    var hand = rankings.pop();
    echo(fmt"hand = {hand.cards} hand rank = {hand.rank} true rank = {i} bid = {hand.bid}");
    total += hand.bid * i;
    dec i;

echo(fmt"total = {total}");