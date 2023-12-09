# part 1: 9 mins, part 2: 18 mins
# where i used the ugly explicit formulation for part2
# reverse trick spotted only afterwards

function parseinput(lines)
  map(lines) do l
    parse.(Int, split(l))
  end
end

function part1(data)
  sum(parseinput(data) |> extrapolate)
end

function part2(data)
  sum(parseinput(data) .|> reverse .|> extrapolate)
end

function extrapolate(series)
  diffs = series
  sol = 0
  while any(diffs .!= 0)
    sol += diffs[end]
    diffs = diff(diffs)
  end
  sol
end

###

sample = split("0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45", "\n")

@assert part1(sample) == 114
@assert part2(sample) == 2