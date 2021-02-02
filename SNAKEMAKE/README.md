# Nanopore Data Processing Pipeline

A [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) workflow for taking basecalled fastq files, aligning to a reference genome, indexing, calling methylation, and calling structural variants. Built to operate in IBM LSF cluster environments (using BSUB, etc.)

Running precheck.sh will ensure that all needed packages are installed and on the user's $PATH, if not please install and run again

After ensuring that all dependencies are installed and on the user's $PATH, the user may edit the config.yaml file to contain the necessary data and output locations, reference genome, sample names, etc.

After the config.yaml file has been edited and saved, the user may run the pipeline with the following command:

```
USER$ bash do_snakemake.sh
```

This will launch the snakemake pipeline. It is recommended to do this in a screen that one can detach from after starting the pipeline so that it is running in the background. 

Based on the size of the intial data, and if the full pipeline is being run, the workflow may take anywhwere from a few hours to several days.

## Workflow

1. Run QC on basecalled sample using [PycoQC](https://github.com/a-slide/pycoQC)
2. Merge fastq files into one ".merged.fastq"
3. Index fast5 files with fastq files using [f5c](https://github.com/hasindu2008/f5c) 
4. Align to reference genome using [NGMLR](https://github.com/philres/ngmlr)
5. Index bam files using samtools
6. Call methylation using [f5c](https://github.com/hasindu2008/f5c) 
7. Convert methylation log-liklihood ratios to frequency values (f5c)
8. Call SVs/SNVs using [Sniffles](https://github.com/fritzsedlazeck/Sniffles)
9. Convert meth_freq.tsv files to bedGraph format for use with [Methrix](https://github.com/CompEpigen/methrix)
