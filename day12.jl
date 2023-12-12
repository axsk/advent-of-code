parseinput(s::String) = parseinput(split(s, "\n"))
function parseinput(lines)
    map(lines) do line
        pattern, counts = split(line, " ")
        pattern = pattern
        counts = parse.(Int, split(counts, ","))
        pattern, counts
    end
end

const mem = Dict{Tuple{String,Vector{Int}},Int}()
reset() = delete!.(Ref(mem), keys(mem))
countmm(pattern, counts) =
    get!(mem, (pattern, counts)) do
        countm(pattern, counts)
    end

function countmatches_liner(pattern, counts)
    if length(counts) == 0
        any(==('#'), collect(pattern)) && return 0  # no more counts, but still #
        return 1
    elseif length(pattern) == 0 # not enough pattern left
        return 0
    elseif length(pattern) < length(counts) + sum(counts) - 1  # terminate early if not enough pattern left
        return 0
    end
    len, later = counts[1], counts[2:end]
    c = pattern[1]
    combs = 0

    if c == '#' || c == '?' # we can start here
        if length(pattern) >= len && # have enough space
           !any(==('.'), collect(pattern[1:len])) && # dont cross dots
           (length(pattern) == len || pattern[len+1] != '#') # and dont end before #
            combs += countmm(pattern[len+2:end], later)
        end
    end
    if c == '.' || c == '?' # we can start later
        combs += countmm(pattern[2:end], counts)
    end
    return combs
end

function part1(lines)
    reset()
    sum(parseinput(lines)) do (pattern, counts)
        countmm(pattern, counts)
    end
end

unfold(pattern, counts, n=5) = join((pattern[1:end] for i in 1:n), "?"), repeat(counts, outer=n)

function part2(lines)
    reset()
    sum(parseinput(lines)) do (pattern, counts)
        countmm(unfold(pattern, counts)...)
    end
end

function test()
    @assert part1(sample) == 21
    @assert part1(data) == 7705
    @assert part2(sample) == 525152
    @assert part2(data) == 50338344809230
end

sample = "???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"

data = readlines("data/day12.txt")