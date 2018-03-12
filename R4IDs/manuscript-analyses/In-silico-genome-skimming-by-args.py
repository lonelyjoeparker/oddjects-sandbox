# Python script to take an input corresponding to either a reference genome
# output a random subsample of in silico simulated reads.
# forked from github.com/lonelyjoeparker/real-time-phylogenomics/wales-analyses/in-silico-genome-skimming

# Author: Joe Parker (@lonelyjoeparker // joe@lonelyjoeparker.com)

from Bio import SeqIO, SeqRecord
from Bio.Seq import Seq, MutableSeq
from Bio.Alphabet import generic_dna
from numpy import random
from math import floor
from random import randint
import warnings, argparse

# set up an argparse object to parse the N parameter
parser = argparse.ArgumentParser(description='Python script to take an input corresponding to either a reference genome and output a random subsample of reads to simulate a sequencing run (with 5% sequencing error)')
parser.add_argument('N_simulated', metavar='N', type=int, nargs='+', help='N - how many reads to simulate')
parser.add_argument('input_file',  type=argparse.FileType('r'),help='filename to open')
parser.add_argument('output_file',type=argparse.FileType('w'),help='filename to write to')

# evaluate the args
args = parser.parse_args()

# function to do the subampling
def make_subsample(genome, outfile, num_draws):
    partial_subsample = []
    assembly  = list(SeqIO.parse(genome,'fasta')) # cast to a list; we need to address individual elements more than iterate reliably
    samples = num_draws # this is how many reads from each scaffold - nb should be a global increment but... meh
    #outfile = 'subsample_'+label+'_'+str(samples).zfill(7)+'_draws.fasta'
    #outfile = label
    ## print('making '+str(samples)+' draws, output to '+outfile.name)
    for i in range(0,samples):
        # randomly pick (uniform distribution) one of the scaffolds/contigs
        # to draw this sample from 
        which_scaffold = randint(0,len(assembly)-1)
        scaffold = assembly[which_scaffold]
        #print(scaffold.id)
        some_new_seq = False
        nonzero_length_check = False
        while not nonzero_length_check:
            new_length = int(random.exponential(1500))
            start_pos = int(random.uniform(1,(len(scaffold)-new_length)))
            some_new_seq = scaffold[start_pos:(start_pos+new_length)]
            some_new_seq = model_error(some_new_seq)
            some_new_seq.id = some_new_seq.id + "_sampled_" + str(start_pos) + "_" + str(new_length)
            # WARNINGS if short (verbose)
            #if not (len(some_new_seq) >0):
            #warnings.warn('short sequence: '+str(len(some_new_seq))+' id '+some_new_seq.id)
            nonzero_length_check = (len(some_new_seq) >0)
        partial_subsample.append(some_new_seq)

    if(SeqIO.write(partial_subsample,outfile,'fasta')):
        pass
        ## print('wrote out '+str(len(partial_subsample))+' sequences to '+outfile.name)
    else:
        warnings.warn('COULD NOT write '+str(len(partial_subsample))+' sequences to '+outfile.name)

    del partial_subsample[:]
    pass

def model_error(input_sequence):
	## print 'input:\t'+input_sequence[0:29].seq

	# mutation rate is reciprocal of this
	mutation_rate = 20
	
	# map for mutation types
	mutation_select = ('substitution', 'insertion', 'deletion')

	# make the output sequence mutable
	output_sequence = input_sequence
	output_sequence.seq = output_sequence.seq.tomutable()
		
	# calculate the number of mutations to make
	mutations = int(len(output_sequence) / mutation_rate)
	##print 'input length '+str(input_length)+' making '+ str(mutations)
	
	for mutation in range(0,mutations):
		# where to start the mutation
		start_pos = int(random.uniform(0,len(output_sequence.seq)))
		# what type it is
		mutation_type = mutation_select[random.randint(0,3)]
		#print 'mutation '+str(mutation)+ ' position '+str(start_pos)+' type '+mutation_type
		# do the mutations
		if(mutation_type == 'substitution'):
			# point mutation, selected randomly from {ACGT} ; note this isn't a realistic base composition really
			output_sequence.seq[start_pos] = 'acgt'[random.randint(0,4)]
	
		if(mutation_type == 'insertion'):
			# insert a single base as a polymer of previous site
			output_sequence.seq = output_sequence.seq[0:start_pos]+output_sequence.seq[start_pos]+output_sequence.seq[start_pos:]

		if(mutation_type == 'deletion'):
			# delete a single base
			output_sequence.seq = output_sequence.seq[0:start_pos-1]+output_sequence.seq[start_pos:]

	##print 'output:\t'+output_sequence[0:29].seq
	return output_sequence

# do it
make_subsample(args.input_file,args.output_file,int(args.N_simulated[0]))