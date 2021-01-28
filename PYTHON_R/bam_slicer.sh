#! /bin/bash

module load samtools/1.9

INP_DIR=/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/PDX661

OUT_DIR=/icgc/dkfzlsdf/analysis/C010/brooks/downstream/PDX661

bams=`ls -1 $INP_DIR/*.bam`

### extract vicinity of the inversion 

for bf in $bams
do
bn=`basename $bf`
samtools view -h -b $bf 7:92263572-92445580 > $OUT_DIR/chr3_roi${bn}
samtools index $OUT_DIR/chr3_roi${bn}
done