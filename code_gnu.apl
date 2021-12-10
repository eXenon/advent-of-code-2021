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