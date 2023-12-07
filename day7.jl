function parseinput(lines)
  hands = []
  bids = Int[]
  for l in lines
    hand, bid = split(l, " ")
    push!(hands, hand)
    push!(bids, parse(Int, bid))
  end
  hands, bids
end

function beats(hand1, hand2)
  hand1, hand2
  c1 = multiplicities(hand1)
  c2 = multiplicities(hand2)

  c1 > c2 && return true
  c1 < c2 && return false

  return hashighcard(hand1, hand2)
end

function beats2(hand1, hand2)
  c1 = multiplicities(filter(x -> x != 'J', hand1))
  c2 = multiplicities(filter(x -> x != 'J', hand2))

  if length(c1) == 0
    c1 = [5]
  else
    c1[1] += count(x -> x == 'J', hand1)
  end

  if length(c2) == 0
    c2 = [5]
  else
    c2[1] += count(x -> x == 'J', hand2)
  end

  c1 > c2 && return true
  c1 < c2 && return false

  return hashighcard(hand1, hand2, "A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J")
end

function hashighcard(hand1, hand2, valuation="A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2")
  cardval(card::Char) = findfirst(card, valuation)
  cardval.(collect(hand1)) < cardval.(collect(hand2)) && return true
  cardval.(collect(hand1)) > cardval.(collect(hand2)) && return false
  error()
end

function multiplicities(hand1)
  chars = Set(collect(hand1))
  sort(count.(chars, hand1), rev=true)
end

function part1(data=sample)
  hands, bids = parseinput(data)
  p = sortperm(hands, lt=(x, y) -> beats(x, y), rev=true)
  sum((1:length(bids)) .* bids[p])
end

function part2(data=sample)
  hands, bids = parseinput(data)
  p = sortperm(hands, lt=(x, y) -> beats2(x, y), rev=true)
  sum((1:length(bids)) .* bids[p])
end

function test()
  @assert !beats2("JKKK2", "QQQQ2")
  @assert beats2("QQQQ2", "JKKK2")
  @assert part1(sample) == 6440
  @assert part2(sample) == 5905
  @assert part1(data) == 246424613
  @assert part2(data) == 248256639
end

sample = split(raw"""32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483""", "\n")

data = readlines("data/day7.txt")