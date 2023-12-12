parseinput(s::String) = parseinput(split(s, "\n"))
function parseinput(lines)
    map(lines) do line
        pattern, counts = split(line, " ")
        pattern = pattern * "."
        counts = parse.(Int, split(counts, ","))
        pattern, counts
    end
end

const mem = Dict{Tuple{String,Vector{Int}},Int}()
reset() = delete!.(Ref(mem), keys(mem))

countmatches_mem(pattern, counts) =
    get!(mem, (pattern, counts)) do
        countmatches(pattern, counts)
    end

function countmatches(pattern, counts)
    reset()
    now, later = counts[1], counts[2:end]
    r = Regex("[#,?]{$(now)}[.?]")
    matches = findall(r, pattern, overlap=true)
    isempty(matches) && return 0
    sum(first.(matches)) do i
        any(==('#'), collect(pattern[1:i-1])) && return 0
        next = pattern[i+now+1:end]
        if isempty(later)
            return !any(==('#'), collect(next))
        end
        return countmatches_mem(next, later)
    end
end

function part1(lines)
    sum(parseinput(lines)) do (pattern, counts)
        countmatches(pattern, counts)
    end
end

function part2(lines)
    sum(parseinput(lines)) do (pattern, counts)
        pattern, counts = unfold(pattern, counts)
        countmatches(pattern, counts)
    end
end

function test()
    @assert part1(sample) == 21
    @assert part1(data) == 7705
    @assert @show(part2(data)) < 93822409359123

end

function unfold(pattern, counts, n=5)
    pattern = join((pattern[1:end-1] for i in 1:n), "?") * "."
    counts = repeat(counts, outer=n)
    pattern, counts
end


sample = "???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"

data = readlines("data/day12.txt")