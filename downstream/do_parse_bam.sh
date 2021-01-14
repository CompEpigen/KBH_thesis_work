#! /bin/bash

#BSUB -n 3
#BSUB -W 72:00
#BSUB -R "rusage[mem=15GB]"
#BSUB -e error_file%J
#BSUB -J find_AS_clipped_meth

module load samtools/1.9
module load anaconda3/2019.07
source activate master-env

python3 parse_bam.py -b ./GCTB/AS.ngmlr.hg38.sorted.bam -o ./GCTB/AS_hg38_ngmlr_1000bp -m /icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AS.meth_calls.tsv

samtools sort ./GCTB/AS_hg38_ngmlr_1000bp_clipped.bam -o ./GCTB/AS_hg38_ngmlr_1000bp_clipped.sorted.bam

samtools index ./GCTB/AS_hg38_ngmlr_1000bp_clipped.sorted.bam


