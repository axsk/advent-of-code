
test() = day7(readlines("day7.test"))
function day7(input=readlines("day7.in"))
    prev, input... = collect.(input)
    prev = [c == 'S' ? 1 : 0 for c in prev]
    splits = 0
    for line in input
        next = zeros(Int, length(line))
        for i in 1:length(line)
            if prev[i] > 0
                if line[i] == '.'
                    next[i] += prev[i]
                elseif line[i] == '^'
                    splits += 1
                    for j in [i-1, i+1]
                        next[j] += prev[i]
                    end
                end
            end
            
        end
        prev = next
    end
    return  splits, sum(prev)
end
