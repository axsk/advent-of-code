# 29 mins for part 1
# 22 mins for part 2

using Folds  # multithreaded reduction

function parseinput(data=data)
  cats = split(data, ":")[2:end]
  seeds = map(x -> parse(Int, x.match), eachmatch(r"(\d+)", cats[1]))

  repls = map(cats[2:end]) do cat
    map(eachmatch(r"(\d+) (\d+) (\d+)", cat)) do m
      Tuple(parse.(Int, split(m.match)))::Tuple{Int,Int,Int} # type stability matters here
    end
  end

  return seeds, repls
end

function findloc(seed, repls)
  input = seed
  for repl in repls
    output = input
    for (dest, source, len) in repl
      if source <= input <= source + len - 1
        output = input - source + dest
      end
    end
    input = output
  end
  return location = input
end

function part1(data=data)
  seeds, repls = parseinput(data)
  minimum(findloc.(seeds, Ref(repls)))
end

function part2(data=data)
  seeds, repls = parseinput(data)
  minimum(1:2:length(seeds)) do i
    @time Folds.minimum(seeds[i]:seeds[i]+seeds[i+1]) do seed
      findloc(seed, repls)
    end
  end
end


data = readchomp("data/day5.txt")
sample = raw"seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4"