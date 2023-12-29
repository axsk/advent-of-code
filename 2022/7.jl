data = readlines("7.in")

function dirs(data)
    sizestack = Int[0]
    sizes = Int[]
    for l in data
        l = split(l)
        if l[2] == "cd" && l[3] == ".."
            push!(sizes, pop!(sizestack))
            sizestack[end] += sizes[end]
        elseif l[2] == "cd"
            push!(sizestack, 0)
        elseif isnumeric(l[1][1])
            sizestack[end] += parse(Int, l[1])
        end
    end
    while length(sizestack) > 1
        push!(sizes, pop!(sizestack))
        sizestack[end] += sizes[end]
    end
    sizes
end
part1(data=data) = sum(filter(<(100000), dirs(data)))
function part2(data=data)
    d = sort(dirs(data))
    tofree = 30000000 - (70000000 - d[end])
    filter(>=(tofree), d) |> first
end

ex = split(raw"""$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k""", '\n')