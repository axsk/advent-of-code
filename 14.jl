# part1 9 mins, part2 1:20h

parseinput(lines) =
  permutedims(stack(split(lines)))

function colweight(col)
  stones = 0
  weight = 0
  for i in 1:length(col)
    if col[i] == 'O'
      stones += 1
      @show weight += i
      #weight += 2^(length(col) - i)
    elseif col[i] == '#'
      #weight += i
      stones = 0
    elseif col[i] == '.'
      weight += stones
    end
  end
  return weight
end

northload(col::AbstractVector) = sum((col .== 'O') .* reverse(1:length(col)))
northload(d::AbstractMatrix) = sum(northload.(eachcol(d)))

colweight(d::AbstractMatrix) = sum(
  colweight(col) for col in eachcol(d)
)


colweightmove!(d::AbstractMatrix) = sum(
  colweightmove!(col) for col in eachcol(d)
)

function colweightmove!(col)
  #col = copy(col)
  stones = 0
  weight = 0
  laststone = 0
  for i in 1:length(col)
    if col[i] == 'O'
      stones += 1
      weight += i
    elseif col[i] == '#'
      col[laststone+1:i-1] .= '.'
      col[i-stones:i-1] .= 'O'
      laststone = i
      stones = 0
    elseif col[i] == '.'
      weight += stones
    end
  end
  i = length(col) + 1
  col[laststone+1:i-1] .= '.'
  col[i-stones:i-1] .= 'O'
  return weight
end

function part1(input)
  d = parseinput(input)
  sum(eachcol(d)) do col
    colweight(reverse(col))
  end
end

function cycle(d)
  north(d)
  west(d)
  south(d)
  east(d)

  northload(d)
end

# solved it "by hand" using cycle from here on
function part2(input, cycles=1000000000)
  d = parseinput(input)

  for i in 1:cycles
    north(d)
    west(d)
    south(d)
    east(d)

    @show i, northload(d)
  end

  colweight(revview(d))
  #=for i in 1:1
    d = rotclockw(d)
  end

  for i in 1:4*cycles
    d = rotclockw(d)
    w = colweightmove!(d)

    if i % 4 == 0
      @show w
      @show colweight(d)
      @show colweight(reverse(d, dims=1))

      @show colweight(reverse(rotclockw(d), dims=1))
      @show colweight(rotclockw(d))
    end

  end
  =#


  d
end

function east(d)
  colweightmove!.(eachrow(d))
end

function north(d)
  colweightmove!.(eachcol(revview(d)))
end

function south(d)
  colweightmove!.(eachcol(d))
end

function west(d)
  colweightmove!.(eachrow(revhor(d)))
end

function revview(d)
  view(d, size(d, 1):-1:1, 1:size(d, 2))
end

function revhor(d)
  view(d, 1:size(d, 1), size(d, 2):-1:1)
end

function rotclockw(d)  # there actually extists rotr90
  d = permutedims(d)
  d = reverse(d, dims=2)
  return d
end

###

data = String(read("14.in"))
ex = String(read("14.ex"))

function test()
  @assert part1(data) == 41859
  #@assert part2(data) == 30842
end