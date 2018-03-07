# Python script to take an input corresponding to either a reference
# (R4IDs) or query sequencing run, and output a random subsample of reads.

# Author: Joe Parker (@lonelyjoeparker // joe@lonelyjoeparker.com)

###########################################
# Pseudocode for selecting subsets of reads
#
# add sequences
#for r in read:
#    add r.index to sequence hash with value r.seq
#    add random to index hash with value r.index
#
# order by random integers
#new keys hash = ordered random index hash
#
# select first n and output
#for i in samples:
#    select new keys hash [i]
#    output append sequence hash [new keys hash[i]] 
