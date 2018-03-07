# bash script to simulate

# do the subsampling and test
for reps in [1:30]
do
	for subsample_R4IDs in [100,500,1000,5000,10000]
	do
		for subsample_query in [100,500,1000,5000,10000]
		do
			for species in [1:6]
			do
				# the subsampling
				simulate_partial_reads.py R4IDs_$species subsample_R4IDs > simulated_training/$species
				simulate_partial_reads.py input_$species subsample_query > simulated_test/$species
			done
			# the test
			docker run training simulated_training
			docker run test simulated_test > output-$subsample_R4IDs-$subsample_query-$reps
		done
	done
done

# now evaluate the (many, argh) output results
r cmd analyse_R4IDs_ROC.r output-#foo-$bar.txt


