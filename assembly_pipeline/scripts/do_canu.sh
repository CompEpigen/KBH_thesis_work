#! /bin/bash

#BSUB -n 10
#BSUB -W 48:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J pdx661_canu

canu \
-p PDX661 \
-d output/PDX661_draft/ \
genomeSize=1g \
-nanopore output/PDX661.merged.fastq

