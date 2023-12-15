# https://adventofcode.com/2023/day/15
# part1 6 mins, part2 28 mins

ex = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
data = readlines("15.in")[1]

hash(str) =
  foldl(str, init=0) do h, c
    (h + Int(c)) * 17 % 256
  end

function part1()
  sum(hash.(split(data, ",")))
end

function part2(data=data)
  instr = split(data, ",")
  dict = Dict{Int,Array{Tuple{String,Int},1}}()
  foreach(instr) do i
    hashmap!(dict, i)
  end
  checksum(dict)
end

function hashmap!(dict, lens)
  if lens[end] == '-'  # remove
    label = lens[1:end-1]
    box = get!(dict, hash(label), [])
    i = findfirst(l -> l[1] == label, box)
    if !isnothing(i)
      popat!(box, i)
    end
  elseif lens[end-1] == '='  #
    label = lens[1:end-2]
    focal = parse(Int, lens[end])
    box = get!(dict, hash(label), [])
    i = findfirst(l -> l[1] == label, box)
    if isnothing(i)
      push!(box, (label, focal))
    else
      box[i] = (label, focal)
    end
  end
end

function checksum(dict)
  s = 0
  for (k, v) in dict
    length(v) == 0 && continue  # don't really understand why this is needed
    s += (k + 1) * sum(i * l[2] for (i, l) in enumerate(v))
  end
  s
end
