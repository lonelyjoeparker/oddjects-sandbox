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

spp_1_db=blast_dbs_complete/spp_1_N-alata
spp_2_db=blast_dbs_complete/spp_2_B-patula
spp_3_db=blast_dbs_complete/spp_3_E-echinata
spp_4_db=blast_dbs_complete/spp_4_S-uniflora
spp_5_db=blast_dbs_complete/spp_5_S-aria

# test data
sample_1=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_01_basecall_both-runs.poretools.fasta	# TP= N.alata
sample_2=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_02_basecall_both-runs.poretools.fasta	# TP= ? Arabidopsis
sample_3=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_03_basecall_both-runs.poretools.fasta	# TP= S.uniflora
sample_4=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_04_basecall_both-runs.poretools.fasta	# TP= E.echinata
sample_5=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_05_basecall_both-runs.poretools.fasta	# TP= S.aria
sample_6=inputs-test/_Volumes_SCI-FEST-A_sci-fest-data_20160823_sample_06_basecall_both-runs.poretools.fasta	# TP= B.patula

# blast test samples 1 and 2 to see what they are (might be..?)

blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_1_db -query $sample_1 > sample_1-ON-db_1.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_2_db -query $sample_1 > sample_1-ON-db_2.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_3_db -query $sample_1 > sample_1-ON-db_3.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_4_db -query $sample_1 > sample_1-ON-db_4.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_5_db -query $sample_1 > sample_1-ON-db_5.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_1_db -query $sample_2 > sample_2-ON-db_1.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_2_db -query $sample_2 > sample_2-ON-db_2.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_3_db -query $sample_2 > sample_2-ON-db_3.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_4_db -query $sample_2 > sample_2-ON-db_4.out
blastn -outfmt "6 sacc qacc length pident evalue" -evalue 0.01 -num_threads 6 -num_alignments 1 -max_hsps 1 -db $spp_5_db -query $sample_2 > sample_2-ON-db_5.out

# results (number of hits 3 or more digits e.g. 100bp+)

# sample 1
sample_1-ON-db_1.out     208	# Napenthes
sample_1-ON-db_2.out      68	# Beta
sample_1-ON-db_3.out     103	# Erycina
sample_1-ON-db_4.out      98	# Silene
sample_1-ON-db_5.out      45	# Sorbus
# sample 2
sample_2-ON-db_1.out      26	# Napenthes
sample_2-ON-db_2.out      10	# Beta
sample_2-ON-db_3.out      25	# Erycina
sample_2-ON-db_4.out       9	# Silene
sample_2-ON-db_5.out      19	# Sorbus
