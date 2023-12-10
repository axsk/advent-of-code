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
                # shoelace formula
                dy = next[1] + pos[1]
                dx = next[2] - pos[2]
                area += 1 / 2 * (dx) * (dy)

                pos = next
                push!(history, pos)
                break
            end
        end
        pos == start && break
    end
    history = history[2:end-1]  # remove extra starts
    area = convert(Int, abs(area) - length(history) / 2 + 1)  # account for partial filled squares
    return div(length(history), 2), area
end


# alternative approach for area, using raycasting

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