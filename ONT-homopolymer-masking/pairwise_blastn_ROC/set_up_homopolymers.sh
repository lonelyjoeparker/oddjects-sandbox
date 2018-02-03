for i in ./inputs/*.f*a*
  do
	for m in {3..5}
    	do
	echo $i $m
 	python ../mask_homopolymers_in_fasta.py $m $i 
 	done

    mv ./inputs/*masked* ./k_equals_$m  
  done

