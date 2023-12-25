using Graphs
using Graphs.SimpleGraphs: SimpleEdge
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
    return SimpleGraphFromIterator(edges), nodes
end

function part1(data=data)
    g, nodes = parseinput(data)
    #cut, _ = mincut(g)
    while true
        cut = karger_min_cut(g)
        length(karger_cut_edges(g, cut)) == 3 && break
    end
    count(==(1), cut) * count(==(2), cut)
end

# seemingly mincut() is broken
function test_mincut()
    g, nodes = parseinput(readlines("25.in"))
    while true
        cut = karger_min_cut(g)
        length(karger_cut_edges(g, cut)) == 3 && break
    end

    cut2, _ = mincut(g)
    @show cut == cut2
    @show length.(karger_cut_edges.(Ref(g), [cut, cut2]))
end

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