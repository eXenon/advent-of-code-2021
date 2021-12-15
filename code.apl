
⍝   ==  Day 1  ==

a ← 173 179 200 210 ...
+/0>a-(1↓a),0

⍝    (1↓a)      pop 1 element from a
⍝        ,0     appe(⊂'nd'),0,⍝ a-     substract the result from a
⍝ 0>            check if the result is negative
⍝ +/            make the sum of the vector, counting the number of negative results


w ← a+((1↓a),0)+((2↓a),0,0)

⍝ Sum a with itself twice, shifted each time, to calculate the windows

+/0>w-(1↓w),0

⍝ Same trick as before to get the differences




⍝   ==  Day 2  ==

d ← (⊂'forward'),6,(⊂'forward'),8 ...
c ← {⍵[1]≡(⊂'forward'):⍵[2]⋄⍵[1]≡(⊂'down'):⍵[2]×0J1⋄1:⍵[2]×0J¯1}

⍝  Convert size 2 vectors into a number:
⍝   <forward, n> -> n
⍝   <down, n>    -> n*i
⍝   <up, n>      -> -n*i

{9○⍵×11○⍵}+/c¨↓((((⍴d)÷2),2) ⍴ d)

⍝                 ((((⍴d)÷2),2) ⍴ d)  -> convert the data vector into a 1000x2 matrix
⍝                ↓                    -> convert the matrix into a vector of size 1000, with size 2 vectors as elements
⍝              c¨                     -> run c over the vector
⍝            +/                       -> sum all the results of c (which are complex numbers)
⍝ {9○⍵×11○⍵}                          -> multiply the real part with the imaginary part of a number

⍝ Here, we calculate the depth and forward position by
⍝ putting the forward position into the real part and
⍝ depth into the imaginary part of a number.

⍝     === Part 2 ===

acc ← {(⍵[1]+(9○⍺)+(⍵[2]×(9○⍺)×(0J1))),(⍵[2]+(11○⍺))}

⍝  acc takes in a 2-vector and a complex number (the command) and calculates
⍝  the new position (X is the real part, Y is the complex part) and new aim
⍝       ⍵[1]+(9○⍺)+(⍵[2]×(9○⍺)×(0J1)))
⍝       ----------
⍝       new forward position is the old position plus possible forward command
⍝                   ------------------
⍝                   new depth is old depth (complex part of ⍵[1]) plus aim (⍵[2])
⍝                   multiplied by possible forward command (9○⍺), time 0J1 to add
⍝                   it to the Y axis
⍝                                       ----------
⍝                                       aim is old aim plus new depth modifying
⍝                                       command

{9○⍵×11○⍵}1⊃↑acc/(⌽c¨↓((((⍴d)÷2),2) ⍴ d)),(⊂0 0)

⍝                                           ,(⊂0 0) -> initial state for acc (position 0, aim 0)
⍝                   ( c¨↓((((⍴d)÷2),2) ⍴ d))        -> use the same conversion as previously over the data
⍝                    ⌽                              -> reverse the data, since / is rigth to left
⍝               acc/                                -> accumulate over our data using acc
⍝           1⊃↑                                     -> get just the first number of our result, the position
⍝ {9○⍵×11○⍵}                                        -> multiply the real part with the imaginary part of a number



⍝   ==  Day 3  ==

⍝ First observation: gamma is the binary inverse of epsilon,
⍝ we just need to calculate one of them.

d ← 1000 12⍴ 1 0 1 0 0 0 0 0 1 1 0 0 0 1 1 1  ....

⍝  Get the data as a matrix of 1000x12 digits

⍝ The first step gets us gamma :

g ← {(0⌈⍵)÷⍵}¨((+/⍉d=1)-(+/⍉d=0))

⍝                    (+/⍉d=0)  -> count the number of 0's in each row of the transpose of d (meaning the columns of d)
⍝           (+/⍉d=1)           -> same with 1's
⍝                   -          -> difference of number of 1's and 0's in each column of d
⍝ {(0⌈⍵)÷⍵}                    -> calculate max(0, ⍵) / ⍵, transforming negative numbers into 0 and positives into 1
⍝          ¨                   -> apply to each
⍝                              -> convert from binary into decimal

⍝ And then we can just multiply gamma with his 2-complement:

(2⊥g)×(2⊥(g=0))

⍝         g=0       -> 2-complement, by using a mask-compare with 0
⍝     (2⊥    )      -> convert from binary to decimal
⍝ 2⊥g               -> convert g from binary to decimal
⍝    ×              -> multiply

⍝     === Part 2 ===

mc ← {{(0⌈⍵)÷⍵}¨((+/⍉⍵=1)-(+/⍉⍵=0))}

⍝ Define mc to find the most common bit in a vector.
⍝ This uses the same trick as with part 1, but as a function.
⍝ Thankfully, APL defaults to 0÷0 = 1, so our fallback value
⍝ in case of equal number of 0s and 1s is correct.

