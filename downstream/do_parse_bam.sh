#! /bin/bash

#BSUB -n 3
#BSUB -W 8:00
#BSUB -R "rusage[mem=15GB]"
#BSUB -e error_file%J
#BSUB -J find_661_clipped

module load samtools/1.9
module load anaconda3/2019.07
source activate master-env

#python3 parse_bam.py -b PDX661.chr7.bam -o ./TEST_chr7

samtools sort PDX661_hg38_ngmlr_1000bp_clipped.bam -o PDX661_hg38_ngmlr_1000bp_clipped.sorted.bam

samtools index PDX661_hg38_ngmlr_1000bp_clipped.sorted.bam