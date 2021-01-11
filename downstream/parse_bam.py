#!/usr/bin/env python3

import argparse
import pysam
from cigar import Cigar
from collections import defaultdict, Counter
import pandas as pd
import numpy as np

def main ():

    parser = argparse.ArgumentParser(description='Parse BAM file for multi-alignment and soft-clipped reads')

    required = parser.add_argument_group(
        'Required',
        'Bam, deletion, output location, flags to filter on, and splits to filter on')

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
        help='output location and prefix')

    required.add_argument(
        '-f',
        '--flag',
        type=str,
        help='flag(s) to filter bam file on. delimited list, default 256,2046,2304',
        default='256,2048,2304') 
    
    required.add_argument(
        '-s',
        '--splits',
        type=int,
        help='Number of splits read aligns to to filter on for bedpe file [2]',
        default=2)

    optional = parser.add_argument_group(
            'Optional',
            'methylation call tsv file (from f5c)')

    optional.add_argument(
            '-m',
            '--meth',
            type=str,
            help='Methylation calls tsv file to filter (from f5c)')

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

    '''
    5. Creating bedpe file 
    BEDPE format:
    chrom1, start1, end1, chrom2, start2, end2
    Right now this will only return reads that map to 2 places in the genome, obviously this is not ideal but it is at my limit in terms of complexity
    '''

    test_list = []

    inbam = pysam.AlignmentFile(args.bam, "rb")

    for read in inbam:
        if read.query_name in big_clip:
            test_list.append(read.query_name)
            counts = Counter(test_list)
    
    unique_reads = []

    N = args.splits

    for key, value in counts.items():
        #print(key, value)
        if value == N:
            unique_reads.append(key)


    inbam = pysam.AlignmentFile(args.bam, "rb")

    #print(len(unique_reads))

    splits = defaultdict(dict)

    for read in inbam:
        if read.query_name in unique_reads:
            #print(read.query_name)
            if read.query_name not in splits.keys():
                splits[read.query_name]["chromosome"] = read.reference_name
                splits[read.query_name]["start"] = str(read.reference_start)
                splits[read.query_name]["end"] = str(read.reference_end)

            else:
                splits[read.query_name]["chromosome"] += ","+read.reference_name
                splits[read.query_name]["start"] += ","+str(read.reference_start)
                splits[read.query_name]["end"] += ","+str(read.reference_end)
                #print(splits)
        #print(splits)
    
     #Ok so the print statement above returns the right results except for the last line, so that is where something is going wrong!
    print(splits)


    bedpe = pd.DataFrame.from_dict(splits, orient='index')

    #print(bedpe)

    bedpe[['chrom1', 'chrom2']] = bedpe['chromosome'].str.split(',', expand = True,)
    bedpe[['start1', 'start2']] = bedpe['start'].str.split(',', expand = True, )
    bedpe[['end1', 'end2']] = bedpe['end'].str.split(',', expand = True, )

    bedpe = bedpe[["chrom1", "start1", "end1", "chrom2", "start2", "end2"]]

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

    bedpe['chrom1'] = bedpe['chrom1'].map(chr_dict)
    bedpe['chrom2'] = bedpe['chrom2'].map(chr_dict)

    #print(bedpe.head())

    bedpe.to_csv(args.output + "_split_reads.bedpe", index=False, sep='\t')

    '''
    6. Optional Methylation filtering
    '''

    if args.meth is not None:

        meth = pd.read_csv(args.meth, sep='\t')

        meth = meth[meth.read_name.isin(big_clip)]

        meth.to_csv(args.output + '_clipped_meth.tsv', index=False, sep='\t')



if __name__ == '__main__':
    main()
