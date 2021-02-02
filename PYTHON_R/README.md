# Python and R scripts

Python and R code from the project. For a detailed description of parse_bam.py please see the relevant section below. 

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
 * parse_bam.py: Parse BAM file for multi-alignment and soft-clipped reads (Very important) (See below for more information)
 * plot_alignment_corr.R: Used in tandem with alignment_correlation.py to plot MAPQ scores (not used in thesis)
 * plot_del7q_meth.R: Deprecated script used to plot del7q+INV methylation in PDX661
 * plot_tracks.R: Deprecated script utilizes Gviz to plot multiple different tracks in one nice figure
 * plots_for_report.R: R script that was directly used to create all user-generated plots for the thesis
 * split_bam.py: Split reads in BAM file based on prescence of deletion (originally part of del_detect workflow, replaced by the better parse_bam.py)
 * split_clean_meth.py: subset methylation calls tsv by BAM read ID & clean/format for PycoMeth (originally part of del_detect workflow)
 * split_meth.py: subset methylation calls tsv by BAM read ID (originally part of del_detect workflow)

## parse_bam.py details ##

This python script was used in KBH's thesis project to identify split/chimeric reads that spanned large SVs/deletions in both ckAML and GCTB.

It is designed to take some of the strain off of the user by reducing the need to manually find these split/chimeric reads using IGV or other genome visualizers. 

Given a bam file, parse_bam.py will identify split/chimeric reads based on the read's [flags](https://broadinstitute.github.io/picard/explain-flags.html) and the prescence of soft-clipping. It will then return a bam file with just these reads, a bedpe file, and (optionally) a methylation tsv file. (see How it works and Full list of options for more information)

### Requirements for running ###

parse_bam.py can be run in a conda virtual environment created using the master_env.yaml file. 

Currently, parse_bam.py only supports bam files created using [NGMLR](https://github.com/philres/ngmlr). These bam files must additionally have an index file (.bai) in the same location. 

Optional methylation data is currently only supported from [f5c](https://github.com/hasindu2008/f5c). From f5c, the user may provide the "meth_calls.tsv" file that is output by the program. Ensure that the file has the following columns/format:

```
chromosome	start	end	read_name	log_lik_ratio	log_lik_methylated	log_lik_unmethylated	num_calling_strands	num_cpgs	sequence
```

### How it works ###

parse_bam.py leverages [cigar](https://pypi.org/project/cigar/) and [pysam](https://pysam.readthedocs.io/en/latest/) to extract information on a read-level basis for all reads in a bam file. It will then identify reads matching either the default or user-provided criteria and return a bam file with those reads, a [bedpe](https://bedtools.readthedocs.io/en/latest/content/general-usage.html#bedpe-format) file, and optionally a methylation tsv file with methylation covering the reads identified. 

Steps:

1. Read in bam file and extract the read ID, flags, and CIGAR string. Immediately select only reads that match the flags (either user-provided or default)
2. Parse the CIGAR string for right or left soft-clipping, select only those reads that have soft-clips larger than a certain size (default 1000bp)
3. Based on the reads left after steps 1 & 2, subset the original bam file for those reads using the unique read IDs, save this new bam file to the user-provided directory with the user-provided prefix
4. From the reads above, identify which ones map to exactly 2 unique spots in the genome, and create/save a .bedpe file with the chromosomes and coordinates of these reads. 
5. If the bam file uses alternative chromosome names (i.e. NC_000001.11, etc.), convert these in the bedpe file to human-readable format (i.e. chr1, etc.)
5. (Optional) If the user has provided a meth_calls.tsv file, it will be filtered for only those calls made on reads present in step 3, and saved as a new meth_calls.tsv file. 

### Full list of options ###

```
usage: parse_bam.py [-h] [-b BAM] [-c CLIP_SIZE_THRESH] [-o OUTPUT] [-f FLAG]
                    [-s SPLITS] [-a ALT_CHROMS] [-m METH]

Parse BAM file for multi-alignment and soft-clipped reads. Will return a BAM
file containing split reads and a BEDPE file containing the coordinates of the
split reads (useful for circos plots, etc.). Can additionally return a
filtered methylation TSV file if one is provided (optional)

optional arguments:
  -h, --help            show this help message and exit

Required:
  Bam, clip size to filter on, output location, flags to filter on, splits
  to filter on, and True/False if alternative chromosomes were used

  -b BAM, --bam BAM     bam file - must be created with NGMLR
  -c CLIP_SIZE_THRESH, --clip_size_thresh CLIP_SIZE_THRESH
                        soft clip size threshold to filter on [1000]
  -o OUTPUT, --output OUTPUT
                        output location and prefix
  -f FLAG, --flag FLAG  flag(s) to filter bam file on. delimited list, default
                        256,2046,2304
  -s SPLITS, --splits SPLITS
                        Number of splits read aligns to filter on for bedpe
                        file (2 only option right now, hope to change in the
                        future)[2]
  -a ALT_CHROMS, --alt_chroms ALT_CHROMS
                        Does BAM file use alternative chromosome names? (i.e.
                        NC_000001.11, etc.) [False]

Optional:
  methylation call tsv file (from f5c)

  -m METH, --meth METH  Methylation calls tsv file to filter (from f5c)

```

### Limitations ###

While parse_bam.py was useful in this project, it is not without limitations that the user should be aware of.

* Currently, there is no way to select a region of interest in the intial input bam file, and the script will run on the entire bam file. This can be worked-around by pre-subsetting the bam file using [samtools view](https://www.htslib.org/doc/samtools-view.html)
* parse_bam.py has only been used/tested with the default flags (256,2046,2304), and there is no guarentee that the script will behave the same or even work with other flags. Theoretically it should work with any flags, and at the very least would give a bam file filtered for flags of interest (however the bedpe file would likely be broken)
* There is no guarentee that the reads identified are truly chimeric reads, as the script takes a very literal approach to finding them. Always confirm reads of interest using other methods (IGV, Ribbon, etc.)! 


 

 