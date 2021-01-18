#!/usr/bin/env python3

import argparse
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='convert methylation frequency tsv file to bedGraph for methrix')

    required = parser.add_argument_group(
        'Required',
        'meth_freq tsv, and output prefix/location')

    required.add_argument(
        '-f',
        '--input',
        type=str,
        help='input methylation frequency tsv file')

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output prefix and directory')

    args = parser.parse_args()

    '''
    1. Reading in methylation TSV file into pandas df
    '''

    meth = pd.read_csv(args.input, sep='\t')

    '''
    2. Susbsetting methylation data and writing output to new bedgraph file
    needed methrix format:
        chromosome | position | methylated_reads | all_reads
    '''

    meth = meth[['chromosome', 'start', 'end', 'methylated_frequency', 'called_sites', 'called_sites_methylated']]
    
    #renaming 'num_cpgs' column
    #meth.rename(columns = {'start':'position'}, inplace=True)
    #meth.rename(columns = {'called_sites_methylated':'methylated_reads'}, inplace=True)
    #meth.rename(columns = {'called_sites':'all_reads'}, inplace=True)

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

    meth.to_csv(args.output, index=False, sep='\t')
    

if __name__ == '__main__':
    main()