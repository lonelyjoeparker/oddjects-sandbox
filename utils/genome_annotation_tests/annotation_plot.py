from dna_features_viewer import BiopythonTranslator
graphic_record = BiopythonTranslator().translate_record("PA01.partial.gff")
graphic_record.first_index=100000
ax, _ = graphic_record.plot(figure_width=10, strand_in_label_threshold=7)
ax.figure.savefig('annotation1.png', bbox_inches='tight')

graphic_record = BiopythonTranslator().translate_record("PA01.partial-2.gff")

# NOTE on usage:
#
# Although the API at https://edinburgh-genome-foundry.github.io/DnaFeaturesViewer/ref.html#graphicrecord
# seems to suggest I could set the gr.first_index and gr.sequence_length params to
# manually zoom in the .gff on the locus of interest, in practice this doesn't work
# or (more likely) I'm implementing it wrongly.
#
# Therefore it turns out to be easier to set the 'region' line in the .gff itself directly
# .e.g
# /home/joe/Downloads/genome_annotation_tests/PA01.partial-2.gff
# AE004091.2	Genbank-custom-region-name	region	1000	44404	.	+	.	ID=AE004091.2:1..6264404;Dbxref=taxon:208964;Is_circular=true;Name=ANONYMOUS;gbkey=Src;genome=chromosome;mol_type=genomic DNA;strain=PAO1
# NB I changed s/Genbank/Genbank-custom-region-name/g above
#
#, first_index=1000, sequence_length=10000
graphic_record.first_index=6000
#graphic_record.sequence_length=10000
#print(graphic_record.first_index)
#print(graphic_record.sequence_length)
ax, _ = graphic_record.plot(figure_width=10, strand_in_label_threshold=7)
ax.figure.savefig('annotation2.png', bbox_inches='tight')


from dna_features_viewer import BiopythonTranslator
graphic_record = BiopythonTranslator().translate_record("partial_focus.gff")
graphic_record.first_index=3524000
ax, _ = graphic_record.plot(figure_width=10, strand_in_label_threshold=7)
ax.figure.savefig('annotation3.png', bbox_inches='tight')
