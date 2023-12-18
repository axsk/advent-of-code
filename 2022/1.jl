ex = raw"""
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

data = readchomp("1.in")

function both(input)
    s = map(split(input, "\n\n")) do block
        l = split(block)
        sum(parse.(Int, l))
    end
    p1 = maximum(s)
    p2 = sum(sort(s)[end-2:end])
    p1, p2
end