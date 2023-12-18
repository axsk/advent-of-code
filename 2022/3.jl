r = "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw"

function parserucksack(l)
    lh = div(length(l), 2)
    p = intersect(l[1:lh], l[lh+1:end])[1]
    islowercase(p) ? p - 'a' + 1 : p - 'A' + 27
end

function parse2(group)
    l1, l2, l3 = group
    p = intersect(l1, l2, l3)
    p = only(p)
    islowercase(p) ? p - 'a' + 1 : p - 'A' + 27
end

part1(data) = sum(parserucksack.(split(data)))

function part2(data)
    d = split(data)
    d = reshape(d, 3, :)
    p = parse2.(eachcol(d))
    sum(p)
end
