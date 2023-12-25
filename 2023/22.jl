function parseinput(lines)
    bricks = typeof(((1:1), (2:2), (2:3)))[]
    for line in lines
        nums = parse.(Int, split(line, [',', '~'])) .+ 1
        rngs = nums[1]:nums[4], nums[2]:nums[5], nums[3]:nums[6]
        push!(bricks, rngs)
    end
    return relations(bricks)
end

function relations(bricks)
    bricks = sort(bricks, by=x -> x[3][1])
    plane = ones(Int, 10, 10)
    ids = zeros(Int, 10, 10)
    below = [Int[] for i in 1:length(bricks)]
    above = [Int[] for i in 1:length(bricks)]
    for (i, b) in enumerate(bricks)
        x, y, z = b
        h = maximum(plane[x, y])
        below[i] = filter(>(0), unique(ids[x, y][plane[x, y].==h]))
        for bel in below[i]
            push!(above[bel], i)
        end
        plane[x, y] .= h + length(z)
        ids[x, y] .= i
    end
    return above, below
end

function safetoremove((above, below))
    critical = Set{Int}()
    for b in below
        length(b) == 1 && push!(critical, b[1])
    end
    length(below) - length(critical)
end

part1(data=data) = safetoremove(parseinput(data))

function howmanyfall(i, (aboves, belows))
    counts = -1
    supports = length.(belows)
    q = [i]
    while !isempty(q)
        counts += 1
        b = pop!(q)
        for i in aboves[b]
            supports[i] -= 1
            supports[i] == 0 && push!(q, i)
        end
    end
    return counts
end

howmanyfall((aboves, belows)) = sum(howmanyfall(i, (aboves, belows)) for i in eachindex(aboves))

part2(data=data) = howmanyfall(parseinput(data))

###

function bothparts(data=data)
    rel = parseinput(data)
    safetoremove(rel), howmanyfall(rel)
end

data = readlines("22.in")
ex = split("1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9")

function test()
    @assert part1(ex) == 5
    @assert part1(data) == 465
    @assert part2(ex) == 7
    @assert part2(data) == 79042
end

function checkconsistent(aboves, belows)
    for i in eachindex(belows)
        if !isempty(belows[i])
            x = vcat(aboves[belows[i]]...)
            if !(i in x)
                @show i
            end
        end
    end
end