# generate_run_stats.py
#
# Description:
# 	Opens a .fastq file assumed to be an sequencing run output,
#   and generates basic stats about the run to command-line
#
# Author:
#	@lonelyjoeparker / Joe Parker / NBIC / 2024
#
# Usage:
#
# 	generate_run_stats.py  --fastq <input fasta> --output <output tab-delimited file> [--trim <characters to retain from names]
#
# Where args:
#
#	<fastq>:			FASTQ file to be appended
#	<ouput data>:		output file
#	<trim>:				Integer number of characters [1:10] to retain from start of names
#
# Sample FASTA input:
'''
>7291732___KOG0002
maahksfrikqklakklkqnrsvpqwvrlrtgntirynakrrhwrrtklkl
>At3g02190___KOG0002
-------mikkklgkkmrqnrpipnwirlrtdnkirynakrrhwrrtklgf
>SPCC663.04___KOG0002
mpshksfrtkqklakaarqnrpipqwirlrtgntvhynmkrrhwrrtklni
>YJL189w___KOG0002
maaqksfrikqkmakakkqnrplpqwirlrtnntirynakrrnwrrtkmni
>CE06883___KOG0002
msalkksfikrklakkqkqnrpmpqwvrmktgntmkynakrrhwrrtklkl
>Hs4506647___KOG0002
msshktfrikrflakkqkqnrpipqwirmktgnkirynskrrhwrrtklgl
'''
# Sample .tdf output:
'''
name    Sequencing yield	N50 kbp	Max length kbp	Q mean

'''
# Output / details:
#	Will read input KOG data, and fasta file, remove reads that appear in filter,
#	and write amended .fasta to output
from Bio import SeqIO
import argparse

# parse input args
parser = argparse.ArgumentParser(description='Converts a fasta file to phylip format. Note: assumes input is aligned already...')
parser.add_argument('--fastq',	help='FASTQ file to be appended')
parser.add_argument('--output',	help='output .tdf tab delimited data file')
parser.add_argument('--trim',	help='characters to retain from name (start at left)', type=int, choices=range(1,11))
args = parser.parse_args()

# init global variables
aln = []
num_reads = 0
lengths = []
qscores = []

# read alignment

for seq in SeqIO.parse(args.fastq,'fastq'):
	#if args.trim > 1:
	#	seq.id = seq.id[args.trim:]
	#aln.append(seq)
    num_reads += 1
    print(len(seq))

print(num_reads)
# At this point write out
#SeqIO.write(aln,args.output,'fasta')
