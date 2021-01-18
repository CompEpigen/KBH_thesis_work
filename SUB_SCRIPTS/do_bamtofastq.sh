#! /bin/bash

#BSUB -n 2
#BSUB -W 24:00
#BSUB -R "rusage[mem=15GB]"
#BSUB -e error_file%J
#BSUB -J bam_to_fastq

module load picard/1.61

java -jar /software/picard/1.61/jar/SamToFastq.jar INPUT=/path/to/file.sorted.bam \
FASTQ=/path/to/output.fastq