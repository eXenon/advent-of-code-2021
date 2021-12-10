⍝   ==  Day 8  ==

⍝ Today, we stop cheating with the inputs and actually start
⍝ reading the data from an external file. This means, that the
⍝ next parts will be more specific to GNU APL, the dialect
⍝ used by replit, while previously, I was using Dyalog APL.

⍝ Repl link containing the code : https://replit.com/@eXenon/AngryUnwillingQuerylanguage

split ← {(⍺≠⍵)⊂⍵}

⍝        (⍺≠⍵)    -> create a bitmask for every caracter that isn't the separator
⍝       {     ⊂⍵} -> use the bitmask to create a partition of the input


onefourseveneight ← {↑+/{(⍴⍵)∊2 3 4 7}¨' ' split ↑('|' split ⍵)[2]}

⍝                                                 ('|' split ⍵)[2]  -> split on '|' and keep the second part
⍝                                      ' ' split ↑                  -> split on ' '
⍝                       {(⍴⍵)∊2 3 4 7}¨                             -> find all "digits" with 2, 3, 4 or 7 segments on
⍝                    ↑+/                                            -> count them all

+/onefourseveneight ⎕FIO[49] 'day8_1'

⍝   onefourseveneight ⎕FIO[49] 'day8_1'   -> read the file 'day8_1' and apply onefourseveneight to each line
⍝ +/                                      -> sum everything together



⍝     === Part 2 ===

⍝ We are going to deduce the segments by adding and
⍝ substracting the sets of segments that below to the
⍝ identifiable digits (1, 4, 7 and 8).
⍝ Here is the reasoning:
⍝   the segment that appears only 4 times => bottom left (e)
⍝   the segment that appears only 6 times => top left (b)
⍝   the digit with 4 segments that has a top left (b) in it => 4
⍝   the other digit with 4 segments => 7
⍝   7 - 1 => top segment (a)
⍝   8 - 7 - e - 4 => bottom (g)
⍝   4 - 1 - b => middle (d)
⍝   8 - e => 9
⍝   The digit with 6 segments that isn't 9 => 6
⍝   8 - 6 => top right (c)
⍝   1 - c => bottom right (f)

s ← 'abcdefg' 
bl←{l←⍵ ⋄ (({+/(l=⍵)}¨s)=4)/s}

⍝   l←⍵                         -> assign input line to l
⍝                    ¨s         -> for each possible segment
⍝           {+/(l=⍵)}           -> count the number of occurences of it
⍝          (         )=4        -> find the one that appears 4 times
⍝         (              )/s    -> and apply it to s to find the segment

tl←{l←⍵ ⋄ (({+/(l=⍵)}¨s)=6)/s}

⍝ Same, but with 6 occurences

sub ← {n ← ⍵ ⋄ ({1-⍵∊n}¨⍺)/⍺}

⍝      n ← ⍵ ⋄                  -> the value we substract is assigned to n
⍝               {1-⍵∊n}¨⍺       -> create a binary mask of every element in ⍺ not present in ⍵
⍝              (         )/⍺    -> and apply to ⍺

one ← {d ← ' ' split ⍵ ⋄ (,↑{(⍴⍵)=1}¨d)/d}
eight ← {d ← ' ' split ⍵ ⋄ (,↑{(⍴⍵)=7}¨d)/d}

⍝        d ← ' ' split ⍵ ⋄                   -> split the line into digits
⍝                          (,↑{(⍴⍵)=7}¨d)/d  -> find the element of d that is of length 7
⍝
⍝ (there is are a bunch of format operators in this function, but you could 
⍝  probably make that a bit cleaner...)

a -> 0   2 3   5 6 7 8 9 -> 8
b -> 0       4 5 6   8 9 -> 6
c -> 0 1 2 3 4     7 8 9 -> 8
d ->     2 3 4 5 6   8 9 -> 7
e -> 0   2       6   8   -> 4
f -> 0 1   3 4 5 6 7 8 9 -> 9
g -> 0   2 3   5 6   8 9 -> 7

e, b, f -> easy to find
1 - f -> c
8 - 4 - 7 - 1 - e -> g
7 occurences, not g -> 
