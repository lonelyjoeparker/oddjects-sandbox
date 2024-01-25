#!/usr/bin/env bash
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

# the input file
test_input_readsfile=/media/joe/PI-CLUSTER-/ecDNA_summer_2019/bwa_align/bwa_PA01-3day.coverage.tdf

# run the input file
Rscript cli_single_coverage_plotter.R $test_input_readsfile
