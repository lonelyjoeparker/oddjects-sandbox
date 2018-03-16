pwd
echo 'trigger resequencing run'
echo 'list input dir'
ls -l /input_resequencing
echo 'list input arg probably'
ls -l /input_resequencing/$1
echo 'list db'
ls -l /blast_db
echo 'list output arg'
ls -l $2
echo 'list output dir'
ls -l /output_web
echo 'whats in the conf file?'
for db in $(cat /blast_db/blast_db.conf)
do
db_name_only=$(basename $db)
echo 'blast conf line DB ' $db
echo "blast command::: blastn -db $db -query /input_resequencing/$1 -num_alignments 1 -outfmt '6 sacc qacc length pidents evalue' >/output_web/results.blast.$i.out"
blastn -db $db -query /input_resequencing/$1 -num_alignments 1 -outfmt "6 qacc length pident evalue" | /app/sum_blast.pl - > /output_web/agg.blasts.$db_name_only
done
# cat the outputs to web output
cat /output_web/agg.blasts* >> /output_web/data.tdf

