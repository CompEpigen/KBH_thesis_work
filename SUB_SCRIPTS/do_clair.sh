#! /bin/bash

#BSUB -n 4
#BSUB -W 8:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J clair

#module load samtools/1.9
#module load libgcrypt/1.8.2 
module load anaconda3/2019.07

source activate ./clair-env

CLAIR='/path/to/clair-env/bin/clair.py'
MODEL="/path/to/ont/model"                                     # e.g. [PATH_TO_CLAIR_MODEL]/ont/model
BAM_FILE_PATH="/path/to/the/file.bam"                          # e.g. chr21.bam
REFERENCE_FASTA_FILE_PATH="/path/to/reference/file.fasta"      # e.g. chr21.fa
#KNOWN_VARIANTS_VCF="[YOUR_VCF_FILE]" 

VARIANT_CALLING_OUTPUT_PATH="/path/to/output/file.vcf"         # e.g. calls/chr21.vcf (please make sure the directory exists)
CONTIG_NAME="chromosome"          # e.g. chr21
SAMPLE_NAME="sample_name"                              # e.g. HG001

python3 $CLAIR callVarBam \
--chkpnt_fn "$MODEL" \
--ref_fn "$REFERENCE_FASTA_FILE_PATH" \
--bam_fn "$BAM_FILE_PATH" \
--ctgName "$CONTIG_NAME" \
--sampleName "$SAMPLE_NAME" \
--call_fn "$VARIANT_CALLING_OUTPUT_PATH"



