const data = collect(readlines("data/input1.txt"))

function day1(lines=data)
  sum(lines) do x
    parse(Int, x[findfirst(isnumeric, x)]) * 10 + parse(Int, x[findlast(isnumeric, x)])
  end
end

function day1b(lines=data)
  rep = map((a, b) -> a => b, ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"], 1:9)
  revrep = map(rep) do (a, b)
    reverse(a) => b
  end
  sum(lines) do x
    f = replace(x, rep...)
    b = replace(reverse(x), revrep...)
    parse(Int, f[findfirst(isnumeric, f)] * b[findfirst(isnumeric, b)])
  end
end