#! /bin/bash

#BSUB -gpu num=1:j_exclusive=yes:mode=exclusive_process:gmem=15G
#BSUB -q gputest
#BSUB -W 48:00
#BSUB -n 10
#BSUB -e error_file%J
#BSUB -J gpu_basecalling

module load cudnn/7.6.1.34/cuda10.0

guppy_basecaller --input_path /gpu/data/path/to/fast5/ \
--save_path /gpu/checkpoints/path/to/save/ \
-c /home/k001y/programs/ont-guppy-gpu/data/dna_r9.4.1_450bps_hac.cfg \ #Config file to use with basecalling
--num_callers 10 \
-x auto \
--recursive #Recursively look through input_path directory for fast5 files
