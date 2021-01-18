#! /bin/bash

#BSUB -n 10
#BSUB -W 120:00
#BSUB -R "rusage[mem=15GB]"
#BSUB -e error_file%J
#BSUB -J as_TtoT_ngmlr_align

module load samtools/1.9

ngmlr -t 10 -r /icgc/dkfzlsdf/analysis/C010/brooks/chm13.draft_v1.0.fasta.gz -q /icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AS.merged.fastq -x ont | samtools sort > /icgc/dkfzlsdf/analysis/C010/brooks/downstream/GCTB/AS.TtoT.sorted.bam
samtools index /icgc/dkfzlsdf/analysis/C010/brooks/downstream/GCTB/AS.TtoT.sorted.bam
