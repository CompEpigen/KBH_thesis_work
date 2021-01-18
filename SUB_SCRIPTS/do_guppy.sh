#! /bin/bash

#BSUB -n 20
#BSUB -W 48:00
#BSUB -R "rusage[mem=10GB]"
#BSUB -e error_file%J
#BSUB -J guppy

guppy_basecaller --input_path /path/to/raw/fast5/folder/ \
--save_path /path/to/folder/to/save/fastqs/ \
-c /home/k001y/programs/ont-guppy-cpu/data/dna_r9.4.1_450bps_fast.cfg \ #basecalling config file
--num_callers 20 


