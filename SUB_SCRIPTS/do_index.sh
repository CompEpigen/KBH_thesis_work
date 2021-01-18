#! /bin/bash

#BSUB -n 3
#BSUB -W 8:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J index_bam

module load samtools/1.9

samtools index /path/to/sorted.bam
