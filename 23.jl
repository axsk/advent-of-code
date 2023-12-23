data = stack(readlines("23.in"))
ex = stack(readlines("23.ex"))

const CI = CartesianIndex
const arrows = ('>', '<', 'v', '^')
const directions = [CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1)]

part1(data=data) = walk(data)

function walk(lab)
    start, finish = startend(lab)
    step = CI(0, 1)
    pos = start
    paths = [(step, Set([start]), start)]
    maxlengths = Int[]
    for i in 1:1_00000
        newpaths = empty(paths)
        while !isempty(paths)
            (step, seen, pos) = pop!(paths)
            #allowed = collect(allowedsteps(step, pos, lab))
            for s in allowedsteps(step, pos, lab)
                npos = pos + s
                npos in seen && continue
                if npos == finish
                    push!(maxlengths, i)
                end
                nseen = push!(copy(seen), npos)
                push!(newpaths, (s, nseen, npos))
            end
        end
        paths = newpaths
        isempty(paths) && break
    end
    isempty(maxlengths) && return nothing
    return maximum(maxlengths)
end

function allowedsteps(oldstep, pos, lab, part1=true)
    function isvalid(s)
        #s == -oldstep && return false
        if part1
            field = lab[pos]
            field == 'v' && s != CI(0, 1) && return false
            field == '^' && s != CI(0, -1) && return false
            field == '<' && s != CI(-1, 0) && return false
            field == '>' && s != CI(1, 0) && return false
        end
        npos = pos + s
        npos in CartesianIndices(lab) || return false
        lab[npos] == '#' && return false
        lab[pos] == '#' && return false
        return true
    end
    [s for s in directions if isvalid(s)]
end

# TODO: clean up
function mygraph(lab, part1=false)
    cis = CartesianIndices(lab)
    lis = LinearIndices(lab)
    edges = Dict{Int,Vector{Int}}()
    for i in eachindex(lab)
        ci = cis[i]
        as = allowedsteps(nothing, ci, lab, part1)
        isempty(as) && continue
        edges[i] = [lis[ci+s] for s in as]
    end
    A = zeros(Int, size(lab) .^ 2)
    for (k, v) in edges
        A[k, v] .= 1
    end
    #=for (node, links) in edges
        if length(links) == 2
            l1, l2 = links
            replace!(edges[l1], node => l2)
            replace!(edges[l2], node => l1)
            delete!(edges, node)
            A[l1, l2] = A[l2, l1] = A[node, l1] + A[node, l2]
        end
    end
    =#
    #return edges
    k = collect(keys(edges))
    A = A[k, :][:, k]
    conns = Vector{Int}[]
    weights = Vector{Int}[]
    for i in 1:size(A, 1)
        s = findall(A[:, i] .> 0)
        push!(conns, s)
        push!(weights, A[s, i])
    end
    conns, weights

end

function trav((ns, ws)=mygraph(ex))
    start, finish = findall(length.(ns) .== 1)
    hist = fill(start, length(ns))
    trav(hist, 1, 0, ns, ws, finish)
end

function trav(hist, steps, len, ns, ws, finish)
    pos = hist[steps]
    pos == finish && return len
    m = 0
    @inbounds @views for j in 1:length(ns[pos])
        n = ns[pos][j]
        n in hist[1:steps] && continue
        w = ws[pos][j]
        hist[steps+1] = n
        t = trav(hist, steps + 1, len + w, ns, ws, finish)
        t > m && (m = t)
    end
    return m
end

part2(data) = trav(mygraph(data, false))

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

shiftval(val::Int, shift) = shift[val]
shiftval((n, w), shift) = (shift[n], w)

function shiftinds(neighs)
    shift = Dict(zip(keys(neighs), 1:length(neighs)))
    new = empty(neighs)
    for (k, v) in neighs
        new[shift[k]] = shiftval.(v, Ref(shift))
    end
    new
end


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
    return shiftinds(weightedgraph)
end

nodeweight(n::Int) = n, 1
nodeweight((n, w)) = n, w

# 1 min to find sol,  much longer to finish
function trav2(ns)
    start, finish = [k for (k, v) in ns if length(v) == 1]
    @show start, finish
    visited = zeros(maximum(keys(ns)))
    maxlen = 0
    function travrec(pos, len)
        pos == finish && return len
        for n in ns[pos]
            n, w = nodeweight(n)
            visited[n] == 1 && continue
            visited[n] = 1
            t = travrec(n, len + w)
            t > maxlen && (@show maxlen = t)
            visited[n] = 0
        end
        return 0
    end
    travrec(start, 0)
    return maxlen
end

function test()
    @assert part1(ex) == 94
    @assert part1(data) == 2094
    @assert part2(ex) == 154
    @assert part2(data) == 6442
end