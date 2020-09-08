# Basecalling/Assembly/Polishing Pipeline

A [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) workflow for basecalling raw ONT sequencing data, assembling and aligning the data to a reference genome, and polishing the assembly to improve coverage.

Based on the [Nanopolish workflow](https://nanopolish.readthedocs.io/en/latest/quickstart_consensus.html)

## Steps

1. Sequence raw fast5 files using ONT's Guppy software
2. Run QC on basecalled sample using [PycoQC](https://github.com/a-slide/pycoQC)
3. Index fast5 files with fastq files using [Nanopolish](https://github.com/jts/nanopolish) 
4. Create a draft genome assembly using [Canu](https://github.com/marbl/canu)
5. Align draft to reference genome using [minimap2](https://github.com/lh3/minimap2) and index bam file using samtools
6. Split draft genome into chunks to run consensus algorithm in parallel
7. Run consensus algorithm (Nanopolish)
8. Convert polished genome to fasta format (Nanopolish)
9. Evaluate assembly using [MUMmer](https://github.com/mummer4/mummer)


A work in progress...