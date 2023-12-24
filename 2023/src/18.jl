dirdict = Dict('L' => (-1, 0), 'U' => (0, 1), 'D' => (0, -1), 'R' => (1, 0))
dirdict2 = Dict('2' => (-1, 0), '3' => (0, 1), '1' => (0, -1), '0' => (1, 0))

function parseinput(lines)
    map(lines) do l
        d, l, h = split(l)
        dirdict[d[1]], parse(Int, l)
    end
end

function parseinput2(lines)
    map(lines) do l
        _, _, h = split(l)
        dirdict2[h[end-1]], parse(Int, h[3:end-2], base=16)
    end
end

function part1(lines, parser=parseinput)
    instr = parser(lines)
    x = 0
    y = 0
    a = 0
    totlen = 0
    for (dir, len) in instr
        dx, dy = dir .* len
        x, y = (x, y) .+ (dx, dy)
        a += dx * y
        totlen += len
    end
    a = abs(a) + div(totlen, 2) + 1
    return a, xy
end

part2(lines) = part1(lines, parseinput2)

###

function test()
    @assert part1(ex) == 62
end

data = readlines("18.in")

ex = split("""R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)""", "\n")

function plot(xy)
    x = Int[]
    y = Int[]
    for xy in xy
        x = [x; xy[1]]
        y = [y; xy[2]]
    end
    x = x .- minimum(x) .+ 1
    y = y .- minimum(y) .+ 1
    v = ones(Bool, @show(length(x)))
    sparse(y, x, v)
end