bm ← {⍺[1]=1: ⍉(⍉⍵[;⍺[2]]) ⋄ 1 : ⍉(1-⍉⍵[;⍺[2]])}

⍝ Define bm, a function that will create a bitmask
⍝ to filter a matrix based on the first bit.

⍝   {⍺[1]=1:                                } -> if ⍺[1] is 1 (we try to find all the rows starting with 1)
⍝             ⍉⍵[;⍺[2]]                       -> return the ⍺[2] column as a row, it will be the mask
⍝           ⍉(         )                      -> re-transpose to get the original shape
⍝                       ⋄ 1 : ⍉(1-⍉⍵[;⍺[2]])  -> else, return the inverse of the ⍺[2] row.

⍝ Putting this all together, we can build
f ← {⍉((mc ⍵)[⍺] ⍺ bm ⍵)/⍉⍵}

⍝      (mc ⍵)[⍺]                  -> Get the most common bit of the ⍺ column of ⍵
⍝     (          ⍺ bm ⍵)          -> Put it together to generate a bitmask for the ⍺ column of ⍵
⍝                       /⍉⍵       -> Apply the bitmask to ⍵ (transposition required because we want to filter rows)
⍝    ⍉                            -> Transpose back to get the original shape of ⍵
⍝
⍝ In aggregate, this function keeps only the rows of ⍵ with the most common bit.
⍝ Equality is handled by mc and will default to keeping 0s.
⍝ Now we just have to iteratively apply this to each column of our data:

oxygen ← 2⊥↑f/(⌽⍳12),⊂d

⍝         (⌽⍳12)      -> numbers for 12 to 1, our columns
⍝               ,⊂d   -> initial state of our foldr
⍝       f/            -> fold using f
⍝    2⊥↑              -> convert to row, then into base 10

⍝ For our CO2 scrubber rating, we use the same functions, but we
⍝ change the most-common function to use least-common (with default to 0).
⍝ To build this least-common, we can just take the opposite of most-common.

lc ← {1-mc ⍵}
ff ← {⍉((lc ⍵)[⍺] ⍺ bm ⍵)/⍉⍵}
cotwo ← 2⊥↑f2/(⌽⍳9),⊂d

⍝ Note: to get the CO2 rating, we only need 9 iterations
⍝ of the algorithm. I could fix it to not filter out everything
⍝ after too many iterations, but this is good enough ^^.

oxygen × cotwo



⍝   ==  Day 4  ==

draws ← 59,91,13,82,8, ...
boards ← 100 5 5⍴ 42 47 77 49 67 64 82 ...

⍝ Transform a board into an array of every possible
⍝ line, column or diagonal. Then, take drawn numbers
⍝ one by one and check if any line, column or diagonal
⍝ is entirely present in the drawn numbers. This
⍝ determines a winner.

cols ← {a←⍵ ⋄ {a[;⍵]}¨(⍳5)}
rows ← {a←⍵ ⋄ {a[⍵;]}¨(⍳5)}

⍝       a←⍵                  -> assign a temporary variable
⍝             {a[⍵;]}        -> get the ⍵th row
⍝                    ¨(⍳5)   -> apply from 1 to 5

ltr_diag ← {a←⍵ ⋄ {a[;⍵][⍵]}¨(⍳5)}
rtl_diag ← {a←⍵ ⋄ {a[;⍵][6-⍵]}¨(⍳5)}

⍝           a←⍵ ⋄                   -> assign a temporary variable, then
⍝                 {a[;⍵][⍵]}        -> get the ⍵th column, ⍵th row
⍝                           ¨(⍳5)   -> apply from 1 to 5

combinations ← {(⊂rtl_diag ⍵), (⊂ltr_diag ⍵), (rows ⍵), (cols ⍵)}

winner ← {c←⍺ ⋄ (⌈/{+/⍵∊(draws[⍳c])}¨(combinations boards[⍵;;]))=5}
⍝                                    (combinations boards[⍵;;])      -> generate lines, columns and diagonals of board ⍵
⍝                  {+/⍵∊(draws[⍳c])}                                 -> count how many elements of ⍵ are in the c first draws
⍝                                   ¨                                -> count for every combination
⍝               (⌈/                                            )     -> find the combination with the highest number of matches
⍝                                                               =5   -> and check to see if its 5 to see if we have a winner

winners ← ⍉((⍳(⍴ draws)) ∘.winner (⍳(⍴ boards)[1]))

⍝ Use outer product to check every board, for every drawing.
⍝ The result is a binary mask of 1 board per line, 1 column
⍝ per additional drawed number.
⍝ Now, we can find the earliest winner, then calculate its score.

{(⌊/⍵),(⍵⍳⌊/⍵)}({(winners[⍵;] / (⍳100))[1]}¨(⍳100))

