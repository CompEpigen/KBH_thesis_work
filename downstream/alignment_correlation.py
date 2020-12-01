#!/usr/bin/env python3

import argparse
import pysam
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='Find read alignment correlation')

    required = parser.add_argument_group(
        'Required',
        'Bam, and output location')

    required.add_argument(
        '-b',
        '--bam',
        type=str,
        help='bam file to subset')

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output location and name')

    args = parser.parse_args()

    #Reading in bam file
    inbam = pysam.AlignmentFile(args.bam, "rb")

    #Extracting read name, MAPQ, and fusion reference name from bam file & adding to txt file
    with open(args.output + '_read_summary.txt', 'w') as fout:
        for read in inbam:
            #print(read.query_name, read.mapping_quality, read.reference_name)
            fout.write(read.query_name + '\t')
            fout.write(str(read.mapping_quality) + '\t')
            fout.write(str(read.reference_name) + '\n')
        





if __name__ == '__main__':
    main()