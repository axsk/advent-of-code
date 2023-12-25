data2 = eachline("data/input2.txt") |> collect

function id_combinations(line)
  g, rest = split(line, ":")
  id = parse(Int, match(r"Game (\d+)", g).captures[1])
  combinations = map(split(rest, ";")) do combination
    Dict(map(eachmatch(r"(\d+) (\w+)", combination)) do group
      group[2] => parse(Int, group[1])
    end)
  end
  return id, combinations
end

#mapreduce over dicts would be so nice.. have to get acuqauinted with Dictionaries.jl

function day2(lines=data2, limit=Dict("red" => 12, "green" => 13, "blue" => 14))
  sum(lines) do line
    id, combinations = id_combinations(line)
    isok = all(combinations) do combination
      for (k, v) in combination
        v > limit[k] && return false
      end
      return true
    end
    isok ? id : 0
  end
end

function day2b(lines=data2)
  sum(lines) do line
    id, combs = id_combinations(line)
    maxd = Dict("red" => 0, "green" => 0, "blue" => 0)
    for comb in combs
      for (k, v) in comb
        maxd[k] = max(maxd[k], v)
      end
    end
    prod(values(maxd))
  end
end