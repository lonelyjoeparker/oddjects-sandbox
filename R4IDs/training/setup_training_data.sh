#!/bin/sh

# basic tests
echo 'this is training data' $1 $2
blastn -version

# work with volumes - extra stuff from john/james
# https://github.com/RBGKew/demo-docker-blast/blob/master/blast.sh

if [ -f /input ]
then
  #blastn -query /input -db /db/fish.fa -task blastn -out /output/output
  head /input
elif [ -d /input ]
then
  for file in /input/*;
  do
    filename=$(basename $file)
    #blastn -query $file -db /db/fish.fa -task blastn -out /output/${filename}.out
    head -n 2 $file > /output/${filename}.out
    # do the actual work
    # attempt to create a blast DB from the input
    # if exit 0, add DB path/name to the databases list
    makeblastdb -dbtype nucl -in $file -out /output/DB.${filename}
    echo /output/DB.${filename} >> /output/blast_db.conf
  done
fi