#! /bin/bash

module load samtools/1.9

SAMPLE=sample_name

INP_BAM=/path/to/file.sorted.bam

ROIS=/path/to/file.txt #Txt file containing roi in chromosome, start, end format

OUT_DIR=/path/to/output/dir/

rois=`cat $ROIS`

### extract vicinity of the inversion 

for roi in $rois
do
#echo $roi
#bn=`basename $bf`
samtools view -h -b $INP_BAM $roi > $OUT_DIR/${SAMPLE}_ROI_${roi}.bam
samtools index $OUT_DIR/${SAMPLE}_ROI_${roi}.bam
done

samtools merge $OUT_DIR/${SAMPLE}_ROI_merged.bam $OUT_DIR/${SAMPLE}_ROI_*.bam
samtools index $OUT_DIR/${SAMPLE}_ROI_merged.bam