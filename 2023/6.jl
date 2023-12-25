# once more this took longer then it should
function parse_input(input)
  lines = split(input, "\n")
  times = parse.(Int, split(split(lines[1], ":")[2]))
  distances = parse.(Int, split(split(lines[2], ":")[2]))
  return times, distances
end

# had charge * time here first :/
distance(charge, time) = charge * (time - charge)

# made the mistake to call distance and dist the same
# such that distance wasnt callable anymore
# took me a few mins to correct :/
beats(time, dist) =
  sum(1:time) do charge
    charge * (time - charge) > dist
  end

beats(t, d) = beats(t, d)

function part1(data=data)
  times, distances = parse_input(data)
  return prod(beats.(times, distances))
end

function part2(data=data)
  times, distances = parse_input(data)
  beats(parse.(Int, join.((times, distances)))...)
end

# how can i make revise deal with this part?
sample = raw"Time:      7  15   30
Distance:  9  40  200"

data = raw"Time:        40     92     97     90
Distance:   215   1064   1505   1100"

# wrote this after the challenge
function beatsexplicit(t, d)
  if (t / 2)^2 - d > 0
    u = floor(t / 2 + sqrt((t / 2)^2 - d))
    l = ceil(t / 2 - sqrt((t / 2)^2 - d))
    return Int(u - l + 1)
  else
    return 0
  end
end