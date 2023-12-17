# https://adventofcode.com/2023/day/17
# part1 40mins, part2 2mins

using Graphs
using SimpleWeightedGraphs

parseinput(lines) = permutedims(parse.(Int, stack(lines)))

const CI = CartesianIndex
const directions = [CI(-1, 0), CI(0, -1), CI(1, 0), CI(0, 1)]

function solve(grid, part2=false)
  srcs = CartesianIndex{3}[]
  dest = CartesianIndex{3}[]
  weights = Int[]

  for (i, dir) in enumerate(directions)
    for a in CartesianIndices(grid)
      for lr in [1, -1]
        c = 0
        for d in (part2 ? (1:10) : (1:3))
          target = a + d * dir
          target in CartesianIndices(grid) || break
          c += grid[target]
          part2 && d < 4 && continue
          push!(srcs, CI(a, i))
          push!(dest, CI(target, (i + lr + 3) % 4 + 1))
          push!(weights, c)
        end
      end
    end
  end

  lin = LinearIndices((1:size(grid, 1), 1:size(grid, 2), 1:4))
  srcs = lin[srcs]
  dest = lin[dest]
  g = SimpleWeightedDiGraph(srcs, dest, weights)

  start = lin[1, 1, 1:4]
  finish = lin[end, end, 1:4]

  ds = dijkstra_shortest_paths(g, start)
  return minimum(ds.dists[finish])
end

part1(input) = solve(parseinput(input))
part2(input) = solve(parseinput(input), true)

###

function test()
  @assert part1(data) == 953
  @assert part2(data) == 1180
end

data = readlines("17.in")
ex = split("2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533")