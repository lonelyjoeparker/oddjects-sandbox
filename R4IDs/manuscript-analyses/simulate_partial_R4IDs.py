# Python script to take an input corresponding to either a reference
# (R4IDs) or query sequencing run, and output a random subsample of reads.

# Author: Joe Parker (@lonelyjoeparker // joe@lonelyjoeparker.com)

###########################################
# Pseudocode for selecting subsets of reads
#
# add sequences
#for r in read:
#	add r.index to sequence hash with value r.seq
#	add random to index hash with value r.index
#
# order by random integers
#new keys hash = ordered random index hash
#
# select first n and output
#for i in samples:
#	select new keys hash [i]
#	output append sequence hash [new keys hash[i]]

import argparse, random
from Bio import SeqIO, SeqRecord
from Bio.Seq import Seq

# set up an argparse object to parse the N parameter
parser = argparse.ArgumentParser(description='Python script to take an input corresponding to either a reference (R4IDs) or query sequencing run, and output a random subsample of reads.')
parser.add_argument('N_subsamples', metavar='N', type=int, nargs='+', help='N - how many reads to subsample')
parser.add_argument('input_file',type=argparse.FileType('r'),help='filename to open')
parser.add_argument('output_file',type=argparse.FileType('w'),help='filename to write to')

# evaluate the args
args = parser.parse_args()

# set up input and output lists
input_sequences = {}
output_sequences = list()

# read input
with args.input_file as file:
    sequence_file_iterator = SeqIO.parse(file,'fasta')
    for record in sequence_file_iterator:
        #print(record.description)
        #print(record.seq)
        input_sequences[record.id]=record

    file.close()

#print 'total length of seqs hash dict ' + str(len(input_sequences))

# pick subsamples
for i in range(0,args.N_subsamples[0]):
	random_key = input_sequences.keys()[random.randint(0,len(input_sequences)-1)]
	#print str(i) + ': random key ' + random_key
	output_sequences.append(input_sequences[random_key])
	del input_sequences[random_key]

# write output	
SeqIO.write(output_sequences,args.output_file,'fasta')
