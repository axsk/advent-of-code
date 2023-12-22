data = readchomp("5.in")
# 15 min + 2 min
function parseinput(data=data)
    a, b = split(data, "\n\n")
    stacks = map(eachcol(permutedims(stack(split(a, '\n'))[2:4:end, 1:8]))) do col
        reverse(filter(!=(' '), col))
    end

    rules = map(split(b, "\n")) do l
        map(eachmatch(r"\d+", l)) do m
            parse(Int, m.match)
        end
    end
    stacks, rules
end

function part1(data)
    stacks, rules = parseinput(data)
    for (n, fr, to) in rules
        for _ in 1:n
            push!(stacks[to], pop!(stacks[fr]))
        end
    end
    join(last.(stacks))
end


function part2(data)
    stacks, rules = parseinput(data)
    for (n, fr, to) in rules
        append!(stacks[to], stacks[fr][end-n+1:end])
        stacks[fr] = stacks[fr][1:end-n]
    end
    join(last.(stacks))
end