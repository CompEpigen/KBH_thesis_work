#! /bin/bash

#BSUB -n 10
#BSUB -W 48:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J bwa_align

module load samtools/1.9
module load gcc/7.2.0
module load bwa/0.7.15

bwa mem -x ont2d -t 10 /path/to/input/fasta /path/to/merged/fastq | samtools sort -T /path/to/temp/sort/file -o /path/to/final/sorted.bam