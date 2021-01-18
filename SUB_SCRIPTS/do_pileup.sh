#! /bin/bash

#BSUB -n 5
#BSUB -W 48:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J make_pileup

module load samtools/1.9

samtools mpileup -b ./bam_list \
-f /path/to/reference.fna \
-o /path/to/output.pileup




