import argparse, re, os
import numpy

# set up an argparse object to parse the N parameter
parser = argparse.ArgumentParser(description='Python script to parse inputs corresponding to R4IDs multiple BLAST searches')
parser.add_argument('input_file',type=argparse.FileType('r'),help='filename to open')

# evaluate the args
args = parser.parse_args()

# now need to work out which are the other blast results
#
# e.g. all sample_01 / intensity 10000; db various / intensity 10000:
#	replicates/replicate_01/output/sample_.sample_01.fasta._intensity.10000.-ON-db_.Beta-patula.fasta.-intensity-.10000.out
#	replicates/replicate_01/output/sample_.sample_01.fasta._intensity.10000.-ON-db_.Erycina-echinata.fasta.-intensity-.10000.out
#	replicates/replicate_01/output/sample_.sample_01.fasta._intensity.10000.-ON-db_.Napenthes-alata.fasta.-intensity-.10000.out
#	replicates/replicate_01/output/sample_.sample_01.fasta._intensity.10000.-ON-db_.Silene-uniflora.fasta.-intensity-.10000.out
#	replicates/replicate_01/output/sample_.sample_01.fasta._intensity.10000.-ON-db_.Sorbus-aria.fasta.-intensity-.10000.out

# compile regexes
nums_regex = re.compile("[0-9]+")

# parse the input file to get sample number and intensity; and blast DB intensity
#print os.path.dirname(args.input_file.name)
filename_dir = os.path.dirname(args.input_file.name)
filename_numbers = nums_regex.findall(args.input_file.name)
'''
python parse_multi_blast_output.py replicates/replicate_01/output/sample_.sample_01.fasta._intensity.10000.-ON-db_.Napenthes-alata.fasta.-intensity-.10000.out 
sample_01
['01', '01', '10000', '10000']
'''
sample = filename_numbers[1]
intensity_sample = filename_numbers[2]
intensity_species = filename_numbers[3]
species_list = ('Beta-patula','Erycina-echinata','Napenthes-alata','Silene-uniflora','Sorbus-aria')

# should now be able to generate all the targets for this input sample:
blast_results = {}
for species in species_list:
	target = filename_dir+'/sample_.sample_'+str(sample)+'.fasta._intensity.'+str(intensity_sample)+'.-ON-db_.'+str(species)+'.fasta.-intensity-.'+str(intensity_species)+'.out'
	#print target
	blast_results[species]=target

# work out which is the TP:
'''
sample_1=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_01_basecall_both-runs.poretools.fasta	# TP= N.alata
sample_2=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_02_basecall_both-runs.poretools.fasta	# TP= ? Arabidopsis
sample_3=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_03_basecall_both-runs.poretools.fasta	# TP= S.uniflora
sample_4=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_04_basecall_both-runs.poretools.fasta	# TP= E.echinata
sample_5=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_05_basecall_both-runs.poretools.fasta	# TP= S.aria
sample_6=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_06_basecall_both-runs.poretools.fasta	# TP= B.patula
'''
sample_identities = {'06':'Beta-patula','04':'Erycina-echinata','01':'Napenthes-alata', '03':'Silene-uniflora','05':'Sorbus-aria'}
correct_ID_spp = sample_identities[sample]
#print correct_ID_spp

# a dict for the TP hits
TP_hit_idents = {}

'''
# do the actual BLAST result parsing:
for line in args.input_file.readlines():
	line_data = line.strip().split()
	hit_query = line_data[1]
	hit_length = int(line_data[2])
	hit_pident = float(line_data[3]) / 100.00
	hit_nident = hit_length * hit_pident
	TP_hit_idents[hit_query] = hit_nident
	
print 'total hits ' + str(len(TP_hit_idents))
#quit()
'''

# we are going to make / populate a hash of hashes (dict of dicts) containing:
# hash of hashes, key = read ID
# 	for each read ID, a hash of <DB,nident> pairs
all_hits={}
# open each one
for species in blast_results:
	with open(blast_results[species], 'r') as results_file:
		for line in results_file.readlines():
			# parse this hit data
			line_data = line.strip().split()
			hit_query = line_data[1]
			hit_length = int(line_data[2])
			hit_pident = float(line_data[3]) / 100.00
			hit_nident = hit_length * hit_pident
			# see if this read exists in the hits hash so far
			if hit_query in all_hits:
				all_hits[hit_query][species] = hit_nident
			else:
				all_hits[hit_query] = {}
				all_hits[hit_query] = dict([(species,hit_nident)])


# set up summaries:
one_way_TP = 0	# hits for TP DB only
one_way_FP = 0	# hits for any DB other than the correct one
two_way_TP = 0	# hits for TP DB only
two_way_FP = 0	# hits for any DB other than the correct one
two_way_scores = list()	# 1 if bias > 0; else 0
two_way_scores_cutoff_50 = list()	# only count scores > |50|
biases = list()	# list of biases for two-way hits

for read in all_hits:
	# what kind of hits do we have for this read?
	# types:
	#	only correct DB: one_way_TP
	#	only another DB: one_way_FP
	#	correct DB and at least one other: two-way, so:
	#		two_way_TP if bias > 0
	#		two_way_FP if bias =<0
	if(len(all_hits[read]) == 1):
		# only a single hit observed
		if correct_ID_spp in all_hits[read]:
			one_way_TP = one_way_TP + 1
		else:
			one_way_FP = one_way_FP + 1
			
	elif correct_ID_spp in all_hits[read]:
		score_correct = all_hits[read][correct_ID_spp]
		score_max = max(all_hits[read].values())
		bias = score_correct - score_max
		if bias == 0:
			two_way_scores.append(1)
			two_way_TP = two_way_TP + 1
			# correct bias to be positive; correct one less next-biggest
			hit_values = list(all_hits[read].values())
			hit_values.sort()
			hit_values.reverse()
			bias = score_correct - hit_values[1]
			#print all_hits[read]
			#print score_correct
			#print hit_values[1]
		else:
			two_way_scores.append(0)
			two_way_FP = two_way_FP + 1
		
		if bias > 50: 
			two_way_scores_cutoff_50.append(1)
		elif bias < -50:
			two_way_scores_cutoff_50.append(0)

		biases.append(bias)
		#print 'max ' + str(score_max) + '\tcorrect:\t' + str(score_correct) + '\tdiff\t' + str(bias)
		
mean_bias = numpy.mean(biases)

# print the effing output out
print "sample\tsample_DB_intensity\tTP_species\tspecies_DB_intensity\ttotal_hits\tone_way_TP\tone_way_FP\ttwo_way_TP\ttwo_way_FP\ttwo_way_rate\ttwo_way_rate_with_cutoff\tmean_bias"
print "{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}".format(sample, intensity_sample, correct_ID_spp, intensity_species, len(all_hits), one_way_TP, one_way_FP, two_way_TP, two_way_FP, numpy.mean(two_way_scores), numpy.mean(two_way_scores_cutoff_50), mean_bias)