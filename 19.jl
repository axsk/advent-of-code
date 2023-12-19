# part1: 38 mins part2: 36 mins

ex = readchomp("19.ex")

function parseinput(str)
  workflows = Dict()
  wfs, ps = split(str, "\n\n")
  wfs = split(wfs, "\n")

  for wf in wfs
    name, rules = split(wf[1:end-1], "{")
    rules = split(rules, ",")
    rvec = map(parserule, rules[1:end-1])
    workflows[name] = (rvec, rules[end])
  end

  parts = map(split(ps)) do p
    x, m, a, s = parse.(Int, eachmatch(r"(\d+)", p) .|> x -> x.match)
    (; x, m, a, s)
  end
  workflows, parts
end

function parserule(str)
  prop, sign, val, target = match(r"(.*)([<>])(\d+):(.*)", str)
  val = parse(Int, val)
  comp = sign == ">" ? >(val) : <(val)
  return Symbol(prop), comp, target
end

function part1(data)
  rules, parts = parseinput(data)
  filter(parts) do p
    evalpart(p, "in", rules)
  end .|> sum |> sum
end

function evalpart(part, workflow, rules)
  workflow == "A" && return true
  workflow == "R" && return false
  rls, exit = rules[workflow]
  for r in rls
    prop, comp, t = r
    comp(part[prop]) && return evalpart(part, t, rules)
  end
  return evalpart(part, exit, rules)
end

function evalint(partint, workflow, rules)
  intsize = prod(length.(values(partint)))
  workflow == "A" && return intsize
  workflow == "R" && return 0
  intsize == 0 && return 0
  rls, exit = rules[workflow]
  accepted = 0
  for r in rls
    prop, comp, t = r
    trueint, falseint = splitinterval(partint, r)
    accepted += evalint(trueint, t, rules)
    partint = falseint
  end
  accepted += evalint(partint, exit, rules)
  return accepted
end

function splitinterval(partint, (p, comp, t))
  a, b = extrema(partint[p])
  x = comp.x
  if comp.f == <
    i1 = (a:min(b, x - 1))
    i2 = (max(a, x):b)
  else
    i1 = (max(a, x + 1):b)
    i2 = (a:min(x, b))
  end
  pi1 = (; partint..., p => i1)
  pi2 = (; partint..., p => i2)
  pi1, pi2
end

function part2(data)
  rules, _ = parseinput(data)
  startint = (x=1:4000, m=1:4000, a=1:4000, s=1:4000)
  evalint(startint, "in", rules)
end