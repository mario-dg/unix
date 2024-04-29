#!/bin/sh

# Sorts lines by the last column(Score), if scores are equal by the first column(Serial Number). Output of the line with the worst Score (Only Name).

grep --invert-match --ignore-case "<failed>" - | sort --unique --reverse --numeric-sort --field-separator=';' --key=3,3 --key=1,1 | tee "$1" | tail -1 | cut --delimiter=';' --fields=2   
# invert-match : Outputs only the lines, where <failed> is not present
# ignore-case : Ignores Capitalization of <failed>
# - : Takes stdin as input
# $1 : Takes the first Paramater as input file
# unique : Filters multiple appearances of the same line
# reverse : descending sort
# numeric-sort : Sorts by Number, not digit
# field-separator : Lets sort know, that columns are separated by ;
# key n,n : Takes the n-th Column
# tee $1 : Writes into the file that is given as parameter and stdout
# delimiter : Lets cut know, where the lines are separated
# fields n : Cuts the n-th field out of the string and outputs it to stdout
