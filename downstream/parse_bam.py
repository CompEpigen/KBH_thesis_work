#!/usr/bin/env python3

import argparse
import pysam
from cigar import Cigar
from collections import defaultdict
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='Parse BAM file for multi-alignment and soft-clipped reads')

    required = parser.add_argument_group(
        'Required',
        'Bam, deletion, and output location')

    required.add_argument(
        '-b',
        '--bam',
        type=str,
        help='bam file')

    required.add_argument(
        '-c',
        '--clip_size_thresh',
        type=int,
        help='soft clip size threshold to filter on [1000]',
        default=1000)

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output location and name')

    required.add_argument(
        '-f',
        '--flag',
        type=str,
        help='flag(s) to filter bam file on. delimited list, default 256,2046,2304',
        default='256,2048,2304') 


    args = parser.parse_args()

    '''
    1. Read in BAM file & extract read ID, flag, and CIGAR string, then filter based on flags
    '''

    inbam = pysam.AlignmentFile(args.bam, "rb")

    reads = dict()

    codes = [int(item) for item in args.flag.split(',')]

    #print(codes)

    for read in inbam:
        if read.flag in codes:
            reads[read.query_name] = read.cigarstring
            #print(reads)

        #return(reads)
    
    '''
    2. Parsing CIGAR string for left and right soft-clipping
    '''

    clips = defaultdict(dict)

    for key, value in reads.items():
        #print(value)
        c = Cigar(value)
        items = list(c.items())
        #print(items[-1][1])
        if (items[0][1] == "S"):
            clips[key]["LC"] = int(items[0][0])
        else:
            clips[key]["LC"] = 0
        
        if (items[-1][1] == "S"):
             clips[key]["RC"] = int(items[-1][0])
        else:
            clips[key]["RC"] = 0


        #print(clips)
        
        
    '''
    3. Converting clips nested dict into pd dataframe, filtering on clipping criteria
    '''

    clips_df = pd.DataFrame.from_dict(clips, orient='index')
    #print(clips_df.head())

    clips_df = clips_df[(clips_df['LC'] >= args.clip_size_thresh) | (clips_df['RC'] >= args.clip_size_thresh)]
    #print(clips_df.head())

    '''
    4. Extracting read id's from list above, and creating new BAM file
    '''

    big_clip = list(clips_df.index)

    outfile = pysam.AlignmentFile(args.output + '_clipped.bam', 'w', template=inbam)

    inbam = pysam.AlignmentFile(args.bam, "rb") #Ok so apparently this is necessary to include the inbam again, as the first invocation of it isnt global?

    for read in inbam:
        if read.query_name in big_clip:
            #print(read)
            outfile.write(read)



if __name__ == '__main__':
    main()
