#!/usr/bin/env python3

#Need to activate pysam venv w/ "conda activate pysam-venv" before running this script

import argparse
import pysam
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='subset methylation calls tsv by BAM read ID')

    required = parser.add_argument_group(
        'Required',
        'meth tsv, bam, and output location')

    required.add_argument(
        '-f',
        '--input',
        type=str,
        help='input methylation call tsv file')

    required.add_argument(
        '-l',
        '--list',
        type=str,
        help='txt list of read ids with deletion (from split_bam.py)')

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output prefix')

    args = parser.parse_args()

    '''
    1. Reading in methylation TSV file into pandas df
    '''

    meth = pd.read_csv(args.input, sep='\t')

    '''
    2. Reading in read id txt file
    '''

    read_ids = []

    with open(args.list, 'r') as fin:
        read_ids = [line.rstrip('\n') for line in fin]

    #print(readids)

    '''
    3. Susbsetting methylation data
    '''

    meth_dels = meth[meth.read_name.isin(read_ids)]
    meth_nodels = meth[~meth.read_name.isin(read_ids)]

    '''
    4. Remapping chromosomes
    '''

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


    meth_dels['chromosome'] = meth_dels['chromosome'].map(chr_dict)
    meth_nodels['chromosome'] = meth_nodels['chromosome'].map(chr_dict)

    #print(meth.head())

    #print(meth_dels.head())
    #print(meth_nodels.head())

    #Getting rid of weird chromosomes that result in blank columns

    #meth_dels = meth_dels[meth_dels.chromosome != '']
    #meth_nodels = meth_nodels[meth_nodels.chromosome != '']

    meth_dels = meth_dels.dropna(subset=['chromosome'])
    meth_nodels = meth_nodels.dropna(subset=['chromosome'])

    #Saving output
    meth_dels.to_csv(args.output + '_deletion_meth_calls.tsv', index=False, sep='\t')
    meth_nodels.to_csv(args.output + '_nodeletion_meth_calls.tsv', index=False, sep='\t')
    

if __name__ == '__main__':
    main()