#! /bin/bash

#BSUB -n 3
#BSUB -W 10:00
#BSUB -R "rusage[mem=10GB]"
#BSUB -e error_file%J
#BSUB -J gzip

#Setting location of ONT raw reads
LONG_READ=/path/to/files

gzip ${LONG_READ}/merged.fastq