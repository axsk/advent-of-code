function parse_input(input)
  lines = split(input, "\n")
  times = parse.(Int, split(split(lines[1], ":")[2]))
  distances = parse.(Int, split(split(lines[2], ":")[2]))
  return times, distances
end

distance(charge, time) = charge * (time - charge)

beats(time, dist) =
  sum(1:time) do t
    distance(t, time) > dist
  end

function day1(data=data)
  times, distances = parse_input(data)
  return prod(beats.(times, distances))
end

function day2(data=data)
  times, distances = parse_input(data)
  beats(parse.(Int, join.([times, distances]))...)
end

sample = raw"Time:      7  15   30
Distance:  9  40  200"

data = raw"Time:        40     92     97     90
Distance:   215   1064   1505   1100"