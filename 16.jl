# part 1 40; part 2 12

parseinput(lines) = permutedims(stack(lines))

const CI = CartesianIndex
const directions = Dict(zip([CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)], 1:4))

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

part1(input=data) = part1(parseinput(input))

function part1old(grid::Matrix, start=(CI(1, 1), CI(0, 1)))
  energized = zeros(Bool, (size(grid)..., 4))
  queue = [start]
  while !isempty(queue)
    pos, dir = pop!(queue)
    !(pos in CartesianIndices(grid)) && continue
    d = directions[dir]
    energized[pos, d] && continue
    energized[pos, d] = true
    append!(queue, step(pos, dir, grid))
  end
  sum(reduce(|, energized, dims=3))
end

dirlookup(dir) = dir == CI(0, 1) ? 4 : # didn't find a faster way to look this up
                 dir == CI(0, -1) ? 3 :
                 dir == CI(1, 0) ? 1 :
                 dir == CI(-1, 0) ? 2 : error()

function part1fast(grid::Matrix, start=(CI(1, 1), CI(0, 1)))
  energized = zeros(Bool, (size(grid)..., 4))
  queue = [start]
  valid = CartesianIndices(grid)
  while !isempty(queue)
    pos, dir = pop!(queue)

    while true
      pos in valid || break
      d = dirlookup(dir)
      energized[pos, d] && break
      energized[pos, d] = true

      tile = grid[pos]
      if tile == '/'
        dir = CI(-dir[2], -dir[1])
      elseif tile == '\\'
        dir = CI(dir[2], dir[1])
      elseif tile == '|' && dir[1] == 0
        dir = CI(1, 0)
        push!(queue, (pos - dir, -dir))
      elseif tile == '-' && dir[2] == 0
        dir = CI(0, 1)
        push!(queue, (pos - dir, -dir))
      end

      pos += dir
    end
  end
  sum(reduce(|, energized, dims=3))
end

part2(input=data) = part2(parseinput(input))
function part2(grid::Matrix)
  xs = CartesianIndices(grid)
  ds = keys(directions)
  starts = ((x, d) for x in xs for d in ds if !(x - d in xs))
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