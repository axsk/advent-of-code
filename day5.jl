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

# replace(in::Int, m) = replace([(in, in)], m)

# function replace(input::Tuple, (dest, source, len))
#   i1, i2 = input
#   t1, t2 = source, source + len - 1
#   offset = dest - source

#   ints = [
#     (i1, min(i2, t1 - 1)), # before match
#     (max(i1, t2 + 1), i2), # after match
#     (max(i1, t1) + offset, min(i2, t2) + offset)] # replaced match

#   filter(x -> x[1] <= x[2], ints)
# end

function splitintervals(A::AbstractRange, B::AbstractRange)
  C = intersect(A, B)
  L = A.start:C.start-1
  R = C.stop+1:A.stop
  return C, L, R
end

function replace(seed::AbstractRange, (dest, source, len))
  S = source:source+len-1
  C, L, R = splitintervals(seed, S)
  if !isempty(C)
    C = C .+ ((dest - source) + findfirst(==(C.start), S) - 1)
  end
  return (C, L, R)::Tuple{AbstractRange,AbstractRange,AbstractRange}
end

function test(seeds, section)

  reduce(section; init=(seeds, similar(seeds, 0))) do (seeds, done), mapping
    S, D = mapreduce(((s1, s2), b) -> ([s1; b[1]], [s2; b[2]]), seeds) do interval
      C, L, R = replace(interval, mapping)
      [L, R], [C]
    end
    return S, vcat(D, done)
  end
end

#   i1, i2 = input
#   t1, t2 = source, source + len - 1
#   offset = dest - source

#   ints = [
#     (i1, min(i2, t1 - 1)), # before match
#     (max(i1, t2 + 1), i2), # after match
#     (max(i1, t1) + offset, min(i2, t2) + offset)] # replaced match

#   filter(x -> x[1] <= x[2], ints)
# end

replace(input::Vector, m::Tuple) =
  mapreduce(vcat, input) do inp
    replace(inp, m)
  end

function replace(ints::Vector, maps::Vector)
  for m in maps
    @show m
    @show ints = replace(ints, m)
  end
  ints
end



function part2int(data=data)
  seeds, maps = parseinput(data)
  minimum(1:2:length(seeds)) do i
    @show ints = [seeds[i] .+ (0, seeds[i+1] - 1)]
    for map in reduce(vcat, maps)
      @show ints = replace(ints, map)
    end
    minimum(minimum.(ints))
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