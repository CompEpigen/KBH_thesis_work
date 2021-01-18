#! /bin/bash

#BSUB -n 10
#BSUB -W 48:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J f5c

FASTQ=/path/to/file.merged.fastq
BAM=/path/to/file.sorted.bam
REF=/path/to/ref.fasta.bgz #Reference fasta MUST BE BGZIPPED!
OUT=/path/to/output/meth_calls.tsv
OUT_FREQ=/path/to/output/meth_freq.tsv

f5c call-methylation -t 10 -r $FASTQ -b $BAM -g $REF > $OUT

f5c meth-freq -i $OUT -o $OUT_FREQ -s
