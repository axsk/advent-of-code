function part1(input=readlines("day8.in"))
    xs=[parse.(Int,split(l,",")) for l in input]
    dists = [sum(abs2,x-y) for x in xs, y in xs]
    dists[diagind(dists)] .= Inf
    cs = Set{Int}[]
    count = 0
    while true
        i,j = Tuple(argmin(dists))
        dists[i, j] = dists[j, i] = Inf
        found = findall([i in s || j in s for s in cs])
        s = union(cs[found]..., Set([i,j]))
        deleteat!(cs, found)
        push!(cs, s)
        count += 1
        if count == 1000
            @show prod(sort(length.(cs), rev=true)[1:3])
        end
        
        if length(cs[1]) == length(xs)
            @show xs[i][1] * xs[j][1]
            break
        end
    end
end