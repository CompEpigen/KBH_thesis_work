####Overview####

#This script utilizes Gviz to plot multiple different tracks in one nice figure

#Loading libraries
library(base, lib.loc = "/software/r/3.5.1/lib64/R/library")
#library(vcfR)
#library(ape)
library(Gviz)
library(genomation, lib.loc = "/home/k001y/R/x86_64-pc-linux-gnu-library/4.0/")
#library(Rcpp, lib.loc = "/software/r/3.5.1/lib64/R/library")
#library(plyr, lib.loc = "/home/k001y/R/x86_64-pc-linux-gnu-library/3.5/")
#library(crayon, lib.loc = "/software/r/3.5.1/lib64/R/library")
#library(backports, lib.loc = "/software/r/3.5.1/lib64/R/library")
#library(vctrs, lib.loc = "/software/r/3.5.1/lib64/R/library")
#library(dplyr, lib.loc = "/software/r/3.5.1/lib64/R/library")
#library(data.table, lib.loc = "/home/k001y/R/x86_64-pc-linux-gnu-library/3.5/")
#library(ggplot2)

####Setting Variables####

#Setting wd
WD = "/icgc/dkfzlsdf/analysis/C010/brooks/downstream/"
setwd(WD)
#Loacation of the meth_freq file
SAMPLE.METH = '/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/PDX661/PDX661.meth_freq.tsv'
#Sample Name
SAMPLE.NAME = "PDX661"
#Genome of interest
GENOME = "hg38"
#Chromosome of interest, in "chr1" format
CHROMOSOME = "chr7"
#Region of interest in format of start-end"
ROI = "157002854-157012663"
#Bin size for tiling methylation values
BIN.SIZE = 10000
#Location to write output files 
OUTPUT.LOC = "./PDX661/phase/"

#Getting alternative chromosome name and setting "CHROMOSOME.ALT" variable

chroms <- data.frame(
  chrom = c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY"),
  alts = c("NC_000001.11","NC_000002.12","NC_000003.12","NC_000004.12","NC_000005.10","NC_000006.12","NC_000007.14","NC_000008.11","NC_000009.12","NC_000010.11","NC_000011.10","NC_000012.12","NC_000013.11","NC_000014.9","NC_000015.10","NC_000016.10","NC_000017.11","NC_000018.10","NC_000019.10", "NC_000020.11", "NC_000021.9", "NC_000022.11","NC_000023.11", "NC_000024.10" )
)

if (CHROMOSOME %in% chroms$chrom) {
  pos <- as.numeric(match(CHROMOSOME, chroms$chrom))
  CHROMOSOME.ALT <- as.character(chroms$alt[pos])
} else {
  print("Unrecognized chromosome!")
  break
}

####Loading functions needed in analysis####

#This function assigns a bin number to each value, needed for average methylation values later
binData <- function(sample, bin_size) {
  sample$bin <- 1+floor((sample$start-sample$start[1])/bin_size)
  return (sample)
}

#This function was originally used to get the bins for binning the methylation data, but now I just use it to extract bin coordinates
createBins <- function(start, end, bin_size){
  roi = c(min(start), max(end))
  bins = data.frame(bin = NA,
                    start = seq(from = roi[1], to = roi[2], by = bin_size),
                    end = NA)
  bins$bin = seq_len(nrow(bins))
  for (i in (seq_len(nrow(bins)-1))) {
    bins$end[i] = bins$start[i+1]
  }
  bins$end = (bins$end-1) 
  bins$end[nrow(bins)] = roi[2]
  return(bins)
}

####Parsing ROI####

#Getting ROI coordinates for subsetting/loading data 
roi = strsplit(ROI, "-")[[1]]
roi.start = as.numeric(roi[1])
roi.end = as.numeric(roi[2])

####Loading files####

#Loading methylation file
meth <- read.csv(file = SAMPLE.METH, sep = '\t')

#Subsetting the data for the ROI, this makes creating the chromR object easier/faster
meth.roi <- subset(meth, meth$chromosome == CHROMOSOME.ALT & meth$start > roi.start & meth$end < roi.end)

#Loading ROI gene annotation track 
gene.track <- BiomartGeneRegionTrack(genome = GENOME,
                                     chromosome = CHROMOSOME, 
                                     start = roi.start, end = roi.end,
                                     name = "ENSEMBL")

#Loading and formatting methylation track
meth.track <- AnnotationTrack(name = paste(CHROMOSOME, ROI, "Methylation"),
                              start = meth.roi$start,
                              end = meth.roi$end,
                              chromosome = CHROMOSOME,
                              feature = meth.roi$methylated_frequency,
                              stacking = "squish")


track.list <- c(gene.track, meth.track)



plotTracks(track.list,from=roi.start,to=roi.end,chromsome=CHROMOSOME, stacking = 'squish')


#To remove everything but the meth df:
#rm(list=setdiff(ls(), "meth"))

#Resource for GVis:
#https://compgenomr.github.io/book/visualizing-and-summarizing-genomic-intervals.html

