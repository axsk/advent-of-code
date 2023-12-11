# part 1: 16 mins
# part 2: 1h 43 mins

sample1 = split("RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)", "\n")

sample2 = split("LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)", "\n")

sample3 = split("LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)", "\n")

data = readlines("data/day8.txt")

using Chain

function parseinput(lines)
  instructions = [c == 'L' ? 1 : 2 for c in lines[1]]
  network = Dict(map(lines[3:end]) do l
    k, l, r = match(r"(\w+) = \((\w+), (\w+)\)", l).captures
    (k => (l, r))
  end)
  instructions, network
end

# this wasnt hard so far
function part1(lines)
  ins, net = parseinput(lines)
  curr = "AAA"
  i = 0
  while curr != "ZZZ"
    curr = net[curr][ins[i%length(ins)+1]]
    i += 1
  end
  return i
end

# strings to numbers, instructions to array
function fastdict(net)
  k = collect(keys(net))
  num(str) = findfirst(==(str), k)

  x = zeros(Int, 2, length(k))
  for i in 1:eachindex(k)
    x[:, i] .= num.(net[k[i]])
  end

  start = findall(x -> x[3] == 'A', k)
  stop = findall(x -> x[3] == 'Z', k)
  x, start, stop
end

# bruteforce arrays, didnt terminate
function part2(lines)
  ins, net = parseinput(lines)
  x, start, stop = fastdict(net)
  curr = start
  stoparr = zeros(Bool, length(lines))
  stoparr[stop] .= true
  j = 0
  while true
    for i in ins
      all(stoparr[curr]) && return j
      curr = x[i, curr]
      j += 1
    end
  end
end

# we even thought of zzz not directly mapping back, wbut data is generous
function cycles(ins, net, curr)
  i = 0
  while true
    curr = net[curr][ins[i%length(ins)+1]]
    i += 1
    curr[end] == 'Z' && return i
  end
end

function starts(net, c='A')
  k = collect(keys(net))
  k[findall(x -> x[3] == c, k)]
end

# i simulated the uneven cycles here, but its not necessary...
function part2b(lines)
  ins, net = parseinput(lines)
  start = starts(net)
  c = [cycles(ins, net, curr) for curr in start]
  lcm(c...)
end