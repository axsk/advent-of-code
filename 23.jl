data = stack(readlines("23.in"))
ex = stack(readlines("23.ex"))

function startend(data)
    dots = findall(==('.'), data)
    return dots[1], dots[end]
end

const CI = CartesianIndex
const directions = (CI(1, 0), CI(-1, 0), CI(0, 1), CI(0, -1))


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
        paths = prunepaths(newpaths)
        global debugpaths = paths
        @show i, length(paths)
        isempty(paths) && break
        #@show i, length(paths)
    end
    @show maxlengths
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

part1(data=data) = walk(data)

function test()
    part1(ex) == 94
end

function traverse(lab, part1=false)
    start, finish = startend(lab)
    down = CI(0, 1)
    seen = Dict((start, down) => 0)
    q = [(start, down, [start])]
    maxhist = []
    while !isempty(q)
        (pos, st, hist) = pop!(q)
        while true
            pos += st
            if pos in hist
                break
            end
            push!(hist, pos)
            n = length(hist)
            if get!(seen, (pos, st), 0) > n
                break
            end
            seen[(pos, st)] = n
            if pos == finish
                vis(hist)
                break
            end

            allowed = allowedsteps(st, pos, lab, part1)

            if isempty(allowed)
                break
            end
            st, later = Iterators.peel(allowed)
            append!(q, map(s -> (pos, s, copy(hist)), later))
        end
    end
    @show seen[finish, CI(0, 1)]
    maxhist
end

using SparseArrays
using Plots
function vis(hist, title="")
    x = fill(0, 23, 23)
    x[hist] .= 1
    heatmap(rotl90(x); title) |> display
end

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
    @show sum(length.(values(edges)))
    A = zeros(Int, size(lab) .^ 2)
    for (k, v) in edges
        A[k, v] .= 1
    end
    for (node, links) in edges
        if length(links) == 2
            l1, l2 = links
            replace!(edges[l1], node => l2)
            replace!(edges[l2], node => l1)
            delete!(edges, node)
            A[l1, l2] = A[l2, l1] = A[node, l1] + A[node, l2]
        end
    end
    #return edges
    k = collect(keys(edges))
    A = A[k, :][:, k]
    conns = Vector{Int}[]
    weights = Vector{Int}[]
    for i in 1:size(A, 1)
        @show s = findall(A[:, i] .> 0)
        push!(conns, s)
        push!(weights, A[s, i])
    end
    conns, weights

end

function longestpath((ns, ws)=mygraph(ex))

    start, finish = findall(length.(ns) .== 1)
    hist = zeros(Int, length(ns))
    hist[start] = 1
    q = [(start, hist, 0)]
    maxl = 0
    while !isempty(q)
        pos, hist, len = pop!(q)
        if pos == finish
            maxl = max(len, maxl)
        end
        for (next, w) in zip(ns[pos], ws[pos])
            if hist[next] == 0
                h = copy(hist)
                h[next] = 1
                push!(q, (next, h, len + w))
            end
        end
    end
    maxl
end
