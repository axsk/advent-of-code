@views function joltage(n, b::AbstractVector, acc=0)
  n == 0 && return acc
  n -= 1
  digit, loc = findmax((b[1:end-n]))
  return joltage(n, (b[loc+1:end]), 10 * acc + digit)
end

joltage(n, line::AbstractString) = joltage(n, [c - '0' for c in line])

function day3(input=readlines("day3.in")) # 260 microseconds
  sum(joltage(2, line) for line in input),
  sum(joltage(12, line) for line in input)
end

###

test() = day3(split(
  "987654321111111
  811111111111119
  234234234234278
  818181911112111"))

# non-allocating but also slower
function joltage_onepass(n, b::AbstractString, acc=0)
  n == 1 && return acc
  n -= 1
  dig, i = findmax(c -> c - '0', @view(b[1:end-n]))
  tail = @view(b[i+1:end])
  return joltage_onepass(n, tail, 10 * acc + (dig))
end