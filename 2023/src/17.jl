# https://adventofcode.com/2023/day/17
# part1 40mins, part2 2mins

using Graphs
using SimpleWeightedGraphs

parseinput(lines) = permutedims(parse.(Int, stack(lines)))

const CI = CartesianIndex
const directions = [CI(-1, 0), CI(0, -1), CI(1, 0), CI(0, 1)]
neighbors(i) = i % 2 == 0 ? (1, 3) : (2, 4)

function solve(grid, ispart2=false)
  srcs = CI{3}[]
  dsts = CI{3}[]
  weights = Int[]
  for (layer, direction) in enumerate(directions)
    for src in CartesianIndices(grid)
      cost = 0
      for steps in (ispart2 ? (1:10) : (1:3))
        dst = src + steps * direction
        dst in CartesianIndices(grid) || break
        cost += grid[dst]
        ispart2 && steps < 4 && continue
        for neigh in neighbors(layer)
          push!(srcs, CI(src, layer))
          push!(dsts, CI(dst, neigh))
          push!(weights, cost)
        end
      end
    end
  end

  lin = LinearIndices((1:size(grid, 1), 1:size(grid, 2), 1:4))
  g = SimpleWeightedDiGraph(lin[srcs], lin[dsts], weights)

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