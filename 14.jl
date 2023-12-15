# part1 9 mins, part2 1:20h

parseinput(lines) =
  permutedims(stack(split(lines)))

northload(d::AbstractMatrix) = sum(northload.(eachcol(d)))
northload(col::AbstractVector) = sum((col .== 'O') .* reverse(1:length(col)))

moveend!(d::AbstractMatrix) = (foreach(moveend!, eachcol(d)); d)
function moveend!(col)
  stones = 0
  laststone = 0
  l = length(col)
  @inbounds for i in 1:l+1
    if i > l || col[i] == '#'
      col[i-stones:i-1] .= 'O'
      laststone = i
      stones = 0
    elseif col[i] == 'O'
      col[i] = '.'
      stones += 1
    end
  end
end

north(d) = rot180(moveend!(rot180(d)))
south(d) = moveend!(copy(d))
west(d) = rotr90(moveend!(rotl90(d)))
east(d) = rotl90(moveend!(rotr90(d)))

cycle(d) = d |> north |> west |> south |> east

function part1(input)
  d = parseinput(input)
  northload(north(d))
end

function part2(input, cycles=1000000000)
  dict = Dict()
  d = parseinput(input)
  for i in 1:1000000000
    d = cycle(d)
    if haskey(dict, d)
      period = i - dict[d]
      remaining = (cycles - i) % period
      for i in 1:remaining
        d = cycle(d)
      end
      return northload(d)
    end
    dict[d] = i
  end
  return northload(d)
end

###

data = String(read("14.in"))
ex = String(read("14.ex"))

function test()
  @assert part1(data) == 109833
  @assert part2(data) == 99875
end