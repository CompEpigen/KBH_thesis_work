# "Master" Pipeline

A [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) workflow for taking basecalled fastq files, aligning to a reference genome, indexing, calling methylation, and calling structural variants. 

## Workflow

1. Run QC on basecalled sample using [PycoQC](https://github.com/a-slide/pycoQC)
2. Merge fastq files into one ".merged.fastq"
3. Index fast5 files with fastq files using [f5c](https://github.com/hasindu2008/f5c) 
4. Align to reference genome using [minimap2](https://github.com/lh3/minimap2)
5. Index bam files using samtools
6. Call methylation using [f5c](https://github.com/hasindu2008/f5c) 
7. Convert methylation log-liklihood ratios to frequency values (f5c)
8. Call SVs/SNVs using [CuteSV](https://github.com/tjiangHIT/cuteSV)


A work in progress...