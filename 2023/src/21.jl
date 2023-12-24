# part1: 19 mins, part2: many hours
# this file is in a horrible state

const CI = CartesianIndex
using SparseArrays
using Graphs

const LIMIT = 26501365

ex = split("...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........", "\n")

free = split("...
.S.
...")

data = readlines("21.in")

function parseinput(lines)
  garden = permutedims(stack(lines))
  s = findall(x -> x == 'S', garden)[1]
  garden[s] = '.'
  return garden, s
end

function graph(garden)
  A = spzeros(Bool, length(garden), length(garden))
  for i in CartesianIndices(garden)
    for j in (CI(0, 1), CI(0, -1), CI(1, 0), CI(-1, 0))
      if i + j in CartesianIndices(garden)
        if garden[i] == '.' && garden[i+j] == '.'
          A[LinearIndices(garden)[i], LinearIndices(garden)[i+j]] = true
        end
      end
    end
  end
  SimpleGraph(A)
end

function part1(lines, limit=64)
  garden, s = parseinput(lines)
  g = graph(garden)
  s = LinearIndices(garden)[s]
  d = dijkstra_shortest_paths(g, s)
  filter(d.dists) do d
    d <= limit && d % 2 == (iseven(limit) ? 0 : 1)
  end |> length
end

tolinindex(ind, matrix) = LinearIndices(matrix)[ind]

function part2(lines=data, limit=LIMIT)
  global garden, s = parseinput(lines)
  global g = graph(garden)
  #d = dijkstra_shortest_paths(g, tolinindex(s, garden))
  global e = edgedists(garden, g)
  part1(lines, limit) + countcells(e, limit)
end

function edgedists(garden, g=graph(garden))
  edges = zeros(Int, 4, size(garden)...)
  mid = div(size(garden, 1) + 1, 2)
  len = size(garden, 1)
  for (i, ind) in enumerate([CI(1, mid), CI(mid, 1), CI(len, mid), CI(mid, len)])
    d = dijkstra_shortest_paths(g, tolinindex(ind, garden))
    edges[i, :, :] = d.dists
  end
  edges .+ 1
end

function countcells(e, limit=LIMIT)
  l = size(e, 2)
  halflength = div(l - 1, 2)
  # x>=0, y>0
  # (x+y-1) * 131 + 65 + d <= limit
  # (x+y-1) <= (limit - 65 - d) / 131
  #
  global xy = floor.(Int, (limit .- (halflength .+ e)) / l .+ 1)
  xy[xy.<0] .= 0  # remove unreachable points
  #n = div.(xy .^ 2 .+ xy, 2) # number of xy combinations - gauss
  n = 0
  for i in eachindex(xy)
    if iseven(e[i]) == iseven(limit)
      n += sum(2:2:xy[i])
    else
      n += sum(1:2:xy[i])
    end
  end
  n
end

function test()
  @assert part1(ex, 6) == 16
  @assert part1(data, 64) == 3841
  @assert part2() > 636389813576406
  @assert part2() > 636389856464006
  @assert part2() > 636389856463944
end


reshapesquare(d) = reshape(d, Int(sqrt(length(d))), Int(sqrt(length(d))))

#interior = 183 + 215 + 169 + 223 - 3
#outside = 198 + 214 + 188 + 218
#blocksum = interior + outside
# check for off by one error
# 202300


function divideinds()
  inds = LinearIndices((1:131, 1:131))
  inner = Int[]
  outer = Int[]

  for i in 1:131, j in 1:131
    if abs(i - 66) + abs(j - 66) <= 65
      push!(inner, inds[i, j])
    else
      push!(outer, inds[i, j])
    end
  end
  @assert length(inner) + length(outer) == length(inds)
  sort(inner), sort(outer)
end

part2() = part2(parseinput(data)...)

function test2()
  garden, s = parseinput(data)
  garden .= '.'
  @show sol = part2(garden, s)
  @show tst = 2 * (LIMIT^2 + LIMIT) ÷ 2 + 2 * (LIMIT + 1) ÷ 2
  @show tst-sol
  @assert sol == tst
end

function part2(garden, s)
  #garden, s = parseinput(data)
  d = dijkstra_shortest_paths(graph(garden), tolinindex(s, garden))
  D = reshape(d.dists, 131, 131)

  reps = (LIMIT - 65) ÷ 131

  innr, outr = divideinds()

  blockb = filter(D) do d
    d % 2 == 1 && d < 10000
  end |> length

  blockw = filter(D) do d
    d % 2 == 0 && d < 10000
  end |> length

  outsideb = filter(D[outr]) do d
    d % 2 == 1 && d < 10000
  end |> length

  triangleb = ((reps ÷ 2)^2 + (reps ÷ 2)) ÷ 2 * 2
  trianglew = triangleb - reps ÷ 2

  @assert triangleb + trianglew == (reps^2 + reps) ÷ 2

  4 * (triangleb * blockb + trianglew * blockw) - (reps + 1) * outsideb + blockb
end



#= half baked stuff that never got there
# i still think i found a unique solution where i split the area into 4 triangles
# for each of them i can compute the straight reachables via modulo and the midpoint connections.
# the symmetry came in nicely as well as by computing the dists to all 4 "connecting points" 
# one solved all 4 trinagles computing only on one.
# i also implemented (and apparently lost it)...
# the answers where wrong because for the non-straight fields i needed to use the diagonal connections...

# however, i don't even know what the rest below here is about

function extend(garden, s, times=3)
  news = CartesianIndices(garden)[s] .+ div(times - 1, 2) * CI(size(garden)...)
  newgarden = repeat(garden, outer=(times, times))
  news = LinearIndices(newgarden)[news]
  newgarden, news
end

function countdown(garden, s)
  bs = size(garden)
  newgarden, ns = extend(garden, s)
  d = dijkstra_shortest_paths(graph(newgarden), ns)
  centerblock = CI(bs[1] .+ (1:bs[1]), bs[2] .+ (1:bs[2]))
  downblock = CI(2 * bs[1] .+ (1:bs[1]), bs[2] .+ (1:bs[2]))
  cb = d.dists[LinearIndices(newgarden)[centerblock...]]
  db = d.dists[LinearIndices(newgarden)[downblock...]]

  delta = db .- cb[end:end, :]

  fields = 0
  limit = 1_000_000
  lastrow = cb[end, :]
  for i in 1:11, j in 1:11
    #cost = cb[end, j] + delta[end, j] * repetitions + delta[i, j]
    reps = fld(limit - delta[i, j] - lastrow, delta[end, j])
    ## TODO ACCOUNT FOR UNEVEN STEPS
    fields += reps
  end
  fields += reps
end


fixbig!(x) = x[x.>10*LIMIT] .= -1

function loopy(garden, s, limit=LIMIT)
  bs = size(garden)
  ng, ns = extend(garden, s)
  d = dijkstra_shortest_paths(graph(ng), ns)
  dists = reshape(d.dists, size(ng)...)
  dists = BlockArray(dists, [bs[1], bs[1], bs[1]], [bs[2], bs[2], bs[2]])

  vis = 0
  for i in 1:bs[1], j in 1:bs[2]
    start = dists[Block(2, 2)][i, j]
    deltai = dists[Block(3, 2)][end, j] - dists[Block(2, 2)][end, j]


    curr = start
    while curr <= limit
      if curr % 2 == 0
        vis += 1
      end
      curr += deltai
    end
    #start +=
  end

end

=#