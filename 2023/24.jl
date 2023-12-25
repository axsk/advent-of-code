using Chain

function parseinput(lines)
    map(lines) do l
        @chain begin
            l
            split(_, [',', ' ', '@'])
            filter(!isempty, _)
            parse.(Int, _)
            Tuple
        end
    end
end

data = parseinput(eachline("24.in"))

function xycollision(p1, p2)
    x1, y1 = p1[1:2]
    dx1, dy1 = p1[4:5]
    x2, y2 = p2[1:2]
    dx2, dy2 = p2[4:5]
    a = dy1 / dx1
    b = dy2 / dx2
    c = y1 - x1 * a
    d = y2 - x2 * b
    x = (d - c) / (a - b)
    y = a * x + c
    t1 = (x - x1) / dx1
    t2 = (x - x2) / dx2
    return x, y, t1, t2
end

function xzcollision(p1, p2)
    xycollision(p1[[1, 3, 3, 4, 6, 6]], p2[[1, 3, 3, 4, 6, 6]])
end

function missmatch(ray, p)

end

bnd = (200000000000000, 400000000000000)

function part1(data; bnd=bnd)
    xmin, xmax = bnd
    coll = 0
    for i in 1:length(data), j in i+1:length(data)
        x, y, t1, t2 = xycollision(data[i], data[j])
        if xmin < x < xmax && xmin < y < xmax && (t1 > 0 && t2 > 0)
            #@show i, j, x, y
            coll += 1
        end
    end
    return coll
end

using LinearAlgebra  # !
function beauty(data)  # kudos to Zentrik
    # (x - x₀) × (v - v₀) = 0  -- from the stones frame the velocity is parallel to the position
    x1, y1 = data[1] |> collect |> x -> (x[1:3], x[4:6])
    x2, y2 = data[2] |> collect |> x -> (x[1:3], x[4:6])
    x3, y3 = data[3] |> collect |> x -> (x[1:3], x[4:6])

    skew(x) = [0 -x[3] x[2]; x[3] 0 -x[1]; -x[2] x[1] 0]

    A = [skew(y1 - y2) skew(x2 - x1)
        skew(y1 - y3) skew(x3 - x1)]

    rhs = [x2 × y2 - x1 × y1
        x3 × y3 - x1 × y1]

    round.(Int, A \ rhs)
end

part2(data=data) = round.(Int128, beauty(data)[1:3]) |> sum
###


ex = parseinput(split("19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3", "\n"))

function test()
    @assert part1(data) == 14799
    @assert part2(data) == 1007148211789625
end

#= 
function zoft(t, hails)
    @show p1, p2, p3 = hails[1:3]
    @show p1 = prop(p1, t)
    @show p2 = prop(p2, t)
    con = (p1..., p2 .- p1...)
    _, _, tc, t3 = xycollision(con, p3)
    tc + t - t3
end
function part2(data)

    xv = startpos(myopt(data)..., data)
    sum(xv[1:3])
end

# propagate particle
prop(p, t) = p[1:3] .+ p[4:6] .* t

function z2(t1, t2, hails)
    s1, s2, s3 = hails[1:3]
    p1 = prop(s1, t1)
    p2 = prop(s2, t2)
    hit = (p1..., ((p2 .- p1) ./ (t2 - t1))...)
    _, _, th, t3 = xycollision(hit, s3)
    prop(s3, t3)[3] - prop(hit, th)[3]
end

function startpos(t1, t2, hails)
    s1, s2, s3 = hails[1:3]
    p1 = prop(s1, t1)
    p2 = prop(s2, t2)
    v = ((p2 .- p1) ./ (t2 - t1))
    con = (p1..., ((p2 .- p1) ./ (t2 - t1))...)
    round.(Int, (prop(con, -t1)..., v...))
end

using Optim
function myopt(data, n=10)
    obj(x) =
        sum(1:n) do i
            abs2(z2(x..., data[[1, 2, i]]))
        end

    # found with previous NelderMead runs
    x0 = [8.463371279179995e11, 9.814210672239995e11]

    @show sol = optimize(obj, rand(2) .* x0,
        NelderMead(),
        Optim.Options(iterations=10000, g_tol=1e-15))

    @show sol.minimizer
end

using Plots

function visline(line::Tuple, len=100; kwargs...)
    (x, y, z, u, v, w) = line
    len = 243519011458151
    len = 1000000000000
    plot!([x, x + u * len], [y, y + v * len], [z, z + w * len]; kwargs...)
    len = len * 100
    plot!([x, x + u * len], [y, y + v * len], [z, z + w * len], linealpha=0.7; kwargs...)

end

function visline(data; kwargs...)
    plot()
    lim = (0, 945371405950118)
    foreach(x -> visline(x; kwargs...), data)
    plot!(xlims=lim, ylims=lim, zlims=lim, legend=false,
        grid=false, axis=false; kwargs...)

end

=#
