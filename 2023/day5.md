# my favorites:

## reduction to step1
note that we can reuse the map from step1 to map intervals :) 
also, instead of walking through the maps he is rather walking through the interval by finding the next map
actually a really nice (albeit not cleaned up) solution
https://github.com/ypisetsky/advent-of-code-2023/blob/main/day5.py

## nice tricks
this one uses that the mapped range's sources are (are they?) contiguous, making nice use of sort to simplify the problem.
note also the use of rubys & for range intersection.
i wonder how this would look without the contigious assumption
https://git.sr.ht/~awsmith/advent-of-code/tree/2023-ruby/item/lib/day05.rb

## best overall
using the find_overlap(from,to,section) to return the next overlapping region and offset, very clean!
https://github.com/KvGeijer/advent-of-zote-2023/blob/main/5.zote

# other sols:

## brute force
i was already using reducers and realizing the numbers where on the order of 10^9 at most this was a clear go
https://github.com/axsk/AOC23.jl/blob/main/day5.jl

someone did this in cuda, why not? :D
https://github.com/piman51277/AdventOfCode/blob/master/solutions/2023/5/part2.cu

## bruteforce inverse approach:
instead of going through the provided ranges, start with locations and go backward to see if we have the seed
i like it very much
https://github.com/fuglede/adventofcode/blob/master/2023/day05/solutions.py

## interval arithmetic:
tried this myself afterwards until i realised i allowed for multiple maps in a single section.
can be handled by splitting into unmapped and mapped per section
https://github.com/jonathanpaulson/AdventOfCode/blob/master/2023/5.py
https://github.com/morgoth1145/advent-of-code/blob/9344c2e30130f4d555e7b7393b65a52646bae00f/2023/05/solution.py
https://github.com/linuxhelf/aoc/blob/master/2023/src/day5/mod.rs


## approximative solution
funny to see this. sample the ranges and refine the best results. no guarantees but seemed to work
https://www.reddit.com/r/adventofcode/comments/18b4b0r/comment/kc27vyj/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button


## functional
i was desperately looking for some fold approach, this is one but it doesnt look clean yet to me
https://github.com/Nohus/AdventofCode2023/blob/master/src/main/kotlin/day05/Day5_2.kt

