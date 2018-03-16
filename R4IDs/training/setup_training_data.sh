#!/bin/sh

# basic tests
echo 'this is training data' $1 $2
blastn -version

# work with volumes - extra stuff from john/james
# https://github.com/RBGKew/demo-docker-blast/blob/master/blast.sh

if [ -f /input_training ]
then
  #blastn -query /input -db /db/fish.fa -task blastn -out /output/output
  head /input
elif [ -d /input_training ]
then
  for file in /input_training/*;
  do
    #filename=$(basename $file)
    filename=$(basename "${file%.*}")
    #blastn -query $file -db /db/fish.fa -task blastn -out /output/${filename}.out
    head -n 2 $file > /blast_db/${filename}.out
    # do the actual work
    # attempt to create a blast DB from the input
    # if exit 0, add DB path/name to the databases list
    makeblastdb -dbtype nucl -in $file -out /blast_db/DB.${filename}.DB
    echo /blast_db/DB.${filename}.DB >> /blast_db/blast_db.conf
  done
fi