# live-ID-by-sequencing
A repo for live identification of unknown samples by MinION-sequenced BLAST comparisonss

## Parker *et al.* (2018, in prep) ID-by-sequencing paper
The paper and this code document the rapid-raw-read-reference for ID ('R4ID') approach. This comprises the following steps:

 - A *training* step, in which samples of known origin are MinION-sequenced, or public references downloaded, and used to create labelled BLASTN databases for ID;
 - A *test* step, in which smaples of unknown origin are MinION-sequenced and compared in real-time to the BLASTN R4ID databases to generate lists of read alignments to the R4ID data;
 - A *visualisation* step, in which the lists of BLAST hits are parsed and displayed as a web GUI over a network connection.