
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
⍝ The strategy will be to get a bitmask for every line,
⍝ showing wether a given point is underneath that line.
⍝ Then we can sum every bitmap and count the number of
⍝ cells that have a number greater than 2.

isunder ← {((⍵[1]=⍵[3])∧(⍵[1]=⍺[1])∧(((⍵[2]≤⍺[2])∧(⍺[2]≤⍵[4]))∨(⍵[4]≤⍺[2])∧(⍺[2]≤⍵[2])))∨((⍵[2]=⍵[4])∧(⍵[2]=⍺[2])∧(((⍵[1]≤⍺[1])∧(⍺[1]≤⍵[3]))∨(⍵[3]≤⍺[1])∧(⍺[1]≤⍵[1])))}

⍝ This boils down to: 
⍝   - x1 = x3 = ⍺x and ⍺y in between y1 and y2
⍝   - or y1 = y3 = ⍺y and ⍺x in between x1 and x2