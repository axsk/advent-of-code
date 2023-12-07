using Chain

multiplicities(hand) = sort(count.(unique(hand), hand), rev=true)
cardval(card::Char) = -findfirst(card, "A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2")
value1(hand) = (multiplicities(hand), cardval.(collect(hand)))

function part1(data=sample, valfun=value1)
  @chain data begin
    split.(_)
    sort(_, by=x -> valfun(x[1]))
    map(x -> parse(Int, x[2]), _)
    _ .* (1:length(_))
    sum
  end
end

function value2(hand)
  m = multiplicities(filter(!=('J'), hand))
  if isempty(m)
    m = [5]
  else
    m[1] += 5 - sum(m)
  end

  (m, [card == 'J' ? -1000 : cardval(card) for card in hand])
end

part2(data=sample) = part1(data, value2)

### Tests n data

function test()
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