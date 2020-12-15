#! /bin/bash

#BSUB -n 4
#BSUB -W 8:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J pdx661_alt_varcalling

module load anaconda3/2019.07

source activate master-env

cuteSV /icgc/dkfzlsdf/analysis/C010/brooks/downstream/PDX661/PDX661.ngmlr.sorted.bam \
/icgc/dkfzlsdf/analysis/C010/brooks/GCF_000001405.26_GRCh38_genomic.fna \
/icgc/dkfzlsdf/analysis/C010/brooks/variant_calling/output/PDX661_alt_cutesv.vcf \
/icgc/dkfzlsdf/analysis/C010/brooks/variant_calling \
--sample PDX661 --threads 4 --max_cluster_bias_INS 100 --diff_ratio_merging_INS 0.3 --max_cluster_bias_DEL 100 --diff_ratio_merging_DEL 0.3

