# bash script to simulate

# reference_genomes
spp_1=A-halleri_01.fasta
spp_2=A-thaliana_02.fasta
spp_3=C-rubella_03.fasta
spp_4=A-lyrata_04.fasta
spp_5=C-bursa_05.fasta
spp_6=C-sativa_06.fasta

# do the subsampling and test
#for which_rep in {in-silico-rep_01,in-silico-rep_02,in-silico-rep_03,in-silico-rep_04,in-silico-rep_05,in-silico-rep_06,in-silico-rep_07,in-silico-rep_08,in-silico-rep_09,in-silico-rep_10,in-silico-rep_11,in-silico-rep_12,in-silico-rep_13,in-silico-rep_14,in-silico-rep_15,in-silico-rep_16,in-silico-rep_17,in-silico-rep_18,in-silico-rep_19,in-silico-rep_20}
for which_rep in {in-silico-rep_03,in-silico-rep_04,in-silico-rep_05,in-silico-rep_06,in-silico-rep_07,in-silico-rep_08,in-silico-rep_09,in-silico-rep_10,in-silico-rep_11,in-silico-rep_12,in-silico-rep_13,in-silico-rep_14,in-silico-rep_15,in-silico-rep_16,in-silico-rep_17,in-silico-rep_18,in-silico-rep_19,in-silico-rep_20}
do
	# a single simulation replicate	
		
	mkdir replicates/$which_rep
	mkdir replicates/$which_rep/training
	mkdir replicates/$which_rep/testdata
	mkdir replicates/$which_rep/output
	
	# set up the jacknifes, training
	for subsample_R4IDs in {10,100,1000,10000}
	do
		# subsample the species (training) and make DBs
		for species in {$spp_1,$spp_2,$spp_3,$spp_4,$spp_5,$spp_6}
		do
			echo species $species $subsample_R4IDs
			# the subsampling
			# sample the genome for R4IDs
			python In-silico-genome-skimming-by-args.py $subsample_R4IDs reference-genomes-for-in-silico/$species replicates/$which_rep/training/spp.$species._intensity_.$subsample_R4IDs
			# sample the genome for reads
			python In-silico-genome-skimming-by-args.py $subsample_R4IDs reference-genomes-for-in-silico/$species replicates/$which_rep/testdata/spp.$species._intensity_.$subsample_R4IDs
			#python In-silico-genome-skimming-by-args.py $subsample_R4IDs reference-genomes-for-in-silico/$species spp.$species._intensity_.$subsample_R4IDs
			# make the blast DB
			makeblastdb -dbtype nucl -in replicates/$which_rep/training/spp.$species._intensity_.$subsample_R4IDs -out replicates/$which_rep/training/db_$species._intensity_.$subsample_R4IDs
		done
	done
	
	# now run the samples against the DBs
	for subsample_R4IDs in {10,100,1000,10000}
	do
		for subsample_tests in {10,100,1000,10000}
		do
			for species in {$spp_1,$spp_2,$spp_3,$spp_4,$spp_5,$spp_6}
			do
				for testsample in {$spp_1,$spp_2,$spp_3,$spp_4,$spp_5,$spp_6}
				do
					# blastn
					this_test_input=replicates/$which_rep/testdata/spp.$testsample._intensity_.$subsample_tests
					this_db=replicates/$which_rep/training/db_$species._intensity_.$subsample_R4IDs
					echo R4IDs-intensity $subsample_R4IDs	tests-intensity $subsample_tests	DB $this_db	testsample $this_test_input
					blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 8 -num_alignments 1 -max_hsps 1 -db $this_db -query $this_test_input > replicates/$which_rep/output/sample_.$testsample._intensity.$subsample_tests.-ON-db_.$species.-intensity-.$subsample_R4IDs.out 2>replicates/$which_rep/output/sample_.$testsample._intensity.$subsample_tests.-ON-db_.$species.-intensity-.$subsample_R4IDs.err
				done
			done
		done
	done
	
	rm -r replicates/$which_rep/training
	rm -r replicates/$which_rep/testdata
done

