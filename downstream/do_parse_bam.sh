#! /bin/bash

#BSUB -n 3
#BSUB -W 8:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J find_AR_clipped_meth_test2

module load samtools/1.9
module load anaconda3/2019.07
source activate master-env

python3 parse_bam.py -b ./PDX661/PDX661.ngmlr.hg38.sorted.bam -o ./PDX661/PDX661_hg38_ngmlr_1000bp_clipped -m /icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AR.meth_calls.tsv

#samtools sort ./GCTB/AR_hg38_ngmlr_1000bp_clipped.bam -o ./GCTB/AR_hg38_ngmlr_1000bp_clipped.sorted.bam

#samtools index ./GCTB/AR_hg38_ngmlr_1000bp_clipped.sorted.bam