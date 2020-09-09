#! /bin/bash

module load samtools/1.9

INP_DIR=/icgc/dkfzlsdf/analysis/C010/mayerma/methylation_analysis/mapping

OUT_DIR=/icgc/dkfzlsdf/analysis/C010/brooks/del_detect/bam_slicing

bams=`ls -1 $INP_DIR/*.bam`

### extract vicinity of the deletion NC_000017.11:65564174-65564181

for bf in $bams
do
bn=`basename $bf`
samtools view -h -b $bf NC_000017.11:64803882-66303882 > $OUT_DIR/del_chr17_64803882_66303882_${bn}
samtools index $OUT_DIR/del_chr17_64803882_66303882_${bn}
samtools merge all_del_merged.bam *.bam
samtools index all_del_merged.bam
done