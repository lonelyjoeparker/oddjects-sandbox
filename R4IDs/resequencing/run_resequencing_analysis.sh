# pwd
# echo 'trigger resequencing run'
# echo 'list input dir'
# ls -l /input_resequencing
# echo 'list input arg probably'
# ls -l /input_resequencing/$1
# echo 'list db'
# ls -l /blast_db
# echo 'list output arg'
# ls -l $2
 echo 'list output dir'
 ls -l /output_web
# echo 'whats in the conf file?'

echo new read: /input_resequencing/$1
# first blast the new file
for db in $(cat /blast_db/blast_db.conf)
do
	# filename parsing
	db_name_only=$(basename $db)
	echo 'blast conf line DB ' $db
	echo "blast command::: blastn -db $db -query /input_resequencing/$1 -num_alignments 1 -outfmt 6 qacc length pident evalue | cat - /app/all.blasts.$db_name_only > /app/tmp.blasts.$db_name_only"
	
	# test to see if there are existing outputs
	if [ -e /app/all.blasts.$db_name_only ]
	then
		# existing outputs already, we'll need to concat
		
		# blastn the new read, cat output with existing to tmp file
		blastn -db $db -query /input_resequencing/$1 -num_alignments 1 -outfmt "6 qacc length pident evalue" | cat - /app/all.blasts.$db_name_only > /app/tmp.blasts.$db_name_only
		# copy tmp to output
		cp /app/tmp.blasts.$db_name_only /app/all.blasts.$db_name_only
	else
		# no exising outputs, write blast output straight to output
		blastn -db $db -query /input_resequencing/$1 -num_alignments 1 -outfmt "6 qacc length pident evalue" > /app/all.blasts.$db_name_only 
	fi
	# summarise outputs
	cat /app/all.blasts.$db_name_only | /app/sum_blast.pl - > /output_web/agg.blasts.$db_name_only
done

# stats
total_reads=$(grep '>' /input_resequencing/*fasta | wc -l)
total_letters=$(grep -v '>' /input_resequencing/*fasta | wc -m)
echo 'total reads' $total_reads
echo 'total letters' $total_letters

# update the server html with the data.tdf
sed s/XXtemplateReads/$total_reads/ /output_web/template.html | sed s/XXtemplateLetters/$total_letters/ - > /output_web/KSF.html
# cat the outputs to web output

echo `date` | cat - /output_web/agg.blasts* >> /output_web/data.tdf

