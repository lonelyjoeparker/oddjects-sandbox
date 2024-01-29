#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test harness for cli_single_coverage_plotter.R
# joe parker @lonelyjoeparker
# 2024-01-25
#
# Description: the single line plotter should, given a .tdf
# corresponding to a genome read depth file (produced e.g.
# by `samtools depth -a <some.sorted.bamfile.bam>`), produce
# a single .png image of a line plot of aligned read depth
# versus genome position (e.g a coverage / bias plot) using
# R.

# set up input variable
input_coverage_file = ''
# echo out arguments and exit
if (length(args) == 1){
  print(args[1])
  input_coverage_file = args[1]
}
output_image_file = paste(input_coverage_file,'.png',sep='')
print(output_image_file)

# read in and name dataset 1
# testing MPA01_guppy_D13 = read.table("/media/joe/PI-CLUSTER-/ecDNA_summer_2019/guppy-d13-ecDNA-realign/all_PA01-day13-ecDNA.sorted.bam.coverage.tdf",header=F,sep="\t")
MPA01_guppy_D13 = read.table(input_coverage_file,header=F,sep="\t")
names(MPA01_guppy_D13) = c('contig','pos',input_coverage_file)

# read in and name dataset 2
#MPA01_bwa_D3 = read.table("/media/joe/PI-CLUSTER-/ecDNA_summer_2019/bwa_align/bwa_PA01-3day.coverage.tdf",header=F,sep="\t")
#names(MPA01_bwa_D3) = c('contig','pos','MPA01_bwa_D3')
# quick filter on contig as there's two in this file and we don't want the RGP42 one
#MPA01_bwa_D3.filter = MPA01_bwa_D3[MPA01_bwa_D3$contig=="NC_002516.2",]

# collate two or more sets together. we don't need this
# source(file="plotting_collate_data.R")
# dataset_collated = bias_collate(MPA01_guppy_D13, MPA01_bwa_D3.filter)

# downsample the number of points so manageable
source(file="plotting_downsample.R")
downsample_factor = 1000
dataset_downsampled = bias_downsample(MPA01_guppy_D13, downsample_factor)

# # plot whole genome, with R
source(file="plotting_ggplot_plots.R")
# start = 000000
# length = 6200000
# bias_plot(dataset_downsampled, start, length)
# 
# # plot zoomed in bit, with base R
# start = 5000000
# length = 500000
# bias_plot(dataset_downsampled, start, length)
# 
# # uses ggplot2
# start = 000000
# length = 6200000
# source(file="plotting_ggplot_plots.R")
# bias_ggplot(dataset_downsampled, start, length)

# uses ggplot2, simple version saving to filename only
bias_ggplot_simple(dataset_downsampled, output_image_file)

# now test the suppress-plot behaviour

