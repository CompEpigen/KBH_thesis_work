# Nanopore Data Processing Pipeline

A [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) workflow for taking basecalled fastq files, aligning to a reference genome, indexing, calling methylation, and calling structural variants. 

Running precheck.sh will ensure that all needed packages are installed and on PATH, if not please install and run again

## Workflow

1. Run QC on basecalled sample using [PycoQC](https://github.com/a-slide/pycoQC)
2. Merge fastq files into one ".merged.fastq"
3. Index fast5 files with fastq files using [f5c](https://github.com/hasindu2008/f5c) 
4. Align to reference genome using [NGMLR](https://github.com/philres/ngmlr)
5. Index bam files using samtools
6. Call methylation using [f5c](https://github.com/hasindu2008/f5c) 
7. Convert methylation log-liklihood ratios to frequency values (f5c)
8. Call SVs/SNVs using [Sniffles](https://github.com/fritzsedlazeck/Sniffles)
9. Convert meth_freq.tsv files to bedGraph format for use with [Methrix](https://github.com/CompEpigen/methrix)
