parselines(lines) =
  map(split(lines, "\n\n")) do block
    stack(map(split(block, "\n")) do line
      collect(line) .== '#'
    end)
  end

function checksym(n, vec)
  n >= length(vec) && return false
  off = 0
  while 0 < n - off < n + 1 + off <= length(vec)
    vec[n-off] != vec[n+1+off] && return false
    off += 1
  end
  return true
end

function symcount(block)
  counts = Int[]
  for n in 1:size(block, 1)-1
    if checksym(n, eachrow(block))
      push!(counts, n)
    end
  end
  for n in 1:size(block, 2)-1
    if checksym(n, eachcol(block))
      push!(counts, n * 100)
    end
  end
  isempty(counts) && return [0]
  return counts
end

function smudge(block)
  block = copy(block)
  s = symcount(block)
  for i in eachindex(block)
    block[i] = !block[i]
    s2 = symcount(block)
    s2 = setdiff(s2, s)
    if !isempty(s2)
      return first(s2)
    end
    block[i] = !block[i]
  end
  return 0
end

function part1(input=data)
  blocks = parselines(input)
  sum(x -> first(symcount(x)), blocks)
end

function part2(input=data)
  blocks = parselines(input)
  sum(smudge, blocks)
end

data = String(read("13.in"))
ex = String(read("13.ex"))

function test()
  @assert part1(data) == 41859
  @assert part2(data) == 7178
end