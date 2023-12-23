const CI = CartesianIndex
const arrows = ('>', '<', 'v', '^')
const directions = [CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)]

function alloweddirections(c, part1=true)
    c == '#' && return CI[]
    part1 && for (a, d) in zip(arrows, directions)
        c == a && return [d]
    end
    return directions
end

function parseinput(data, part1=true)
    cis = CartesianIndices(data)
    lis = LinearIndices(data)
    neighs = Dict{Int,Vector{Int}}()
    for (i, c) in zip(lis, cis)
        neigh = Int[]
        for d in alloweddirections(data[i], part1)
            nc = c + d
            nc in cis || continue
            data[nc] == '#' && continue
            push!(neigh, lis[nc])
        end
        isempty(neigh) && continue
        neighs[i] = neigh
    end
    return neighs
end

function longestpath(graph)
    start, finish = extrema(keys(graph))  # TODO: this is not valind for part1
    visited = zeros(maximum(keys(graph)))
    maxlen = 0
    function travrec(pos, len)
        pos == finish && return len
        for n in graph[pos]
            n, w = nodeweight(n)
            visited[n] == 1 && continue
            visited[n] = 1
            t = travrec(n, len + w)
            t > maxlen && (maxlen = t)
            visited[n] = 0
        end
        return 0
    end
    @time travrec(start, 0)
    return maxlen
end

nodeweight(n::Int) = n, 1
nodeweight((n, w)) = n, w  # for part 2

part1(data=data) = longestpath(parseinput(data, true))
part2(data=data) = longestpath(contract(parseinput(data, false)))  # 20 secs

function contract(graph)
    checkpoints = [node for (node, neighs) in graph if length(neighs) != 2]
    weightedgraph = Dict()
    for c in checkpoints
        neighs = []
        for head in graph[c]
            prev = c
            w = 1
            while length(graph[head]) == 2
                head, prev = only(setdiff(graph[head], prev)), head
                w += 1
            end
            push!(neighs, (head, w))
        end
        weightedgraph[c] = neighs
    end
    return (weightedgraph)
end

function shiftinds(neighs)
    shift = Dict(zip(collect(sort(keys(neighs))), 1:length(neighs)))  # sort to prevent exits
    new = empty(neighs)
    for (k, v) in neighs
        new[shift[k]] = shiftval.(v, Ref(shift))
    end
    new
end
shiftval(val::Int, shift) = shift[val]
shiftval((n, w), shift) = (shift[n], w)

###

data = stack(readlines("23.in"))
ex = stack(readlines("23.ex"))

using Test
function test()
    @test_broken @show(part1(ex)) == 94
    @test_broken @show(part1(data)) == 2094
    @test @show(part2(ex)) == 154
    @test @show(part2(data)) == 6442
end