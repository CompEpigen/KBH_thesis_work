#! /bin/bash

#BSUB -n 10
#BSUB -W 120:00
#BSUB -R "rusage[mem=15GB]"
#BSUB -e error_file%J
#BSUB -J minimap2_align

module load samtools/1.9

minimap2 -t 10 -ax map-ont /path/to/reference/fasta/file.fasta /path/to/merged/file.fastq | samtools sort -T /path/for/temp/alginment/files -o /path/to/final/aligned/sorted.bam
