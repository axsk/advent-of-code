# part 1 40; part 2 12

parseinput(lines) = permutedims(stack(lines))

const CI = CartesianIndex
const lookup = Dict(zip([CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)], 1:4))

function step(pos, dir, grid)
  tile = grid[pos]
  if tile == '/'
    dir = CI(-dir[2], -dir[1])
    return ((pos + dir, dir),)
  elseif tile == '\\'
    dir = CI(dir[2], dir[1])
    return ((pos + dir, dir),)
  elseif tile == '|' && dir[1] == 0
    return ((pos + dir, dir) for dir in [CI(1, 0), CI(-1, 0)])
  elseif tile == '-' && dir[2] == 0
    return ((pos + dir, dir) for dir in [CI(0, 1), CI(0, -1)])
  else
    return ((pos + dir, dir),)
  end
end

part1(input) = part1(parseinput(input))

function part1(grid::Matrix, start=(CI(1, 1), CI(0, 1)))
  energized = zeros(Bool, (size(grid)..., 4))
  queue = [start]
  while !isempty(queue)
    pos, dir = pop!(queue)
    !(pos in CartesianIndices(grid)) && continue
    d = lookup[dir]
    energized[pos, d] && continue
    energized[pos, d] = true
    append!(queue, step(pos, dir, grid))
  end
  sum(reduce(|, energized, dims=3))
end

function part2(input)
  grid = parseinput(input)
  l = size(grid, 1)
  starts = Iterators.flatten((
    (CI(i, 1), CI(0, 1)),
    (CI(i, l), CI(0, -1)),
    (CI(1, i), CI(1, 0)),
    (CI(l, i), CI(-1, 0))
  ) for i in 1:l)
  maximum(x -> part1(grid, x), starts)
end

data = readlines("16.in")
ex = split(raw""".|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....""")

function test()
  @assert part1(ex) == 46
  @assert part1(data) == 6605

  @assert part2(ex) == 51
  @assert part2(data) == 6766
end

function vis(walked, grid)
  x = copy(grid)
  x[[s[1] for s in walked]] .= '#'
  display(x)
end