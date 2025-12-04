function shiftpadview(X, i, j)
  M, N = size(X)
  Y = zeros(Int, M + 2 * abs(i), N + 2 * abs(j))
  I = (1:M) .+ abs(i)
  J = (1:N) .+ abs(j)
  Y[I.+i, J.+j] .= X
  @views Y[I, J]
end

function removables(X::AbstractMatrix)
  N = zero(X)
  for i in -1:1, j in -1:1
    N += shiftpadview(X, i, j)
  end
  N .<= 4 .&& X .== 1
end

day4a(X) = sum(removables(X))

function day4b(X::AbstractMatrix)
  X = copy(X)
  acc = 0
  while true
    r = removables(X)
    sum(r) == 0 && break
    acc += sum(r)
    X[r] .= 0
  end
  return acc
end

function day4(lines::AbstractVector)
  X = mapreduce(vcat, lines) do line
    (collect(line) .== '@')'
  end
  day4a(X), day4b(X)
end


day4() = day4(readlines("day4.in"))

test = split("..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.")