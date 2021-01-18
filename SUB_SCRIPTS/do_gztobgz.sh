#! /bin/bash

#BSUB -n 2
#BSUB -W 48:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J gz_to_bgz

module load htslib/1.3.2 

zcat /path/to/file.fasta.gz | bgzip -c > /path/to/output/file.fasta.bgz
