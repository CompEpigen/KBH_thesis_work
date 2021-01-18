#!/usr/bin/env python3

#Need to activate pysam venv w/ "conda activate pycometh" before running this script

import argparse
import pysam
import pandas as pd

def main ():

    parser = argparse.ArgumentParser(description='subset methylation calls tsv by read ID')

    required = parser.add_argument_group(
        'Required',
        'meth tsv and output location')

    required.add_argument(
        '-f',
        '--input',
        type=str,
        help='input methylation call tsv file')

    required.add_argument(
        '-o',
        '--output',
        type=str,
        help='output location and name')

    args = parser.parse_args()

    '''
    1. Creating list of read ids to filter on
    '''

    #First 3 contain del7q, last 3 do not
    del_ids = ["60f4fcc7-474c-4698-9f7e-36486a8bc7fc", "e7dd8fec-c39a-42c5-a262-7dff5c9f14f3", "91230b59-076e-4148-9356-131bc21ad369", "f795935f-e0b7-4792-ba9f-c1f37600cb5f"]
    nodel_ids = ["a723cb56-9ca6-4b8f-82d9-0d5446c5a025", "054b7975-4236-4f74-a33c-c0572c41f3f6", "9c08fe6e-b470-422e-b873-b43005ceb379", "6a86f495-99cf-444c-b3dd-87148e6fe8ab", "7f3a36c2-1fd6-4692-8c0b-51e5315a03ab"]

    '''
    2. Reading in methylation tsv file
    '''

    meth = pd.read_csv(args.input, sep='\t')

    '''
    3. Susbsetting methylation data and writing output to new TSV file
    '''

    meth_del = meth[meth.read_name.isin(del_ids)]
    meth_nodel = meth[meth.read_name.isin(nodel_ids)]

    meth_del.to_csv(args.output + "_deletion_calls.tsv", index=False, sep='\t')
    meth_nodel.to_csv(args.output + "_nodeletion_calls.tsv", index=False, sep='\t')
    

if __name__ == '__main__':
    main()
    