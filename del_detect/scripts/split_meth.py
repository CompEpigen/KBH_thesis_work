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
    3. Susbsetting methylation data and writing output to new TSV files
    '''

    meth_dels = meth[meth.read_name.isin(read_ids)]
    meth_nodels = meth[~meth.read_name.isin(read_ids)]

    #print(meth_dels.head())
    #print(meth_nodels.head())

    meth_dels.to_csv(args.output + '_deletion_meth_calls.tsv', index=False, sep='\t')
    meth_nodels.to_csv(args.output + '_nodeletion_meth_calls.tsv', index=False, sep='\t')
    

if __name__ == '__main__':
    main()