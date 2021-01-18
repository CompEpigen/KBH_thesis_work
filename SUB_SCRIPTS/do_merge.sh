#! /bin/bash

#BSUB -n 2
#BSUB -W 8:00
#BSUB -R "rusage[mem=5GB]"
#BSUB -e error_file%J
#BSUB -J merge_fastqs

cat /path/to/basecalled/*.fastq > /path/to/output/merged.fastq