# script to generate unholy amounts of pairwise BLASTN data
# from homopolymer-masked ONT reads
# uses a very low e-value threshold (1.0)
# so that ROC curves can be calculated post-hoc

# VERSION:
# Diffs 29/01/2018:
# - Edited hardcoded paths to point to homopolymer-masked (k={2,3,4}; 3 first) blastDBs and inputs
#
# Diffs 15/11/2016:
#	- ONT thaliana reads set to all_R7R9_thaliana.cleaned.filtered.fasta as this has lambda-phage removed
#	- evalue cutoff is 1.0 for a permissive blast search - filtering / ROC plots are the objective here
#	- A. lyrata ssp. petraea sample TP match will be against *combined* (A.lyrata + A.lyrata ssp. petraea) DBs as neither's that great
#	- compareBlastHits.pl will now run later and output all hits e.g incl those hitting 1 or other DB, not just both
#	- num_threads increased from 4 to 8

# Diffs 2017-05-18:
# - Uncommented all the lines below to enable the full analsys to be re-run *IF* the pathnames below have been edited
# to give real files.
#
# Otherwise will exit with the message below..

# Hardcoded variables: will need to be edited!
# NB diffs 2018-01-29: Paths reassigned below...
BLAST_DB_THALIANA=/mnt/HDD_2/joe/REFERENCE-GENOMES/Arabidopsis_thaliana/A_thaliana
BLAST_DB_LYRATA=/mnt/HDD_2/joe/REFERENCE-GENOMES/Arabidopsis_both_ssp_merged/A_lyrata_ssp
READS_ONT_THALIANA=/mnt/HDD_2/joe/WALES-NELUMBOLAB/inputs/all_R7R9_thaliana.cleaned.filtered.fasta
READS_ONT_LYRATA=/mnt/HDD_2/joe/WALES-NELUMBOLAB/inputs/all_R7R9_petraea.fasta
READS_MISEQ_THALIANA=/mnt/HDD_2/joe/WALES-NELUMBOLAB/inputs/AT2a_S2_L001_all.trimmed.fa
READS_MISEQ_LYRATA=/mnt/HDD_2/joe/WALES-NELUMBOLAB/inputs/AL1a_S3_L001_all.trimmed.fa
COMPARE_BLAST=/home/joe/Documents/all_work/programming/repo-git/real-time-phylogenomics/wales_analyses/phylogenome_wales/compareBlastHits.pl
BLAST_OUT=/mnt/HDD_2/joe/WALES-NELUMBOLAB/BLAST_ROC
BLASTN=/usr/bin/blastn
BLAST_PARAMS=" -num_threads 8 -evalue 1.0 -outfmt \"6 qacc length pident evalue\" -max_target_seqs 1  -max_hsps 1 "

if ! test -e "$COMPARE_BLAST"
then
  echo Did not find one or more variables [e.g. path $COMPARE_BLAST].
  echo You MUST edit the hardcoded variables in this script to use it!
  exit 1
fi

ls -l $BLAST_DB_THALIANA	# this will fail as the blast DB path has to be the name roots without *nin *nsq *nhr suffix
ls -l $BLAST_DB_LYRATA	# this will fail as the blast DB path has to be the name roots without *nin *nsq *nhr suffix
ls -l $READS_ONT_THALIANA
ls -l $READS_ONT_LYRATA
ls -l $READS_MISEQ_THALIANA
ls -l $READS_MISEQ_LYRATA
ls -l $COMPARE_BLAST
echo $BLAST_PARAMS

## ORDER of THINGS ##

# 0. Set up homopolymer masked datasets:
# 0a masking
# 0b build blastn DBs

# 1. Blast ONT reads:
#	1a ONT thaliana vs DB thaliana (TP)
#	1b ONT thaliana vs DB lyrata (FP)
#	1c ONT lyrata vs DB thaliana (TP)
#	1d ONT lyrata vs DB lyrata (FP)

