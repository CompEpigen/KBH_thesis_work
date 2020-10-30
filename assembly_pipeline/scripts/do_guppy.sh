#! /bin/bash

#BSUB -n 20
#BSUB -W 48:00
#BSUB -R "rusage[mem=10GB]"
#BSUB -e error_file%J
#BSUB -J guppy_fast_config_test

guppy_basecaller --input_path /icgc/dkfzlsdf/analysis/C010/brooks/assembly_pipeline/data/guppy \
--save_path /icgc/dkfzlsdf/analysis/C010/brooks/assembly_pipeline/testing/fastq \
-c /home/k001y/programs/ont-guppy-cpu/data/dna_r9.4.1_450bps_fast.cfg \
--num_callers 20 


