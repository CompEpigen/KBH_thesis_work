#! /bin/bash

#BSUB -n 4
#BSUB -W 8:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J cutesv_test

module load anaconda3/2019.07

source activate cutesv-env

cuteSV /icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/Ovise.sorted.bam \
/icgc/dkfzlsdf/analysis/C010/brooks/GCF_000001405.26_GRCh38_genomic.fna \
/icgc/dkfzlsdf/analysis/C010/brooks/variant_calling/output/test.vcf \
/icgc/dkfzlsdf/analysis/C010/brooks/variant_calling \
--threads 4

