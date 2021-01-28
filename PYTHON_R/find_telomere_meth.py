#!/usr/bin/env python3

#Need to activate pysam venv w/ "conda activate pycometh" before running this script

import argparse
import pysam
from Bio import SeqIO
import pandas as pd
from collections import defaultdict
import csv

def main ():

    parser = argparse.ArgumentParser(description='subset methylation calls tsv for telomeric methylation')

    required = parser.add_argument_group(
        'Required',
        'reference fasta, meth tsv, method and output location')

    required.add_argument(
        '-r',
        '--reference',
        type=str,
        help='reference fasta file')

    required.add_argument(
        '-f',
        '--input',
        type=str,
        help='input methylation file (tsv or txt)')

    required.add_argument(
        '-m',
        '--method',
        type=str,
        help='Bismark or Nanopore')

    required.add_argument(
        '-w',
        '--window',
        type=int,
        default=10000,
        help='input methylation call tsv file')

    required.add_argument(
        '-c',
        '--alt_chrom',
        type=bool,
        default=False,
        help='Alternative chromosome names? Boolean [False]')

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output location and name')

    args = parser.parse_args()


    '''
    1. Creating chromosome dictionary and reading in reference genome
    '''

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

    telomere_coords = defaultdict(dict)

    #with open(args.reference, 'r') as fasta:
    #    for record in SeqIO.parse(fasta, 'fasta'):
    #        #print(record.id, len(record.seq))
    #        telomere_coords[record.id]["pter"] = args.window
    #        telomere_coords[record.id]["qter"] = (len(record.seq) - args.window)
            
    #print(telomere_coords)


    with open(args.reference, 'r') as fasta:
        for record in SeqIO.parse(fasta, 'fasta'):
            if args.alt_chrom == True:
                for key, value in chr_dict.items():
                    if value == record.id:
                        telomere_coords[key]["pter"] = args.window
                        telomere_coords[key]["qter"] = (len(record.seq) - args.window)
            else:
                telomere_coords[record.id]["pter"] = args.window
                telomere_coords[record.id]["qter"] = (len(record.seq) - args.window)
        
        

    #print(telomere_coords)

    #for key, values in telomere_coords.items():
    #    print(key, values["pter"])
    
    '''
    2. Reading in methylation file and filtering to get pter and qter positions
    '''

    telomeres = []

    if args.method == "Bismark":
    
        with open(args.input, "r") as fin:
            for line in fin:
                split = line.strip().split("\t")
                for key, values in telomere_coords.items():
                    if split[0] == key:
                        if int(split[2]) < values["pter"] or int(split[1]) > values["qter"]:
                            telomeres.append(
                                {
                                    "chromosome" : split[0],
                                    "start" : split[1],
                                    "end" : split[2],
                                    "freq" : split[3],
                                    "n_meth" : split[4],
                                    "n_unmeth" : split[5]
                                }
                            )
                        
    if args.method == "Nanopore":

        with open(args.input, "r") as fin:
            for line in fin:
                split = line.strip().split("\t")
                for key, values in telomere_coords.items():
                    if split[0] == key:
                        if int(split[2]) < values["pter"] or int(split[1]) > values["qter"]:
                            telomeres.append(
                                {
                                    "chromosome" : split[0],
                                    "start" : split[1],
                                    "end" : split[2],
                                    "freq" : split[6],
                                    "n_meth" : split[5],
                                    "n_unmeth" : split[4]
                                }
                            )

    '''
    3. Converting to df and saving output
    '''
    
    telomeres = pd.DataFrame(telomeres)
    #telomeres = telomeres.transpose()
    telomeres.columns = ['chromosome', 'start', 'end', 'freq', 'n_meth', 'n_unmeth']

    telomeres.to_csv(args.output + '_' + str(args.window) + 'bp' + '_telomeric_meth.tsv', index=False, sep='\t')



if __name__ == '__main__':
    main()