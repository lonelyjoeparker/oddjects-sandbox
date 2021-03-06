# bash script to simulate

# input for training data
R4IDs_1=Napenthes-alata.fasta
R4IDs_2=Beta-patula.fasta
R4IDs_3=Erycina-echinata.fasta
R4IDs_4=Silene-uniflora.fasta
R4IDs_5=Sorbus-aria.fasta

# input for test data
sample_1=sample_01.fasta	# TP= N.alata
sample_2=sample_02.fasta	# TP= ? Arabidopsis
sample_3=sample_03.fasta	# TP= S.uniflora
sample_4=sample_04.fasta	# TP= E.echinata
sample_5=sample_05.fasta	# TP= S.aria
sample_6=sample_06.fasta	# TP= B.patula

# do the subsampling and test
for which_rep in {replicate_01,replicate_02,replicate_03,replicate_04,replicate_05,replicate_06,replicate_07,replicate_08,replicate_09,replicate_10,replicate_11,replicate_12,replicate_13,replicate_14,replicate_15,replicate_16,replicate_17,replicate_18,replicate_19,replicate_20}
do
	# a single simulation replicate	
		
	mkdir replicates/$which_rep
	mkdir replicates/$which_rep/training
	mkdir replicates/$which_rep/testdata
	mkdir replicates/$which_rep/output
	
	# set up the jacknifes, training
	for subsample_R4IDs in {100,500,1000,5000,10000}
	do
		# subsample the species (training) and make DBs
		for species in {$R4IDs_1,$R4IDs_2,$R4IDs_3,$R4IDs_4,$R4IDs_5}
		do
			echo species $species $subsample_R4IDs
			# the subsampling
			python simulate_partial_R4IDs.py $subsample_R4IDs inputs-training/$species replicates/$which_rep/training/spp.$species._intensity_.$subsample_R4IDs
			makeblastdb -dbtype nucl -in replicates/$which_rep/training/spp.$species._intensity_.$subsample_R4IDs -out replicates/$which_rep/training/db_$species._intensity_.$subsample_R4IDs
		done
		# subsample the samples
		for testsample in {$sample_1,$sample_3,$sample_4,$sample_5,$sample_6}
		do
			echo test sample $testsample $subsample_R4IDs
			# the subsampling
			python simulate_partial_R4IDs.py $subsample_R4IDs inputs-test/$testsample replicates/$which_rep/testdata/spp.$testsample._intensity_.$subsample_R4IDs 
		done
	done
	
	# now run the samples against the DBs
	for subsample_R4IDs in {100,500,1000,5000,10000}
	do
		for subsample_tests in {100,500,1000,5000,10000}
		do
			for species in {$R4IDs_1,$R4IDs_2,$R4IDs_3,$R4IDs_4,$R4IDs_5}
			do
				for testsample in {$sample_1,$sample_3,$sample_4,$sample_5,$sample_6}
				do
					# blastn
					this_test_input=replicates/$which_rep/testdata/spp.$testsample._intensity_.$subsample_tests
					this_db=replicates/$which_rep/training/db_$species._intensity_.$subsample_R4IDs
					echo R4IDs-intensity $subsample_R4IDs	tests-intensity $subsample_tests	DB $this_db	testsample $this_test_input
					blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $this_db -query $this_test_input > replicates/$which_rep/output/sample_.$testsample._intensity.$subsample_tests.-ON-db_.$species.-intensity-.$subsample_R4IDs.out 2>replicates/$which_rep/output/sample_.$testsample._intensity.$subsample_tests.-ON-db_.$species.-intensity-.$subsample_R4IDs.err
				done
			done
		done
	done
	
	rm -r replicates/$which_rep/training
	rm -r replicates/$which_rep/testdata
done

# now evaluate the (many, argh) output results
#r cmd analyse_R4IDs_ROC.r output-#foo-$bar.txt


# Blast DBs (complete)
#
#blast_dbs_complete/spp_5_S-aria.nsq
#blast_dbs_complete/spp_5_S-aria.nhr
#blast_dbs_complete/spp_5_S-aria.nin
#blast_dbs_complete/spp_4_S-uniflora.nsq
#blast_dbs_complete/spp_4_S-uniflora.nhr
#blast_dbs_complete/spp_4_S-uniflora.nin
#blast_dbs_complete/spp_3_E-echinata.nsq
#blast_dbs_complete/spp_3_E-echinata.nhr
#blast_dbs_complete/spp_3_E-echinata.nin
#blast_dbs_complete/spp_2_B-patula.nsq
#blast_dbs_complete/spp_2_B-patula.nhr
#blast_dbs_complete/spp_2_B-patula.nin
#blast_dbs_complete/spp_1_N-alata.nsq
#blast_dbs_complete/spp_1_N-alata.nhr
#blast_dbs_complete/spp_1_N-alata.nin
