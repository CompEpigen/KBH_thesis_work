#! /bin/bash

#BSUB -n 4
#BSUB -W 8:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J clair_test

#module load samtools/1.9
#module load libgcrypt/1.8.2 
module load anaconda3/2019.07

source activate ./clair-env

CLAIR='/icgc/dkfzlsdf/analysis/C010/brooks/variant_calling/clair-env/bin/clair.py'
MODEL="/icgc/dkfzlsdf/analysis/C010/brooks/variant_calling/ont/model"                                     # e.g. [PATH_TO_CLAIR_MODEL]/ont/model
BAM_FILE_PATH="/icgc/dkfzlsdf/analysis/C010/brooks/del_detect/bam_slicing/all_del_merged.bam"                          # e.g. chr21.bam
REFERENCE_FASTA_FILE_PATH="/icgc/dkfzlsdf/analysis/C010/brooks/GCF_000001405.26_GRCh38_genomic.fna"  # e.g. chr21.fa
#KNOWN_VARIANTS_VCF="[YOUR_VCF_FILE]" 

VARIANT_CALLING_OUTPUT_PATH="/icgc/dkfzlsdf/analysis/C010/brooks/variant_calling/output/chr17.vcf"         # e.g. calls/chr21.vcf (please make sure the directory exists)
CONTIG_NAME="NC_000017.11"          # e.g. chr21
SAMPLE_NAME="chr17_test"                              # e.g. HG001

python3 $CLAIR callVarBam \
--chkpnt_fn "$MODEL" \
--ref_fn "$REFERENCE_FASTA_FILE_PATH" \
--bam_fn "$BAM_FILE_PATH" \
--ctgName "$CONTIG_NAME" \
--sampleName "$SAMPLE_NAME" \
--call_fn "$VARIANT_CALLING_OUTPUT_PATH"



