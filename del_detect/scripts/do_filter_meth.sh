#! /bin/bash

#BSUB -n 1
#BSUB -W 8:00
#BSUB -R "rusage[mem=100GB]"
#BSUB -e error_file%J
#BSUB -J filter_meth

module load anaconda3/2019.07

source activate pycometh

python3 scripts/filter_meth.py -f ./data/all_merged_meth.tsv -b ./bam_slicing/all_del_merged.bam -o ./output/all_region_meth.tsv