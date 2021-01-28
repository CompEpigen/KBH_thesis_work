# Python and R scripts

Python and R code from the project

For help email: k.henry@dkfz-heidelberg.de or brookshenry3@gmail.com

## Description of files:

 * alignment_correlation.py: Extract read name, mapped chromosome name, and mapping quality from BAM file
 * bam_slicer.sh: Shell script to extract a region of interest from a BAM file (from Pavlo)
 * bam_to_fasta.py: convert bam file to fasta file
 * bin_and_viz_ROI.R: Plot mean methylation in telomeres and centromeres using Nanopore-derived methylation data. It will automatically determine which, if any, of these regions have methylation and will then generate plots
 * change_meth_tsv.py: Reformat methylation chromosomes from alternative format (i.e. "NC_000001.11") to human-readable format (i.e. "chr1")
 * extract_reads.py: Parse bam file for reads that come from possible telomeric fusions, required fusion read ID list (create using IGV, etc.)
 * fasta_manipulation.R: R script used to generate a Telomeric fusion reference fasta file from the CHM13 genome
 * filter_meth_by_readid.py: subset methylation calls tsv by read ID
 * filter_meth.py: Same as above (duplicate)
 * find_telomere_meth.py: subset methylation calls tsv for telomeric methylation
 * parse_assembly_info.py: Find circular DNA sequences from Flye assembly info
 * parse_bam.py: Parse BAM file for multi-alignment and soft-clipped reads (Very important)
 * plot_alignment_corr.R: Used in tandem with alignment_correlation.py to plot MAPQ scores (not used in thesis)
 * plot_del7q_meth.R: Deprecated script used to plot del7q+INV methylation in PDX661
 * plot_tracks.R: Deprecated script utilizes Gviz to plot multiple different tracks in one nice figure
 * plots_for_report.R: R script that was directly used to create all user-generated plots for the thesis
 * split_bam.py: Split reads in BAM file based on prescence of deletion (originally part of del_detect workflow, replaced by the better parse_bam.py)
 * split_clean_meth.py: subset methylation calls tsv by BAM read ID & clean/format for PycoMeth (originally part of del_detect workflow)
 * split_meth.py: subset methylation calls tsv by BAM read ID (originally part of del_detect workflow)

 

 