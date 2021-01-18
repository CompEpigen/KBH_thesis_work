#! /bin/bash

#BSUB -n 20
#BSUB -W 48:00
#BSUB -R "rusage[mem=120GB]"
#BSUB -e error_file%J
#BSUB -J flye_assembly

module load anaconda3/2019.07
source activate flye-env

flye --nano-raw /path/to/merged/fastq \
--out-dir /path/to/output/dir \
--threads 20
