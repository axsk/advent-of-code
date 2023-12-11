using IterTools
using Lazy: @>>
using Chain

data = readlines("data/day10.txt")
parseinput(lines) = permutedims(reduce(hcat, collect.(lines)))

N = [-1, 0]
W = [0, -1]
S = [1, 0]
E = [0, 1]

dirs = Dict('|' => (N, S), '-' => (W, E), 'L' => (N, E), 'J' => (N, W), '7' => (S, W), 'F' => (S, E), 'S' => (N, S, W, E))

function solve(lines)
  g = parseinput(lines)
  grid = fill('.', (size(g) .+ [2, 2])...)
  grid[2:end-1, 2:end-1] .= g
  start = collect(Tuple(findfirst(grid .== 'S')))
  last = pos = start
  steps = 0
  area = 0
  while true
    next = takemove(grid, pos, last)
    last = pos
    pos = next

    # shoelace
    dy = last[1] + pos[1]
    dx = pos[2] - last[2]
    area += 1 / 2 * (dx) * (dy)

    steps += 1
    pos == start && break
  end
  @show area
  steps / 2, abs(area) - steps / 2 + 1
end

function takemove(grid, pos, last)
  dir = dirs[grid[pos...]]
  for d in dir
    n = (pos .+ d)
    if n != last && grid[n...] != '.'
      return n
    end
  end
end

sample1 = split(".....
.S-7.
.|.|.
.L-J.
.....", "\n")

sample2 = split("...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........", "\n")

sample3 = split(".F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...", "\n")

sample4 = split("FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L", "\n")

function test()
  @show part1(sample1)[2] == 1
  @show part1(sample2)[2] == 4
  @show part1(sample3)[2] == 8
  @show part1(sample4)[2] == 10
end

#=
    | is a vertical pipe connecting north and south.
    - is a horizontal pipe connecting east and west.
    L is a 90-degree bend connecting north and east.
    J is a 90-degree bend connecting north and west.
    7 is a 90-degree bend connecting south and west.
    F is a 90-degree bend connecting south and east.
    . is ground; there is no pipe in this tile.
    S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
=#