# 2. Blast MiSeq reads:
#	2a MiSeq thaliana vs DB thaliana (TP)
#	2b MiSeq thaliana vs DB lyrata (FP)
#	2c MiSeq lyrata vs DB thaliana (TP)
#	2d MiSeq lyrata vs DB lyrata (FP)

# 3. Pairwise comparisons - ONT
#	3a ONT thaliana, TP (thaliana)(1a) vs FP (lyrata)(1b)
#	3b ONT lyrata, TP (lyrata)(1d) vs FP (thaliana)(1c)

# 4. Pairwise comparisons - MiSeq
#	4a MiSeq thaliana, TP (thaliana)(2a) vs FP (lyrata)(2b)
#	4b MiSeq lyrata, TP (lyrata)(2d) vs FP (thaliana)(2c)


## running it ##

# 0. Set up homopolymer masked datasets:
# 0a masking off homopolymers from inputs
# for i in ./inputs/*.f*a*
#   do
#   for m in {3..5}
#     do
#     echo $i $m
#     python ../mask_homopolymers_in_fasta.py $m $i
#     # all_R7R9_petraea.fasta_k=3_masked.fasta
#     done
#     mv ./inputs/*masked* ./k_equals_$m/
#   done

## main bit, loop through for each m={3,4,5} e.g. discard homopolymers longer than 2,3,4 letters
#
for m in {3..5}
do
  echo $m
  # change dir
  cd ./k_equals_$m/

  # assign required filenames
  BLAST_DB_THALIANA=./A_thaliana
  BLAST_DB_LYRATA=./A_lyrata_ssp
  READS_ONT_THALIANA=./all_R7R9_thaliana.cleaned.filtered.fasta*
  READS_ONT_LYRATA=./all_R7R9_petraea.fasta*
  READS_MISEQ_THALIANA=./AT2a_S2_L001_all.trimmed.fa*
  READS_MISEQ_LYRATA=./AL1a_S3_L001_all.trimmed.fa*
  COMPARE_BLAST=/home/joe/Documents/all_work/programming/repo-git/real-time-phylogenomics/wales_analyses/phylogenome_wales/compareBlastHits.pl
  BLAST_OUT='./BLAST_ROC_results'
  mkdir $BLAST_OUT

  # 0b build blastn DBs
  # Arabidopsis_thaliana
  makeblastdb -in 'arabidopsis_thaliana_GCF_000001735.3_TAIR10_genomic.fna_k='$m'_masked.fasta' -dbtype nucl -out A_thaliana
  # A. lyrata ssp. petraea and A. lyrata combined
  makeblastdb -in 'A_lyrata_both_20180129.fa_k='$m'_masked.fasta' -dbtype nucl -out A_lyrata_ssp


  # 1. Blast ONT reads:
  #	1a ONT thaliana vs DB thaliana (TP)
  $BLASTN -db $BLAST_DB_THALIANA -query $READS_ONT_THALIANA  -num_threads 8 -evalue 1.0 -outfmt "6 qacc length pident evalue" -max_target_seqs 1  -max_hsps 1 > $BLAST_OUT/1a_type-pores_db-thaliana_query-thaliana.out
  #	1b ONT tliana vs DB lyrata (FP)
  $BLASTN -db $BLAST_DB_LYRATA -query $READS_ONT_THALIANA  -num_threads 8 -evalue 1.0 -outfmt "6 qacc length pident evalue" -max_target_seqs 1  -max_hsps 1 > $BLAST_OUT/1b_type-pores_db-lyrata_query-thaliana.out
  #	1c ONT lyrata vs DB thaliana (TP)
  $BLASTN -db $BLAST_DB_THALIANA -query $READS_ONT_LYRATA  -num_threads 8 -evalue 1.0 -outfmt "6 qacc length pident evalue" -max_target_seqs 1  -max_hsps 1 > $BLAST_OUT/1c_type-pores_db-thaliana_query-lyrata.out
  #	1d ONT lyrata vs DB lyrata (FP)
  $BLASTN -db $BLAST_DB_LYRATA -query $READS_ONT_LYRATA  -num_threads 8 -evalue 1.0 -outfmt "6 qacc length pident evalue" -max_target_seqs 1  -max_hsps 1 > $BLAST_OUT/1d_type-pores_db-lyrata_query-lyrata.out

  # 2. Blast MiSeq reads:
  #	2a MiSeq thaliana vs DB thaliana (TP)
  $BLASTN -db $BLAST_DB_THALIANA -query $READS_MISEQ_THALIANA  -num_threads 8 -evalue 1.0 -outfmt "6 qacc length pident evalue" -max_target_seqs 1  -max_hsps 1 > $BLAST_OUT/2a_type-miseq_db-thaliana_query-thaliana.out
  #	2b MiSeq thaliana vs DB lyrata (FP)
  $BLASTN -db $BLAST_DB_LYRATA -query $READS_MISEQ_THALIANA  -num_threads 8 -evalue 1.0 -outfmt "6 qacc length pident evalue" -max_target_seqs 1  -max_hsps 1 > $BLAST_OUT/2b_type-miseq_db-lyrata_query-thaliana.out
  #	2c MiSeq lyrata vs DB thaliana (TP)
  $BLASTN -db $BLAST_DB_THALIANA -query $READS_MISEQ_LYRATA  -num_threads 8 -evalue 1.0 -outfmt "6 qacc length pident evalue" -max_target_seqs 1  -max_hsps 1 > $BLAST_OUT/2c_type-miseq_db-thaliana_query-lyrata.out
  #	2d MiSeq lyrata vs DB lyrata (FP)
  $BLASTN -db $BLAST_DB_LYRATA -query $READS_MISEQ_LYRATA  -num_threads 8 -evalue 1.0 -outfmt "6 qacc length pident evalue" -max_target_seqs 1  -max_hsps 1 > $BLAST_OUT/2d_type-miseq_db-lyrata_query-lyrata.out

  # 3. Pairwise comparisons - ONT
  #	3a ONT thaliana, TP (thaliana)(1a) vs FP (lyrata)(1b)
  $COMPARE_BLAST $BLAST_OUT/1a_type-pores_db-thaliana_query-thaliana.out $BLAST_OUT/1b_type-pores_db-lyrata_query-thaliana.out > $BLAST_OUT/pairwise_type-pores_tp-thaliana_fp-lyrata.out 2> $BLAST_OUT/pairwise_type-pores_tp-thaliana_fp-lyrata.out.summary
  #	3b ONT lyrata, TP (lyrata)(1d) vs FP (thaliana)(1c)
  $COMPARE_BLAST $BLAST_OUT/1d_type-pores_db-lyrata_query-lyrata.out $BLAST_OUT/1c_type-pores_db-thaliana_query-lyrata.out > $BLAST_OUT/pairwise_type-pores_tp-lyrata_fp-thaliana.out 2> $BLAST_OUT/pairwise_type-pores_tp-lyrata_fp-thaliana.out.summary

  # 4. Pairwise comparisons - MiSeq
  #	4a MiSeq thaliana, TP (thaliana)(2a) vs FP (lyrata)(2b)
  $COMPARE_BLAST $BLAST_OUT/2a_type-miseq_db-thaliana_query-thaliana.out $BLAST_OUT/2b_type-miseq_db-lyrata_query-thaliana.out > $BLAST_OUT/pairwise_type-miseq_tp-thaliana_fp-lyrata.out 2> $BLAST_OUT/pairwise_type-miseq_tp-thaliana_fp-lyrata.out.summary
  #	4b MiSeq lyrata, TP (lyrata)(2d) vs FP (thaliana)(2c)
  $COMPARE_BLAST $BLAST_OUT/2d_type-miseq_db-lyrata_query-lyrata.out $BLAST_OUT/2c_type-miseq_db-thaliana_query-lyrata.out > $BLAST_OUT/pairwise_type-miseq_tp-lyrata_fp-thaliana.out 2> $BLAST_OUT/pairwise_type-miseq_tp-lyrata_fp-thaliana.out.summary

  # cd back up to ./pairwise_blastn_ROC
  cd ..
done
