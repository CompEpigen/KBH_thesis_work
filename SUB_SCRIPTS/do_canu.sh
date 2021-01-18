#! /bin/bash

#BSUB -n 10
#BSUB -W 48:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J canu

canu \
-p sample_prefix \
-d output/sample_draft/ \
genomeSize=1g \
-nanopore output/sample_fastq_file.fastq

