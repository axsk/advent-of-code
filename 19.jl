ex = readchomp("19.ex")

function parseinput(str)
  rules = Dict()
  inst, parts = split(str, "\n\n")
  inst = split(inst, "\n")

  for i in inst
    name, inst = split(i[1:end-1], "{")

    ivec = []
    r = split(inst, ",")
    for r in r[1:end-1]
      push!(ivec, parsecheck(r))
    end

    rules[name] = (ivec, r[end])
  end

  ps = []
  for p in split(parts)
    x, m, a, s = parse.(Int, eachmatch(r"(\d+)", p) .|> x -> x.match)
    push!(ps, (; x, m, a, s))
  end
  rules, ps
end

function parsecheck(i)

  p, s, v, t = match(r"(.*)([<>])(\d+):(.*)", i)
  v = parse(Int, v)
  comp = s == ">" ? >(v) : <(v)
  return Symbol(p), comp, t
end

function part1(data)
  rules, parts = parseinput(data)
  filter(parts) do p
    evalpart(p, "in", rules)
  end .|> sum |> sum
end

function evalpart(part, workflow, rules)
  @show workflow
  workflow == "A" && return true
  workflow == "R" && return false
  rls, exit = rules[workflow]
  for r in rls
    p, comp, t = r
    comp(getfield(part, p)) && return evalpart(part, t, rules)
  end
  return evalpart(part, exit, rules)
end


function evalint(partint, workflow, rules)
  intsize = prod(length.(values(partint)))
  workflow == "A" && return intsize
  workflow == "R" && return 0
  intsize == 0 && return 0
  @show workflow
  rls, exit = rules[workflow]
  accepted = 0
  for r in rls
    p, comp, t = r
    trueint, falseint = splitinterval(partint, r)
    accepted += evalint(trueint, t, rules)
    partint = falseint
  end
  accepted += evalint(partint, exit, rules)
  return accepted
end

function splitinterval(partint, (p, comp, t))
  a, b = extrema(getfield(partint, p))
  x = comp.x
  if comp.f == <
    i1 = (a:min(b, x - 1))
    i2 = (max(a, x):b)
  else
    i1 = (max(a, x + 1):b)
    i2 = (a:min(x, b))
  end
  @assert length(i1) + length(i2) == length(getfield(partint, p))
  @show pi1 = (; partint..., p => i1)
  @show pi2 = (; partint..., p => i2)
  pi1, pi2
end

function part2(data)
  rules, parts = parseinput(data)

  startint = (x=1:4000, m=1:4000, a=1:4000, s=1:4000)
  evalint(startint, "in", rules)
end