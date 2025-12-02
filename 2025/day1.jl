function day1(input)
  x, c1, c2 = 50, 0, 0
  for s in split(input)
    mirror = s[1] == 'L'
    mirror && (x = (100 - x) % 100)
    x += parse(Int, s[2:end])
    c2 += div(x, 100)
    x %= 100
    c1 += x % 100 == 0
    mirror && (x = (100 - x) % 100)
  end
  return c1, c2
end




