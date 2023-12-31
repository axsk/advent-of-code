function parseline(line)
  _, tickets = split(line, ":")
  need, have = split.(split(tickets, "|"))
  return need, have
end

function day4(lines=sample)
  sum(lines) do line
    need, have = parseline(line)
    l = length(intersect(need, have))
    l > 0 ? 2^(l - 1) : 0
  end
end

function day4b(lines=sample)
  cards = ones(Int, length(lines))
  for (i, line) in enumerate(lines)
    need, have = parseline(line)
    l = length(intersect(need, have))
    cards[i.+(1:l)] .+= cards[i]
  end
  sum(cards)
end

splitlines(x) = split(x, "\n")
sample = splitlines(
  """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11""")