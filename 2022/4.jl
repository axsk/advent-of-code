parseints(line) =
    map(split(line, ',')) do bl
        UnitRange(parse.(Int, split(bl, '-'))...)
    end

isredundant(ints) = issubset(ints...) || issubset(reverse(ints)...)
isoverlap(ints) = length(intersect(ints...)) > 0

part1(data) = sum(isredundant.(parseints.(split(data))))
part2(data) = sum(isoverlap.(parseints.(split(data))))