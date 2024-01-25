# Using minimap2 and dotPlotly to plot genome alignments as dotplots to compare assemblies

 - Joe Parker
 - 2024-01-16

 ## Genome alignment with minimap2

 - Location: nbic-genomics-ricebowl
 - Program: minimap2 2.17-r941
 - output locations are `/srv/ecDNA_paper_analyses/10_plotting_pretty/genome_dotplots` and `/srv/project-scratch/webb_group_resequencing/dotplots/`.

```
/srv/ecDNA_paper_analyses/10_plotting_pretty/genome_dotplots
minimap2 -x map-ont -t 16 /research/nbicgenomics/projects/ecDNA/ecDNA_collated/UNSW_dpf4/assemblies/UNSW_WT.fasta /research/nbicgenomics/projects/ecDNA/ecDNA_collated/UNSW_dpf4/assemblies/UNSW_pf4/assembly.fasta > ./UNSW_WT-vs-UNSW_dPf4KO_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/projects/ecDNA/ecDNA_collated_conor_final/UNSW_dpf4/assemblies/UNSW_WT.fasta /research/nbicgenomics/projects/ecDNA/ecDNA_collated_conor_final/UNSW_dpf4/assemblies/UNSW_pf4/assembly.fasta > ./UNSW_WT-vs-UNSW_dPf4KO_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/projects/ecDNA/ecDNA_collated_conor_final/assemblies/UNSW_WT.fasta /research/nbicgenomics/projects/ecDNA/ecDNA_collated_conor_final/assemblies/UNSW_pf4/assembly.fasta > ./UNSW_WT-vs-UNSW_dPf4KO_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/projects/ecDNA/ecDNA_collated_conor_final/assemblies/UNSW_WT.fasta /research/nbicgenomics/seq_dbs/reference_genomes/Pseudomonas_aeruginosa_MPAO1_revised.fasta > ./UNSW_WT-vs-MPA01_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/projects/ecDNA/ecDNA_collated_conor_final/assemblies/UNSW_WT.fasta /research/nbicgenomics/seq_dbs/reference_genomes/GCA_000006765.1_ASM676v1_genomic.fna > ./UNSW_WT-vs-PA01_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/seq_dbs/reference_genomes/Pseudomonas_aeruginosa_MPAO1_revised.fasta /research/nbicgenomics/seq_dbs/reference_genomes/GCA_000006765.1_ASM676v1_genomic.fna > ./PA01-vs-MPA01_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/seq_dbs/reference_genomes/GCA_000006765.1_ASM676v1_genomic.fna /research/nbicgenomics/projects/ecDNA/ecDNA_collated_conor_final/assemblies/UNSW_pf4/assembly.fasta > ./PA01-vs-UNSW_dPf4KO_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/seq_dbs/reference_genomes/Pseudomonas_aeruginosa_MPAO1_revised.fasta /research/nbicgenomics/projects/ecDNA/ecDNA_collated_conor_final/assemblies/UNSW_pf4/assembly.fasta > ./MPA01-vs-UNSW_dPf4KO_minimap.paf

# Webb group resequencing genomes (not all of them):

cd /srv/project-scratch/webb_group_resequencing/dotplots/
minimap2 -x map-ont -t 16 /research/nbicgenomics/projects/resequencing_project/assembly_pipeline_output/process_batch_01_02/ANT_PA66/ANT_PA66-genome/assembly.fasta /research/nbicgenomics/projects/resequencing_project/assembly_pipeline_output/process_batch_01_02/ANT_PA47/ANT_PA47-genome/assembly.fasta > ../ANT_PA66-vs-ANT_PA47_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/projects/resequencing_project/assembly_pipeline_output/process_batch_01_02/ANT_PA66/ANT_PA66-genome/assembly.fasta /research/nbicgenomics/projects/resequencing_project/assembly_pipeline_output/process_batch_01_02/ANT_PA146/ANT_PA146-genome/assembly.fasta > ./ANT_PA66-vs-ANT_PA146_minimap.paf

minimap2 -x map-ont -t 16 /research/nbicgenomics/projects/resequencing_project/assembly_pipeline_output/process_batch_01_02/ANT_PA47/ANT_PA47-genome/assembly.fasta /research/nbicgenomics/projects/resequencing_project/assembly_pipeline_output/process_batch_01_02/ANT_PA146/ANT_PA146-genome/assembly.fasta > ./ANT_PA47-vs-ANT_PA146_minimap.paf
```

 ## Plotting as dotplots with dotPlotly

  - Location: desktop, Schaumack
  - Program: dotPlotly e.g. https://github.com/tpoorten/dotPlotly
  - NB I actually ended up fixing issue 18 in my own fork, so the version to be used is actually at /home/joe/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R
  - I added switches to enable .pdf output, as this is easier to phaff about with on illustrator etc for papers.

### Plot (incluiding .pdf) the ecDNA alignments
```
cd ecDNA

# UNSW, wt strain versus dPf4 KO mutant
~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i UNSW_WT-vs-UNSW_dPf4KO_minimap.paf -o UNSW_wt-vs-UNSW_dPf4KO.minimap2.plot -m 2000 -q 500000 -k 10  -t -l -p 12 --pdf-plot-on

# UNSW WT vs MPA01
~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i UNSW_WT-vs-MPA01_minimap.paf -o UNSW_WT-vs-MPA01.minimap2.plot -m 2000 -q 500000 -k 10  -t -l -p 12 --pdf-plot-on

# UNSW WT vs PA01
~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i UNSW_WT-vs-PA01_minimap.paf -o UNSW_WT-vs-PA01_minimap.paf -m 2000 -q 500000 -k 10  -t -l -p 12 --pdf-plot-on

# PA01 vs MPA01
~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i PA01-vs-MPA01_minimap.paf -o PA01-vs-MPA01_minimap.plot -m 2000 -q 500000 -k 10  -t -l -p 12 --pdf-plot-on

# PA01 vs UNSW_dPf4KO mutant

~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i PA01-vs-UNSW_dPf4KO_minimap.paf -o PA01-vs-UNSW_dPf4KO_minimap.plot -m 2000 -q 500000 -k 10  -t -l -p 12 --pdf-plot-on

# MPA01 vs UNSW UNSW_dPf4KO mutant

~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i MPA01-vs-UNSW_dPf4KO_minimap.paf -o MPA01-vs-UNSW_dPf4KO_minimap.plot -m 2000 -q 500000 -k 10  -t -l -p 12 --pdf-plot-on

# upload the plots to ricebowl
scp ./*.p* jp1e18@nbic-genomics-ricebowl.soton.ac.uk://srv/ecDNA_paper_analyses/10_plotting_pretty/genome_dotplots/

```

## Plotting a selection of the Webb group
```
cd ../webb_group_resequencing
~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i ANT_PA66-vs-ANT_PA47_minimap.paf -o ANT_PA66-vs-ANT_PA47_minimap.plot  -m 2000 -q 500000 -k 10  -t -l -p 1
~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i ANT_PA66-vs-ANT_PA146_minimap.paf -o ANT_PA66-vs-ANT_PA146_minimap.plot  -m 2000 -q 500000 -k 10  -t -l -p 12
~/Documents/all_work/programming/repo-git/dotPlotly-issue-18/pafCoordsDotPlotly.R -i ANT_PA47-vs-ANT_PA146_minimap.paf -o ANT_PA47-vs-ANT_PA146_minimap.plot  -m 2000 -q 500000 -k 10  -t -l -p 12
```
