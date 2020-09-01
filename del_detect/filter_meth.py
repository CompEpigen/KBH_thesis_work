#!/usr/bin/env python3

#Need to activate pysam venv w/ "conda activate pysam-venv" before running this script

#Idea here would be to have non-filtered bam file be the input
#Then use inbam.fetch to find broad region
#Then use it again to filter in deletion region
#Write output to new bam file
#Include counts 


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
        '-b',
        '--bam',
        type=str,
        help='bam file to use for subsetting')

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output location and name')

    args = parser.parse_args()

    '''
    1. Reading in BAM file and extracting read ids
    '''

    inbam = pysam.AlignmentFile(args.bam, "rb")

    read_ids = []

    for read in inbam:
        read_ids.append(read.query_name)

    '''
    2. Reading in methylation tsv file
    '''

    meth = pd.read_csv(args.input, sep='\t')

    '''
    3. Susbsetting methylation data and writing output to new TSV file
    '''

    meth = meth[meth.read_name.isin(read_ids)]

    meth.to_csv(args.output, index=False, sep='\t')
    

if __name__ == '__main__':
    main()
    