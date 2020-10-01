# Basecalling/Assembly/Polishing Pipeline

A [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) workflow for basecalling raw ONT sequencing data, assembling and aligning the data to a reference genome, and polishing the assembly to improve coverage.

Based on the [Nanopolish workflow](https://nanopolish.readthedocs.io/en/latest/quickstart_consensus.html)

## Workflow

1. Sequence raw fast5 files using ONT's Guppy software (Now using GPU version)
2. Run QC on basecalled sample using [PycoQC](https://github.com/a-slide/pycoQC)
3. Index fast5 files with fastq files using [Nanopolish](https://github.com/jts/nanopolish) 
4. (TODO) Create a draft genome assembly using [Canu](https://github.com/marbl/canu)
5. (TODO) Align draft to reference genome using [minimap2](https://github.com/lh3/minimap2) and index bam file using samtools
6. (TODO) Split draft genome into chunks to run consensus algorithm in parallel
7. (TODO) Run consensus algorithm (Nanopolish)
8. (TODO) Convert polished genome to fasta format (Nanopolish)
9. (TODO) Evaluate assembly using [MUMmer](https://github.com/mummer4/mummer)


A work in progress...