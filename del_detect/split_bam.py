#!/usr/bin/env python3

import argparse
import pysam
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='Split reads in BAM file based on prescence of deletion')

    required = parser.add_argument_group(
        'Required',
        'Bam, deletion, and output location')

    required.add_argument(
        '-b',
        '--bam',
        type=str,
        help='bam file to subset')

    required.add_argument(
        '-d',
        '--deletion',
        type=str,
        help='deletion to filter on (start-end)')

    #required.add_argument(
    #    '-o',
    #    '--output',
    #    type=str,
    #    help='output location and name')

    args = parser.parse_args()

    '''
    1. Read in BAM file & extract aligned pair positions
    '''

    inbam = pysam.AlignmentFile(args.bam, "rb")

    ap = dict()

    for read in inbam:
        ids = read.query_name
        pairs = read.get_aligned_pairs()
        ap[ids] = pairs
        #print(read.query_name, read.get_aligned_pairs())

    #print(ap)
    #print(ap.keys())

    '''
    2. Parse dictionary for positions of interest, add read ID to list for subsetting
    '''

    del_range = args.deletion.split('-') 

    deletion = []
    
    for x in range(int(del_range[0]), int(del_range[1]) + 1):
        deletion.append(x)

    #print(deletion)

    reads_w_deletion = []

    for key, lists in ap.items():
        for pair in lists:
            #print(key, pair)
            if pair[1] in deletion and pair[0] is None:
                #print(key, pair)
                reads_w_deletion.append(key)

    reads_w_deletion = list(set(reads_w_deletion))

    print(reads_w_deletion)

    '''
    3. Save new BAM files
    '''
    
    for read in inbam:
        if read.query_name in reads_w_deletion:
            
        else:



if __name__ == '__main__':
    main()