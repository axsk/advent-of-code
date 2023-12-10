# https://adventofcode.com/2023/day/10

input = readlines("2023/data/day_10.txt")
parse_input(lines) = permutedims(reduce(hcat, collect.(lines)))

function part_1(input)
    grid = parse_input(input)
    start = findfirst(grid .== 'S')
    pos = start
    history = [start, start]
    while true
        pipe = grid[pos]
        dirs = directions[pipe]
        for d in dirs
            next = pos + CartesianIndex(d)
            if grid[next] in keys(directions) && history[end-1] != next
                pos = next
                push!(history, pos)
                break
            end
        end
        pos == start && break
    end
    return div(length(history), 2) - 1, area(grid, history)
end
@info part_1(input)

function area(grid, history)
    nx, ny = size(grid)
    mask = zeros(Bool, nx, ny)
    area = zeros(Bool, nx, ny)
    mask[history] .= true
    grid[findfirst(grid .== 'S')] = 'L' # cheated
    for i in 1:ny
        inside = false
        for j in 1:nx
            c = grid[i, j]
            if mask[i, j] && c in "|LJ"
                inside = !inside
            elseif !mask[i, j]
                inside && (area[i, j] = true)
            end
        end
    end
    return sum(area)
end
@info part_2(input)


directions = Dict(
    '|' => ((-1, 0), (1, 0)),
    '-' => ((0, -1), (0, 1)),
    'L' => ((-1, 0), (0, 1)),
    'J' => ((-1, 0), (0, -1)),
    '7' => ((1, 0), (0, -1)),
    'F' => ((1, 0), (0, 1)),
    'S' => ((-1, 0), (1, 0), (0, -1), (0, 1))
)

#=
    | is a vertical pipe connecting north and south.
    - is a horizontal pipe connecting east and west.
    L is a 90-degree bend connecting north and east.
    J is a 90-degree bend connecting north and west.
    7 is a 90-degree bend connecting south and west.
    F is a 90-degree bend connecting south and east.
    . is ground; there is no pipe in this tile.
    S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
=#