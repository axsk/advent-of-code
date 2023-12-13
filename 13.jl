function colsymdiff(col, block)
  dist = min(col, size(block, 2) - col)
  sum((block[:, col-dist+1:col] .!= block[:, col+dist:-1:col+1]))
end

findcolsym(b, t) = begin
  x = [i for i in 1:size(b, 2)-1 if colsymdiff(i, b) == t]
  return isempty(x) ? 0 : first(x)
end

symvalue(b, t=0) = 100 * findcolsym(b, t) + findcolsym(b', t)

part1(input) = sum(symvalue, parseinput(input))
part2(input) = sum(x -> symvalue(x, 1), parseinput(input))

parseinput(lines) =
  map(split(lines, "\n\n")) do block
    stack(split(block)) .== '#'
  end

###

data = String(read("13.in"))
ex = String(read("13.ex"))

function test()
  @assert part1(data) == 41859
  @assert part2(data) == 30842
end