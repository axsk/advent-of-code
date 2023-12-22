
data = readlines("22.in")

ex = split("1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9")


function parseinput(lines)
    bricks = Dict{Int,typeof(((1:1), (2:2), (2:3)))}()
    for (i, line) in enumerate(lines)
        nums = parse.(Int, split(line, [',', '~']))
        rngs = nums[1]:nums[4], nums[2]:nums[5], nums[3]:nums[6]
        bricks[i] = rngs
        #push!(bricks, nums[3], rngs)
    end
    return bricks
end


function part1(data=data)
    bricks = parseinput(data)
    bf = letfall(bricks)
    savetodisintegrate(bf) |> length
end

function test()
    @assert part1(ex) == 5
    @assert part1(data) < 507
    @assert part2(ex) == 7
    @assert part2(data) > 46232
    @assert part2(data) == 79042
end

function abovedict(brick, bricks; offset=1)
    bs = Int[]
    for (k, b) in bricks
        b == brick && continue
        if !isempty(intersect(brick[3] .+ offset, b[3]))
            if xyoverlap(brick, b)
                push!(bs, k)
            end
        end
    end
    return bs
end

belowdict(brick, bricks) = abovedict(brick, bricks; offset=-1)
xyoverlap(b1, b2) = prod(length.(intersect.(b1[1:2], b2[1:2]))) > 0

function letfall(bricks)
    bricks = copy(bricks)
    zs = zindex(bricks)
    for bs in zs
        for k in bs
            b = bricks[k]
            while isempty(belowdict(b, bricks)) && b[3][1] > 1
                b = (b[1], b[2], b[3] .- 1)
                bricks[k] = b  # had this below the while loop at first, led to self intersections
            end
        end
    end
    return bricks
end

function issupporting(brick, bricks)
    above = abovedict(brick, bricks)
    for b in above
        if length(belowdict(bricks[b], bricks)) == 1
            return true
        end
    end
    return false
end

function howmanysupporting(brick, bricks)
    @show above = abovedict(brick, bricks)
    count = 0
    for b in above
        if length(belowdict(bricks[b], bricks)) == 1
            count += 1
        end
    end
    count
end

function whichfall(brick, bricks)
    above = abovedict(brick, bricks)
    fallen = []
    for b in above
        if length(belowdict(bricks[b], bricks)) == 0
            push!(fallen, pop!(bricks, b))
        end
    end
    fallen = vcat(fallen, whichfall.(fallen, Ref(bricks))...)
    return fallen
end

function whichfall(id::Int, bricks)
    bricks = copy(bricks)
    brick = pop!(bricks, id)
    whichfall(brick, bricks)
end


# 46232

function part2(data=data)
    bricks = parseinput(data)
    bf = letfall(bricks)
    s = 0
    for (k, v) in bf
        s += length(whichfall(k, bf))
    end
    return s
end

function savetodisintegrate(bricks)
    filter(bricks) do (k, v)
        !issupporting(v, bricks)
    end
end




function zindex(bricks)
    maxz = maximum(v[3][end] for (k, v) in bricks)
    zs = [Int[] for i in 1:maxz]
    for (k, v) in bricks
        for z in v[3]
            push!(zs[z], k)
        end
    end
    return zs
end

function letfall(bricks)
    zs = zindex(bricks)
    zsn = [Int[] for i in 1:length(zs)]
    for i in 1:length(zs)
        for b in zs[i]
        end
    end
end

# TODO: note zabove depends on static brick dict coordinate

function above(brick, z, bricks, zs)
    zabove = z + 1
    zabove > length(zs) && return []
    aboves = Int[]
    for b in zs[zabove]
        if prod(length.(intersect(bricks[b][1:2], brick[1:2]))) > 0
            push!(aboves, b)
        end
    end
    aboves
end

function below(brick, bricks, zs)
    zbelow = zmin(brick) - 1
    zbelow < 1 && return []
    bs = Int[]
    for b in zs[zabove]
        if prod(length.(intersect(bricks[b][1:2], brick[1:2]))) > 0
            push!(bs, b)
        end
    end
    bs
end


zmin(brick) = brick[3][1]
zmax(brick) = brick[3][end]
