# https://adventofcode.com/2023/day/11

input = readlines("2023/data/day_11.txt")

function parse_input(input)
    mapreduce(hcat, input) do line
        [c == '#' for c in line]
    end'
end

function dist(p1, p2, emptyrows, emptycols, n)
    sum(zip([1, 2], [emptyrows, emptycols])) do (i, empty)
        a, b = sort([p1[i], p2[i]])
        b - a + sum(empty[a:b]) * (n - 1)
    end
end

function part_1(lines, n=2)
    galaxy = parse_input(lines)
    co = Tuple.(findall(galaxy))  # ugly Tuple call.. by now I start to hate CartesianIndex
    emptyrows = vec(sum(galaxy, dims=2) .== 0)
    emptycols = vec(sum(galaxy, dims=1) .== 0)
    delta = [dist(c1, c2, emptyrows, emptycols, n) for c1 in co for c2 in co]
    div(sum(delta), 2)
end

part_2(lines) = part_1(lines, 1_000_000)

@info part_1(input)
@info part_2(input)

sample = split("...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....")

# Solution 2 using SparseArrays
# I actually did this first but stopped in part 2 since
# findall didn't work (efficiently) for the adjoint sparse array :/

using SparseArrays

function expand(galaxy, n=2)
    excols(galaxy) = reduce(hcat, [ifelse(iszero(l), spzeros(Bool, length(l), n), l) for l in eachcol(galaxy)])
    exrows(galaxy) = excols(galaxy')'
    exrows(excols(galaxy))
end

function part_1s(lines)
    galaxy = parse_input(lines)
    e = expand(galaxy)
    co = Tuple.(findall(e))
    delta = [sum(abs, c1 .- c2) for c1 in co for c2 in co]
    sum(delta) / 2
end

# first approach, which I sacked because findall was superslow for adjoint sparse arrays
using SparseArrays
function part_2s(input, n=1_000_000)
    galaxy = sparse(parse_input(lines))
    e = expand(galaxy, n)
    co = Tuple.(findall(e'))
    delta = [sum(abs, c1 .- c2) for c1 in co for c2 in co]
    div(sum(delta), 2)
end

@info part_1(input)
@info part_2(input)
