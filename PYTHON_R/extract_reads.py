#!/usr/bin/env python3

import argparse
import pysam
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='Parse bam file for reads that come from possible telomeric fusions')

    required = parser.add_argument_group(
        'Required',
        'Bam, fusion list, and output location')

    required.add_argument(
        '-b',
        '--bam',
        type=str,
        help='bam file to subset')

    required.add_argument(
        '-f',
        '--fusion',
        type=str,
        help='fusion ids')

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output location and name')

    args = parser.parse_args()

    '''
    1. Reading in fusion list
    '''

    #read_ids = []

    fusion_list = pd.read_csv(args.fusion, sep = '\t')

    read_ids = fusion_list['read.id'].values.tolist()

    '''
    2. Reading in BAM file, subsetting reads, writing new bam file
    '''

    inbam = pysam.AlignmentFile(args.bam, "rb")

    outbam = pysam.AlignmentFile(args.output, "w", template=inbam)

    for read in inbam:
        #print(read.query_name)
        if read.query_name in read_ids:
            outbam.write(read)


if __name__ == '__main__':
    main()