# implents the stone wagner min-cut algorithm

using Graphs: SimpleGraphFromIterator, SimpleEdge
using SimpleWeightedGraphs: SimpleWeightedGraph
using SparseArrays

function mincut(A)
    A = copy(A)
    best = (typemax(Int), Int[])
    n = size(A, 1)
    co = [[i] for i in 1:n]
    for ph = 1:n-1
        w = collect(@view A[:, 1])
        s = t = 1
        for _ = 1:n-ph
            w[t] = typemin(Int)
            s = t
            t = argmax(w)  # prioqueue would speed this up
            for i in nzrange(A, t)
                w[rowvals(A)[i]] += nonzeros(A)[i]
            end
        end
        best = min(best, (w[t] - A[t, t], co[t]))
        append!(co[s], co[t])
        A[:, s] .+= A[:, t]
        A[s, :] .= A[:, s]
        A[t, 1] = typemin(Int)
    end
    return best
end

###

data = readlines("25.in")

function parseinput(lines)
    nodes = Dict()
    edges = SimpleEdge[]
    for l in lines
        ns = split(l)
        i = get!(nodes, ns[1][1:end-1], length(nodes) + 1)
        for n in ns[2:end]
            j = get!(nodes, n, length(nodes) + 1)
            push!(edges, SimpleEdge(i, j))
            push!(edges, SimpleEdge(j, i))
        end
    end
    g = SimpleGraphFromIterator(edges)
    g = SimpleWeightedGraph(g)
    Int.(g.weights)
end

function part1(data=data)
    g = parseinput(data)
    c, part = mincut(g)
    a, b = length(part), size(g, 1) - length(part)
    a * b
end

###

function test()
    @assert part1(ex) == 54
    @assert part1(data) == 546804
end

ex = split("jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr", '\n')