#! /bin/bash

#BSUB -n 10
#BSUB -W 250:00
#BSUB -R "rusage[mem=50GB]"
#BSUB -e error_file%J
#BSUB -J wengan_assembly

module load htslib/1.4.1
module load gcc/10.2.0
module load perl/5.24.1

#Setting WD
cd /path/to/working/dir

#using singularity
CONTAINER=/home/k001y/programs/wengan_v0.2.sif

#location of wengan in the container
WENGAN=/wengan/wengan-v0.2-bin-Linux/wengan.pl

#Setting location of illumina short read fastq files
SHORT_READ=/path/to/short/read/fastq/files

#Setting location of ONT raw reads
LONG_READ=/path/to/folder/containing/longread/fastq

#run WenganM with singularity exec
singularity exec -B /icgc/dkfzlsdf/ $CONTAINER perl ${WENGAN} \
 -x ontraw \
 -a M \
 -s ${SHORT_READ}/L1_R1.fastq.gz,${SHORT_READ}/L1_R2.fastq.gz \
 -l ${LONG_READ}/merged.fastq.gz \
 -p sample_prefix -t 10 -g 5