⍝                       winners[⍵;]                       -> take all the wins of board ⍵
⍝                                   / (⍳100)              -> use them as a binary mask to find their indices
⍝                     {(                    )[1]}         -> take the first win
⍝                    (                           ¨(⍳100)) -> iterate over every board
⍝     {      (⍵⍳⌊/⍵)}                                     -> find the index of the minimum (i.e. the first winner)
⍝      (⌊/⍵),                                             -> and the minimum itself (i.e. the number of draws for the first winner)

score ← {draws[⍺] × +/(1-(,boards[⍵;;]) ∊ draws[⍳⍺]) / (,boards[⍵;;])}

⍝        draws[⍺]                                                       -> the last number after ⍺ draws
⍝                        (,boards[⍵;;]) ∊ draws[⍳⍺]                     -> a binary mask of all the numbers of board ⍵ that have been drawn after ⍺ draws
⍝                     (1-                          )                    -> invert the mask
⍝                                                    / (,boards[⍵;;])   -> apply the mask to board ⍵
⍝                   +/                                                  -> make the sum of the resulting numbers
⍝                 ×                                                     -> and multiply                                      

⍝     === Part 2 ===

⍝ Same procedure as above, but instead of the first winner,
⍝ we find the last winner.

{(⌈/⍵),(⍵⍳⌈/⍵)}({(winners[⍵;] / (⍳100))[1]}¨(⍳100))



⍝   ==  Day 5  ==

data ← 500 4 ⍴ 599,531,599 ...
lines ← {data[⍵;]}¨⍳500

⍝       {data[⍵;]}¨⍳500 -> split up the data into a vector of size 4 vectors

vhl ← ({(⍵[1]=⍵[3])∨(⍵[2]=⍵[3])}¨lines)/lines

⍝ Keep only lines where x1=x2 or y1=y2

⍝ The given lines can be drawn on a 1000x1000 grid.
⍝ The strategy will be to get every point covered by
⍝ every line. Then count how many appear more than
⍝ once.

step ← {⍵[1]=⍵[2]: 0 ⋄ 1: (⍵[2]-⍵[1])÷(|(⍵[2]-⍵[1]))}

⍝       ⍵[1]=⍵[2]: 0 ⋄                                 -> if both coordinates are equal, the step is 0
⍝                      1: (⍵[2]-⍵[1])÷(|(⍵[2]-⍵[1]))}  -> else the step is (x1 - x0)/abs(x1 - x0)

points ← {x ← ⍵[1] ⋄ y ← ⍵[3] ⋄ sx ← step ⍵[1] ⍵[3] ⋄ sy ← step ⍵[2] ⍵[4] ⋄ c ← ⌈(|(⍵[3] - ⍵[1]), |(⍵[4] - ⍵[2])) ⋄ {(x + (sx×⍵)), (y + (sy×⍵))}¨((⍳(c+1)) - 1)}

⍝         x ← ⍵[1] ⋄ y ← ⍵[3] ⋄                                                                                                                                  -> assign x and y as the starting point of the line
⍝                               sx ← step ⍵[1] ⍵[3] ⋄ sy ← step ⍵[2] ⍵[4] ⋄                                                                                      -> assign +1 or -1 depending on the direction of the line on a particular axis
⍝                                                                           c ← ⌈(|(⍵[3] - ⍵[1]), |(⍵[4] - ⍵[2])) ⋄                                              -> assign the number of increments between the most far away points
⍝                                                                                                                   {(x + (sx×⍵)), (y + (sy×⍵))}¨((⍳(c+1)) - 1)} -> the points are simply incremental steps away from the starting point

occ ← {+/(⍵=(↑{(points ↑⍺),⍵}/vhl,⍬))}

⍝             {(points ↑⍺),⍵}/vhl,⍬     -> foldr over the lines the accumulate all the points
⍝           (↑                     )    -> make into a single long vector
⍝      +/(⍵=                        )   -> count occurrences of ⍵

+/({(occ ⍵) > 1}¨(≠↑{(points↑⍺),⍵}/vhl,⍬)/↑{(points↑⍺),⍵}/vhl,⍬)

⍝ Count the points that are occuring more than once

⍝     === Part 2 ===

⍝ Because the way we generate the points of a line
⍝ is generic enough, we can simple reuse the code
⍝ from the previous method, skipping the filtering
⍝ step that generates vhl.



⍝   ==  Day 6  ==

⍝ APL makes this exercise pretty straightforward.

data ← 1,1,3,5,1 ...

step ← {∊{⍵=0:6,8 ⋄ 1: ⍵-1}¨⍵}
⍝        {⍵=0:6,8 ⋄ 1: ⍵-1}    -> On 0, reset fish to 6 and spawn a fish with 8
⍝                          ¨⍵  -> For every fish
⍝       ∊                      -> Flatten the list into a new state

