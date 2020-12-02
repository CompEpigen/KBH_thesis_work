#! /bin/bash

#BSUB -n 10
#BSUB -W 48:00
#BSUB -R "rusage[mem=15GB]"
#BSUB -e error_file%J
#BSUB -J AR_index

module load samtools/1.9

DIR=/icgc/dkfzlsdf/analysis/C010/brooks/nanopore_raw/GCTB/AR/

f5c index -d $DIR/20201117_1427_MN30120_FAK66244_9d952c68/fast5/ -d $DIR/20201117_1436_MN30130_FAK66342_f1472049/fast5/ -d $DIR/20201120_1241_MN30120_FAO34307_2b726294/fast5/ /icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AR.merged.fastq