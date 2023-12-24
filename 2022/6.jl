# 4+1 mins

data = readchomp("6.in")

function part1(data=data, n=4)
    for i in n:length(data)
        if length(Set(data[i-n+1:i])) == n
            return i
        end
    end
end

part2(data=data) = part1(data, 14)