#! /bin/bash

#BSUB -n 5
#BSUB -W 48:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J create_concensus

module load samtools/1.9
module load bcftools/1.9

PREFIX=sample_prefix
SAMPLE=/path/to/${PREFIX}.sorted.bam
REF=/path/to/reference.fasta

bcftools mpileup -Ou -f ${REF} ${SAMPLE} | bcftools call -Ou -mv | bcftools norm -f ${REF} Oz -o ${PREFIX}.vcf.gz


