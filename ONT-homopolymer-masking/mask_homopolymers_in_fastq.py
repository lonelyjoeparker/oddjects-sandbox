# Python script to open a fastq file
# then remove homopolymers of length >= n
# and spit out the result
# Joe Parker @lonelyjoeparker

import argparse, re
from Bio import SeqIO, SeqRecord
from Bio.Seq import Seq

# set up an argparse object to parse the N parameter
parser = argparse.ArgumentParser(description='Remove homopolymers from each sequence (greedily).')
parser.add_argument('N_homopolymers', metavar='N', type=int, nargs='+', help='N - all homopolymer runs [N] bases or longer will be truncated')
parser.add_argument('input_file',type=argparse.FileType('r'),help='filename to open')

# evaluate the args
args = parser.parse_args()

# compile patterns / replacements for a
homopolymer_a = re.compile("A{"+str(args.N_homopolymers[0])+",}")
homopolymer_a_replace = 'A'*(args.N_homopolymers[0]-1)
# compile patterns / replacements for a
homopolymer_c = re.compile("C{"+str(args.N_homopolymers[0])+",}")
homopolymer_c_replace = 'C'*(args.N_homopolymers[0]-1)
# compile patterns / replacements for a
homopolymer_g = re.compile("G{"+str(args.N_homopolymers[0])+",}")
homopolymer_g_replace = 'G'*(args.N_homopolymers[0]-1)
# compile patterns / replacements for a
homopolymer_t = re.compile("T{"+str(args.N_homopolymers[0])+",}")
homopolymer_t_replace = 'T'*(args.N_homopolymers[0]-1)

# test sequence
# n_str = "acacacacaaaacccccgggacaggcacgccgatttcaaccacaacccccacccctcatttctcacaggccacaaaccacaccacaca"*3

# show the starting seqence, test
# print 'start\t', n_str

# make the substitution, test
# masked_seq = homopolymer_a.sub(homopolymer_a_replace,homopolymer_c.sub(homopolymer_c_replace,homopolymer_g.sub(homopolymer_g_replace,homopolymer_t.sub(homopolymer_t_replace,n_str))))

# show the masked sequence, test
# print 'end\t', masked_seq

masked_sequences = list()

with args.input_file as file:
    sequence_file_iterator = SeqIO.parse(file,'fastq')
    for record in sequence_file_iterator:
        # print(record.description)
        this_starting_seq = str(record.seq)
        # print(record.seq)
        masked_seq = homopolymer_a.sub(homopolymer_a_replace,homopolymer_c.sub(homopolymer_c_replace,homopolymer_g.sub(homopolymer_g_replace,homopolymer_t.sub(homopolymer_t_replace,this_starting_seq))))
        # print(masked_seq)
        new_sequence = SeqRecord.SeqRecord(id=record.id,seq=Seq(masked_seq),name=record.name,description=record.description)
        masked_sequences.append(new_sequence)

output_name = 'masked.fasta'
with open(output_name,'w') as output:
    SeqIO.write(masked_sequences,output_name,'fasta')
