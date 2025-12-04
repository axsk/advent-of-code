function day2a(str)
  c = 0
  for s in split(str, ',')
    c += f2(s)
  end
  return c
end

function f(str)
  a, b = split(str, '-')
  l = max(floor(Int, length(a) / 2), 1)
  m = parse(Int, a[1:l])
  a, b = parse.(Int, (a, b))
  @show a, b, m
  c = 0
  while true
    l = length(string(m))
    mm = m + m * 10^l
    if mm in a:b
      @show mm
      c += mm
    end
    if mm > b
      break
    end
    m += 1
  end
  return c
end

function day2b(input)
  c = 0
  for s in split(input, ",")
    a, b = parse.(Int, split(s, '-'))
    c += checkrange(a:b)
  end
  c
end

function checkrange(r::AbstractRange)
  c = 0
  for x in r
    s = string(x)
    for l in 1:length(s)
      #isinvalid of length l
      mult = (length(s) / l)
      !isinteger(mult) && continue
      mult < 2 && continue
      if s[1:l]^Int(mult) == s

        c += x
        break
      end
    end
  end
  c
end
