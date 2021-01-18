#! /bin/bash

#BSUB -n 2
#BSUB -W 8:00
#BSUB -R "rusage[mem=5GB]"
#BSUB -e error_file%J
#BSUB -J QC

module load anaconda3/2019.07
source activate master-env

pycoQC -f /path/to/sequencing_summary.txt -o /path/to/output/pycoQC_output.html
