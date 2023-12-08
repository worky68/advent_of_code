# --- Part Two ---

# Everyone will starve if you only plant such a small number of seeds. Re-reading the almanac, it looks like the seeds: line actually describes ranges of seed numbers.

# The values on the initial seeds: line come in pairs. Within each pair, the first value is the start of the range and the second value is the length of the range. So, in the first line of the example above:

# seeds: 79 14 55 13

# This line describes two ranges of seed numbers to be planted in the garden. The first range starts with seed number 79 and contains 14 values: 79, 80, ..., 91, 92. The second range starts with seed number 55 and contains 13 values: 55, 56, ..., 66, 67.

# Now, rather than considering four seed numbers, you need to consider a total of 27 seed numbers.

# In the above example, the lowest location number can be obtained from seed number 82, which corresponds to soil 84, fertilizer 84, water 84, light 77, temperature 45, humidity 46, and location 46. So, the lowest location number is 46.

# Consider all of the initial seed numbers listed in the ranges on the first line of the almanac. What is the lowest location number that corresponds to any of the initial seed numbers?

# XXX: this takes ~20 minutes to run against input

import std/strutils
import std/strformat

var seeds: seq[(int, int)];
var seed_to_soil = newSeq[(int, int, int)]();
var soil_to_fert = newSeq[(int, int, int)]();
var fert_to_water = newSeq[(int, int, int)]();
var water_to_light = newSeq[(int, int, int)]();
var light_to_temp = newSeq[(int, int, int)]();
var temp_to_humid = newSeq[(int, int, int)]();
var humid_to_loc = newSeq[(int, int, int)]();


proc getSeeds(line: string): seq[(int, int)] =
    var temp = line.split(":")[1].split(" ");
    var seeds = newSeq[(int, int)]();
    var i = 0;
    while(i < temp.len):
        var seed = temp[i];
        if(seed.isEmptyOrWhitespace()):
            inc i;
            continue;
        var length = temp[i+1]
        seeds.add((parseInt(seed), parseInt(length)));
        i = i+2;
    return seeds;

proc getMapping(lines: seq[string], mapping: var seq[(int, int, int)], offset: int): int =
    var i = offset;
    while(i < lines.len):
        var line = lines[i];
        if(line.isEmptyOrWhitespace()):
            break;

        var input = line.split(" ");
        var dest = parseInt(input[0]);
        var src = parseInt(input[1]);
        var length = parseInt(input[2]);

        mapping.add((dest, src, length));

        inc i;
    return i;

proc getLocation(seed: int): int =

    var soil = seed;
    for mapping in seed_to_soil:

        var dest = mapping[0];
        var src = mapping[1];
        var length = mapping[2];

        if(seed in src..src+length):
            var dist = src - dest;

            if(dist < 0):
                soil = abs(dist) + seed;
                break;
            else:
                soil = seed - abs(dist);
                break;

    var fert = soil;
    for mapping in soil_to_fert:

        var dest = mapping[0];
        var src = mapping[1];
        var length = mapping[2];

        if(soil in src..src+length):
            var dist = src - dest;
            if(dist < 0):
                fert = abs(dist) + soil;
                break;
            else:
                fert = soil - abs(dist);
                break;

    var water = fert;
    for mapping in fert_to_water:

        var dest = mapping[0];
        var src = mapping[1];
        var length = mapping[2];

        if(fert in src..src+length):
            var dist = src - dest;
            if(dist < 0):
                water = abs(dist) + fert;
                break;
            else:
                water = fert - abs(dist);
                break;

    var light = water;
    for mapping in water_to_light:

        var dest = mapping[0];
        var src = mapping[1];
        var length = mapping[2];

        if(water in src..src+length):
            var dist = src - dest;
            if(dist < 0):
                light = abs(dist) + water;
                break;
            else:
                light = water - abs(dist);
                break;

    var temp = light;
    for mapping in light_to_temp:

        var dest = mapping[0];
        var src = mapping[1];
        var length = mapping[2];

        if(light in src..src+length):
            var dist = src - dest;
            if(dist < 0):
                    temp = abs(dist) + light;
                    break;
            else:
                    temp = light - dist;
                    break;

    var humid = temp;
    for mapping in temp_to_humid:

        var dest = mapping[0];
        var src = mapping[1];
        var length = mapping[2];

        if(temp in src..src+length):
            var dist = src - dest;
            if(dist < 0):
                humid = abs(dist) + temp;
                break;
            else:
                humid = temp - abs(dist);
                break;

    var loc = humid;
    for mapping in humid_to_loc:
        var dest = mapping[0];
        var src = mapping[1];
        var length = mapping[2];

        if(humid in src..src+length):
            var dist = src - dest;
            if(dist < 0):
                loc = abs(dist) + humid;
                break;
            else:
                loc = humid - abs(dist);
                break;

    return loc;

let lines = readFile("input5_2.txt").splitLines();

var lowest = -1;

var i = 0;
while(i < lines.len):
    var line = lines[i];

    if("seeds" in line):
        seeds = getSeeds(line);

    elif("seed-to-soil" in line):
        i = getMapping(lines, seed_to_soil, i+1);

    elif("soil-to-fertilizer" in line):
        i = getMapping(lines, soil_to_fert, i+1);

    elif("fertilizer-to-water" in line):
        i = getMapping(lines, fert_to_water, i+1);

    elif("water-to-light" in line):
        i = getMapping(lines, water_to_light, i+1);

    elif("light-to-temperature" in line):
        i = getMapping(lines, light_to_temp, i+1);

    elif("temperature-to-humidity" in line):
        i = getMapping(lines, temp_to_humid, i+1);

    elif("humidity-to-location" in line):
        i = getMapping(lines, humid_to_loc, i+1);

    inc i;

for seed in seeds:
    for i in seed[0]..seed[0]+seed[1]:
        var loc = getLocation(i);
        if(loc < lowest or lowest == -1):
            lowest = loc;

echo(fmt"lowest = {lowest}");