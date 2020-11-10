#! /bin/bash

module load samtools/1.9

INP_DIR=/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output

OUT_DIR=/icgc/dkfzlsdf/analysis/C010/brooks/downstream/ashish

bams=`ls -1 $INP_DIR/*.bam`

### extract vicinity of the deletion NC_000017.11:65564174-65564181

for bf in $bams
do
bn=`basename $bf`
samtools view -h -b $bf NC_000003.12:167000000-170000000 > $OUT_DIR/chr3_roi${bn}
samtools index $OUT_DIR/chr3_roi${bn}
done