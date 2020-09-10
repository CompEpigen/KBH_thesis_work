#!/usr/bin/env python3

#Need to activate pysam venv w/ "conda activate pysam-venv" before running this script

import argparse
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='subset methylation calls tsv by BAM read ID')

    required = parser.add_argument_group(
        'Required',
        'meth tsv, output location & prefix')

    required.add_argument(
        '-f',
        '--input',
        type=str,
        help='input methylation call tsv file')
    
    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output methylation call tsv file')

    args = parser.parse_args()


    '''
    1. Reading in methylation tsv file, changing header, adding strand column, and saving
    '''

    meth = pd.read_csv(args.input, sep='\t')

    #Adding fake strand info
    meth.insert(1, "strand", '+', True)
    
    #renaming 'num_cpgs' column
    meth.rename(columns = {'num_cpgs':'num_motifs'}, inplace=True)
    
    #Remapping chromosomes 
    chr_dict={
        "NC_000001.11" : "chr1",
        "NC_000002.12" : "chr2",
        "NC_000003.12" : "chr3",
        "NC_000004.12" : "chr4",
        "NC_000005.10" : "chr5",
        "NC_000006.12" : "chr6",
        "NC_000007.14" : "chr7",
        "NC_000008.11" : "chr8",
        "NC_000009.12" : "chr9",
        "NC_000010.11" : "chr10",
        "NC_000011.10" : "chr11",
        "NC_000012.12" : "chr12",
        "NC_000013.11" : "chr13",
        "NC_000014.9" : "chr14",
        "NC_000015.10" : "chr15",
        "NC_000016.10" : "chr16",
        "NC_000017.11" : "chr17",
        "NC_000018.10" : "chr18",
        "NC_000019.10" : "chr19",
        "NC_000020.11" : "chr20",
        "NC_000021.9" : "chr21",
        "NC_000022.11" : "chr22",
        "NC_000023.11" : "chrX",
        "NC_000024.10" : "chrY"
        }


    meth['chromosome'] = meth['chromosome'].map(chr_dict)

    #FOR THE SAMPLES I AM USING I DON'T NEED TO REMAP CHROMOSOMES, MIGHT NEED TO CHANGE LATER

    #print(meth.head())

    #reordering the columns, dropping unused ones
    meth = meth[['chromosome', 'strand', 'start', 'end', 'read_name', 'log_lik_ratio', 'log_lik_methylated', 'log_lik_unmethylated']]

    #print(meth.head())

    meth.to_csv(args.output, index=False, sep='\t') #Would ideally like to have it just overwrite the input file, but for right now it's easier to have the snakemake file have seperate input/output files


if __name__ == '__main__':
    main()
    