#! /bin/bash

#BSUB -n 1
#BSUB -W 8:00
#BSUB -R "rusage[mem=50GB]"
#BSUB -e error_file%J
#BSUB -J split_meth

module load anaconda3/2019.07

source activate pycometh

python3 scripts/split_meth.py -f ./output/all_region_meth.tsv -l ./bam_slicing/TEST_deletion_readids.txt -o output/all_region