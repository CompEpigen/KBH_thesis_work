# Methylation Calling Workflow

A [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) script for calling methylation from Oxford Nanopore long-read sequencing data. Relies on:
 * [NGMLR](https://github.com/philres/ngmlr) (Subject to change, might switch to minimap2)
 * [f5c](https://github.com/hasindu2008/f5c)

## Workflow

1. Merge all fastq files belonging to a sample
2. Index fastq files with respective fast5 files using f5c's `index` function
3. Align merged fastq file to reference genome using NGMLR (might change to minimap2)
4. Index bam files from step 3 (`samtools index`)
5. Call methylation using `f5c call-methylation` function
6. Calculate methylation frequency from output of step 5 using `f5c meth-freq` function 

A work in progress...