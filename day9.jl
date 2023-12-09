# part 1: 9 mins, part 2: 18 mins
# where i used the ugly explicit formulation for part2
# reverse trick spotted only afterwards

using IterTools
using Lazy: @>>

parseline(l) = @>> split(l) parse.(Int)
extrapolate(series) = @>> series iterated(diff) takewhile(!iszero) sum(last)

part1(data) = data .|> parseline .|> extrapolate |> sum
part2(data) = data .|> parseline .|> reverse .|> extrapolate |> sum

using Transducers, Folds
# automatic parralelization via Folds :>
# i wished @>> worked here
part2trans(data) = data |> Map(parseline) |> Map(reverse) |> Map(extrapolate) |> Folds.sum
#part2folds(data) = Folds.sum(parseline ⨟ reverse ⨟ extrapolate, data)

#parseinput(lines) = map(l -> parse.(Int, split(l)), lines)
#extrapolate(series) = sum(last, takewhile(!iszero, iterated(diff, series)))
#part1(data) =  sum(extrapolate, parseinput(data))
#part2(data) =  sum(extrapolate ∘ reverse, parseinput(data))


###

sample = split("0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45", "\n")
function test()
  @assert part1(sample) == 114
  @assert part2(sample) == 2
end

test()