function day3(lines)
  mat = reduce(hcat, collect.(lines))
  acc = 0
  for i in eachindex(lines)
    for m in eachmatch(r"(\d+)", lines[i])
      num = parse.(Int, m.match)
      len = length(m.match)
      pos = m.offset
      valid = any(box(pos, len, i, mat)) do char
        !isnumeric(char) && char != '.'
      end
      valid && (acc += num)
    end
  end
  return acc
end

function box(x, lx, y, m)
  nx, ny = size(m)
  xs = max(x - 1, 1):min(x + lx - 1 + 1, nx)
  ys = max(y - 1, 1):min(y + 1, ny)
  m[xs, ys]
end

function day3b(lines)
  mat = reduce(hcat, collect.(lines))
  stardict = Dict()
  for i in eachindex(lines)
    for m in eachmatch(r"(\d+)", lines[i])
      num = parse.(Int, m.match)
      len = length(m.match)
      pos = m.offset
      coords = findall(paddedbox(pos, len, i, mat)) do char
        char == '*'
      end
      for c in coords
        c = Tuple(c) .+ (pos, i)
        stardict[c] = push!(get(stardict, c, []), num)
      end
    end
  end
  sum(values(stardict)) do nums
    length(nums) == 2 ? prod(nums) : 0
  end
end

function paddedbox(x, lx, y, m)
  mp = fill('.', size(m) .+ (2, 2))
  mp[2:end-1, 2:end-1] = m
  box(x + 1, lx, y + 1, mp)
end

sample = split(raw"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..", "\n")