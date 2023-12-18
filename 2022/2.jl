function linescore(line)
    op = line[1] - 'A' + 1
    me = line[3] - 'X' + 1
    delta = mod1(me - op, 3)
    delta == 0 && return me + 3
    delta == 1 && return me + 6
    return me
end

function linescore2(line)
    op = line[1] - 'A' + 1
    delta = line[3] - 'Y'
    @show me = mod1(delta + op, 3)
    delta == 0 && return me + 3
    delta == 1 && return me + 6
    return me
end

part1(lines) = sum(linescore.(lines))
part2(lines) = sum(linescore2.(lines))