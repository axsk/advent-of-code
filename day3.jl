function day3(lines=sample)
  isspecial(char) = !isnumeric(char) && char != '.'
  mat = reduce(hcat, collect.(lines))
  acc = 0
  for (i, line) in enumerate(lines)
    for (num, pos, len) in findnums(line)
      if any(isspecial, box(pos, len, i, mat))
        acc += num
      end
    end
  end
  return acc
end

function findnums(line)
  c = eachmatch(r"(\d+)", line)
  function f(m)
    #map(c) do m
    num = parse.(Int, m.match)
    len = length(m.match)
    pos = m.offset
    (num, pos, len)
  end
  f.(c)
end

function box(x, lx, y, m)
  nx, ny = size(m)
  xs = max(x - 1, 1):min(x + lx - 1 + 1, nx)
  ys = max(y - 1, 1):min(y + 1, ny)
  m[xs, ys]
end

function day3b(lines=sample)
  isstar(char) = char == '*'
  mat = reduce(hcat, collect.(lines))
  stardict = Dict()
  for (i, line) in enumerate(lines)
    for (num, pos, len) in findnums(line)
      for xy in findall(isstar, paddedbox(pos, len, i, mat))
        xy = Tuple(xy) .+ (pos, i)
        stardict[xy] = push!(get(stardict, xy, []), num)
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

splitlines(x) = split(x, "\n")
sample = splitlines(raw"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..")