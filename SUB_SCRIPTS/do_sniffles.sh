#! /bin/bash

#BSUB -n 3
#BSUB -W 8:00
#BSUB -R "rusage[mem=20GB]"
#BSUB -e error_file%J
#BSUB -J sniffles

sniffles -m /path/to/sorted.bam -v /path/to/output/file.vcf
