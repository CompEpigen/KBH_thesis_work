#!/usr/bin/env python3

#Need to activate pysam venv w/ "conda activate pysam-venv" before running this script

import argparse
import pysam
from Bio import SeqIO
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='subset methylation calls tsv by BAM read ID & clean/format for PycoMeth')

    required = parser.add_argument_group(
        'Required',
        'ref, bed, and output location')

    required.add_argument(
        '-f',
        '--input',
        type=str,
        help='input reference fasta file')

    #required.add_argument(
    #    '-b',
    #    '--bed',
    #    type=str,
    #    help='bed file containing telomeric ranges')

    #required.add_argument(
    #    '-o',
    #    '--output',
    #    type=str,
    #    help='output prefix')

    args = parser.parse_args()

    '''
    1. Reading in reference fasta file
    '''

    

    '''
    2. Reading in read id txt file
    '''


if __name__ == '__main__':
    main()