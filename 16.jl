# part 1 40mins; part 2 12 mins
const CI = CartesianIndex
parseinput(lines) = permutedims(stack(lines))

function energize(grid::Matrix, (pos, dir), energized=zeros(Bool, (size(grid)..., 4)))
  valid = CartesianIndices(grid)
  while true
    pos in valid || break
    d = dir == CI(0, 1) ? 1 : # didn't find a faster way to look this up
        dir == CI(0, -1) ? 2 :
        dir == CI(1, 0) ? 3 : 4
    energized[pos, d] && break
    energized[pos, d] = true

    tile = grid[pos]
    if tile == '/'
      dir = CI(-dir[2], -dir[1])
    elseif tile == '\\'
      dir = CI(dir[2], dir[1])
    elseif tile == '|' && dir[1] == 0
      dir = CI(1, 0)
      energize(grid, (pos - dir, -dir), energized)
    elseif tile == '-' && dir[2] == 0
      dir = CI(0, 1)
      energize(grid, (pos - dir, -dir), energized)
    end

    pos += dir
  end
  energized
end

# 80us
part1(input) = part1(parseinput(input))
part1(grid::Matrix, start=(CI(1, 1), CI(0, 1))) = sum(reduce(|, energize(grid, start), dims=3))

using Folds
# 13ms / 22ms
part2(input=data) = part2(parseinput(input))
function part2(grid::Matrix; threaded=true, maximum=threaded ? Folds.maximum : Base.maximum)
  xs = CartesianIndices(grid)
  ds = [CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)]
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