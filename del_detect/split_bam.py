#!/usr/bin/env python3

import argparse
import pysam

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

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output location and name')

    args = parser.parse_args()

    '''
    1. Read in BAM file & extract aligned pair positions + read id
    '''

    inbam = pysam.AlignmentFile(args.bam, "rb")

    ap = dict()

    for read in inbam:
        ids = read.query_name
        #print(type(ids))
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

    #print(reads_w_deletion)

    #reads_w_deletion = ', '.join(map(str, reads_w_deletion))

    #print(reads_w_deletion)
    #for id in reads_w_deletion:
    #    print(type(id))

    '''
    2.5 Saving deletion read list as a txt file
    '''

    with open(args.output + '_deletion_readids.txt', 'w') as fout:
        for readid in reads_w_deletion:
            #print(readid)
            fout.write(readid + '\n')

    '''
    3. Save new BAM files
    '''
    
    #Current issue is that the reads_w_deletion is a string with '', but the read.query_name has no quotes

    outfile_del = pysam.AlignmentFile(args.output + '_deletions.bam', 'w', template=inbam)
    outfile_nodel = pysam.AlignmentFile(args.output + '_nodeletions.bam', 'w', template=inbam)

    inbam = pysam.AlignmentFile(args.bam, "rb") #Ok so apparently this is necessary to include the inbam again, as the first invocation of it isnt global?

    for read in inbam:
        if read.query_name in reads_w_deletion:
            #print(read)
            outfile_del.write(read)
        else:
            outfile_nodel.write(read)


if __name__ == '__main__':
    main()