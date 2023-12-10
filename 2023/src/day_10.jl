# https://adventofcode.com/2023/day/10

input = readlines("2023/data/day_10.txt")
parse_input(lines) = permutedims(reduce(hcat, collect.(lines)))

directions = Dict(
    '|' => ((-1, 0), (1, 0)),
    '-' => ((0, -1), (0, 1)),
    'L' => ((-1, 0), (0, 1)),
    'J' => ((-1, 0), (0, -1)),
    '7' => ((1, 0), (0, -1)),
    'F' => ((1, 0), (0, 1)),
    'S' => ((-1, 0), (1, 0), (0, -1), (0, 1))
)

function solve(input)
    grid = parse_input(input)
    start = findfirst(grid .== 'S')
    pos = start
    history = [start, start]
    area = 0
    while true
        pipe = grid[pos]
        dirs = directions[pipe]
        for d in dirs
            next = pos + CartesianIndex(d)
            if grid[next] in keys(directions) && history[end-1] != next
                dy = next[1] + pos[1]
                dx = next[2] - pos[2]
                area += 1 / 2 * (dx) * (dy) # shoelace formula
                pos = next
                break
            end
        end
        pos == start && break
        push!(history, pos)
    end
    history = history[2:end]  # remove extra start at beginning
    area = convert(Int, abs(area) - length(history) / 2 + 1)  # account for partial filled squares
    return div(length(history), 2), area
end