⍴↑step/(⍳80),⊂data

⍝             ,⊂data -> initial state
⍝        (⍳80)       -> execute 80 times
⍝   step/            -> step will ignore ⍺ (the day counter, effectively)
⍝ ⍴↑                 -> get size of final vector

⍝     === Part 2 ===

⍝ This solution also works for 256 days, but it is mightily
⍝ inefficient. So, in order to make this a actually compute,
⍝ we might want to look for something cleverer.

⍝ We can translate the algorithm to a mathematical sequence:
⍝   f[n] = 1                if n < 9
⍝   f[n] = f[n-7] + f[n-9]  if n ≥ 9

⍝ This can be naively translated into APL, but is of course
⍝ still completely unsuable for 256 days. So, we implement
⍝ a version that uses a cache.

ff←{⍵<9:1 ⋄ ⍵=9:2 ⋄ ⍺[⍵-7]+⍺[⍵-9]}

⍝   ⍵<9:1 ⋄                         -> if input <9, return 1
⍝           ⍵=9:2 ⋄                 -> if input =9, return 2
⍝                   ⍺[⍵-7]+⍺[⍵-9]   -> else, use cached values

fish←{(⌽↑{⍵,(⍵ ff ⍺)}/(⌽⍳(⍵+(8-⍺))),⊂⍬)[1]}

⍝        {⍵,(⍵ ff ⍺)}                       -> expand the cache by adding the next value
⍝                    /(⌽⍳(⍵+(8-⍺))),⊂⍬      -> use a foldr, starting with an empty cache
⍝                         ⍵+(8-⍺)           -> not all fish start at 8, so we shift the sequence to adjust
⍝     (⌽↑                              )[1] -> get the last value of the cache to get our result

⍝ In aggregate, our fish function returns the number
⍝ of fish generate by a single fish starting with value
⍝ ⍺, after ⍵ days. It is fast to calculate, since it
⍝ ff uses an iterative cache.

+/{⍵ fish 256}¨data

⍝ Get the sum of all fish generated by all starting fish.
⍝ Note: you might need to raise the print precision of
⍝ Dyalog.



⍝   ==  Day 7  ==

data ← 1101,1,29,67,1102, ...

⌊/{+/|¨(data - ⍵)}¨(⍳1000)

⍝        (data - ⍵)           -> substract current candidate position from original positions
⍝      |¨                     -> apply absolute value
⍝    +/                       -> sum all fuel consumptions
⍝   {              }¨(⍳1000)  -> apply to all candidates from 1 to 1000
⍝ ⌊/                          -> find smallest

⍝     === Part 2 ===

⍝ For the new variation, just change the way the fuel
⍝ consumption is computed.
⍝ For n steps, the consumption is now n*(n+1)/2.

⌊/{+/{(|⍵)×((|⍵)+1)÷2}¨(data - ⍵)}¨(⍳1000)



⍝   ==  Day 9  ==

⍝ Turns out, reading from a file is boring.
⍝ Let's do some real APL.

data ← 100 100 ⍴ 9  8  9  9  8  9 ...

islowpoint ← {m←⍵ ⋄ ∧/({(m[⍵[1];⍵[2]]=0)∨(m[⍵[1];⍵[2]]>m[2;2])}¨↓(4 2⍴1 2 2 1 2 3 3 2))}

⍝     (m[⍵[1];⍵[2]]=0)∨(m[⍵[1];⍵[2]]>m[2;2])                            -> checks if m[2;2] is either lower than its neighbours or that the neighbours are 0 (boundary)
⍝    {                                      }¨↓(4 2⍴1 2 2 1 2 3 3 2)    -> apply this to (1 2), (2 1), (3 2) and (2 3) to check for every neighbour of the center of a 3x3 matrix
⍝ ∧/(                                                               )   -> check that _all_ the neighbours are lower 
⍝
⍝ This function gives us if the center of a 3x3 matrix is a lowpoint.

lowpoints ← ({islowpoint ⍵}⌺3 3) (data + 1)

⍝                          ⌺3 3)             -> use a 3x3 stencil to get every neighbourhood of every number in data 
⍝            {islowpoint ⍵}                  -> apply islowpoint to make a bitmask
⍝           (                    (data + 1)  -> apply it to (data + 1) in order to differentiate 0's in the data from the boundary

score ← {m←,⍵ ⋄ bm←,⍺ ⋄ (+/bm)+(+/bm/m)}

⍝        m←,⍵ ⋄                          -> unravel the data, assign to m
⍝               bm←,⍺ ⋄                  -> unravel the bitmask of lowpoints, assign to bm
⍝                       (+/bm)           -> count the lowpoints
⍝                               (+/bm/m) -> get the height of each low point and sum
⍝                              +         -> sum both for final score