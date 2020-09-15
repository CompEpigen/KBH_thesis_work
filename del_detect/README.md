# Deletion Detection

A [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) workflow for comparing methylation in long reads containing a deletion to those not containing the deletion. Relies on:
 * [pysam](https://pysam.readthedocs.io/en/latest/)

## Workflow

1. Define region of interest (ROI) in target bam file(s) & use samtools 'view' to extract this region into a new bam file (ROI bam)
2. Index these new bam files (samtools index)
3. Subset methylation data (tsv files, generated using the meth_calling_pipeline) using the filter_meth.py script
4. Split ROI bam into 2 separate bam files, 1 containing reads that have the deletion of interest and 1 containing reads without the deletion, using the split_bam.py script
5. Split the methylation tsv file based on the read id's extracted from step 4, format the two new methylation tsv files for use with pycoMeth using the split_meth.py script
6. (TODO) Aggregate CpGs in the methylation tsv files using pycoMeth's `CpG_Aggregate` function
7. (TODO) Compare methylation between the samples using pycoMeth's `Meth_Comp` function 
8. (TODO) Generate methylation comparison report using pcyoMeth's `Comp_Report` function 

A work in progress...