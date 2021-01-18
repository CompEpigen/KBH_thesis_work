#! /bin/bash

#BSUB -n 10
#BSUB -W 120:00
#BSUB -R "rusage[mem=15GB]"
#BSUB -e error_file%J
#BSUB -J ngmlr_align

module load samtools/1.9

ngmlr -t 10 -r /path/to/ref.fasta -q /path/to/input.fastq -x ont | samtools sort > /path/to/output/sorted.bam
samtools index /path/to/output/sorted.bam
