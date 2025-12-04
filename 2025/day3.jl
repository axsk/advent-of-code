@views @inbounds function joltage(n, b::AbstractVector, acc=0)
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

### 130 us
@inline function joltage_unrolled(n::Int, line::AbstractString)
  bytes = codeunits(line)
  acc::Int = 0
  start = 1
  L = length(bytes)

  @inbounds for remaining = n:-1:1
    last = L - (remaining - 1)

    maxdigit = 0x00
    maxpos = start

    for i = start:last
      d = bytes[i] - UInt8('0')
      if d > maxdigit
        maxdigit = d
        maxpos = i
      end
    end

    acc = acc * 10 + maxdigit
    start = maxpos + 1
  end

  return acc
end