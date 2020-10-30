#! /bin/bash

#BSUB -gpu num=1:j_exclusive=yes:mode=exclusive_process:gmem=8G
#BSUB -q gputest
#BSUB -W 48:00
#BSUB -n 10
#BSUB -e error_file%J
#BSUB -J skou3_hac_basecalling

module load cudnn/7.6.1.34/cuda10.0

DATASET_LOCATION=/datasets/datasets_k001y/SKOU3/fast5_files/fast5/
EXPERIMENT_LOCATION=/datasets/datasets_k001y/SKOU3/basecalled/        

tmp_dir=/ssd/k001y/${LSB_JOBID}
echo job is running at $tmp_dir

tmp_dir_data=${tmp_dir}/data # this is where I will store my dataset
mkdir $tmp_dir_data
tmp_dir_exp=${tmp_dir}/exp # here results are stored
mkdir $tmp_dir_exp

rsync -rtu ${DATASET_LOCATION}/ ${tmp_dir_data} # this copies the data to the SSD
rsync -rtu ${EXPERIMENT_LOCATION}/ ${tmp_dir_exp} # this copies (previous) experiment results to the SSD

DATASET_LOCATION_old=$DATASET_LOCATION
DATASET_LOCATION=$tmp_dir_data
export DATASET_LOCATION
EXPERIMENT_LOCATION_old=$EXPERIMENT_LOCATION
EXPERIMENT_LOCATION=$tmp_dir_exp
export EXPERIMENT_LOCATION

guppy_basecaller --input_path $DATASET_LOCATION \
--save_path $EXPERIMENT_LOCATION \
-c /home/k001y/programs/ont-guppy-gpu/data/dna_r9.4.1_450bps_hac.cfg \
--num_callers 10 \
-x auto \
--recursive

rsync -rtu ${EXPERIMENT_LOCATION}/ ${EXPERIMENT_LOCATION_old}

# revert DATASET_LOCATION. Not sure if really needed
DATASET_LOCATION=$DATASET_LOCATION_old
export DATASET_LOCATION
EXPERIMENT_LOCATION=$EXPERIMENT_LOCATION_old
export EXPERIMENT_LOCATION
