#! /bin/bash

#BSUB -n 10
#BSUB -W 48:00
#BSUB -R "rusage[mem=5GB]"
#BSUB -e error_file%J
#BSUB -J multi_file_index

module load samtools/1.9

f5c index -d /icgc/dkfzlsdf/analysis/C010/brooks/nanopore_raw/PDX661/20201023_1159_MN30120_FAK51099_be399403/fast5/ -d /icgc/dkfzlsdf/analysis/C010/brooks/nanopore_raw/PDX661/20201023_1230_MN30130_FAK53307_6b23ab36/fast5 /icgc/dkfzlsdf/analysis/C010/brooks/assembly_pipeline/output/PDX661.merged.fastq