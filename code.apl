
⍝   ==  Day 1  ==

a ← 173 179 200 210 ...
+/0>a-(1↓a),0

⍝    (1↓a)      pop 1 element from a
⍝        ,0     appe(⊂'nd'),0,⍝ a-     substract the result from a
⍝ 0>            check if the result is negative
⍝ +/            make the sum of the vector, counting the number of negative results


w←a+((1↓a),0)+((2↓a),0,0)

⍝ Sum a with itself twice, shifted each time, to calculate the windows

+/0>w-(1↓w),0

⍝ Same trick as before to get the differences




⍝   ==  Day 2  ==

d ← (⊂'forward'),6,(⊂'forward'),8 ...
c←{⍵[1]≡(⊂'forward'):⍵[2]⋄⍵[1]≡(⊂'down'):⍵[2]×0J1⋄1:⍵[2]×0J¯1}

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

acc←{(⍵[1]+(9○⍺)+(⍵[2]×(9○⍺)×(0J1))),(⍵[2]+(11○⍺))}

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

d←1000 12⍴ 1 0 1 0 0 0 0 0 1 1 0 0 0 1 1 1  ....

⍝  Get the data as a matrix of 1000x12 digits

⍝ The first step gets us gamma :

g←{(0⌈⍵)÷⍵}¨((+/⍉d=1)-(+/⍉d=0))

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

