#Setting wd
setwd("/icgc/dkfzlsdf/analysis/C010/brooks/downstream/PDX661")

#Loading libraries
library(base, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(Rcpp, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(plyr, lib.loc = "/home/k001y/R/x86_64-pc-linux-gnu-library/3.5/")
library(crayon, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(backports, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(vctrs, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(dplyr, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(data.table, lib.loc = "/home/k001y/R/x86_64-pc-linux-gnu-library/3.5/")
library(ggplot2)


#Setting variables:

#Table for chromosome conversion:

#"NC_000001.11" : "chr1",
#"NC_000002.12" : "chr2",
#"NC_000003.12" : "chr3",
#"NC_000004.12" : "chr4",
#"NC_000005.10" : "chr5",
#"NC_000006.12" : "chr6",
#"NC_000007.14" : "chr7",
#"NC_000008.11" : "chr8",
#"NC_000009.12" : "chr9",
#"NC_000010.11" : "chr10",
#"NC_000011.10" : "chr11",
#"NC_000012.12" : "chr12",
#"NC_000013.11" : "chr13",
#"NC_000014.9" : "chr14",
#"NC_000015.10" : "chr15",
#"NC_000016.10" : "chr16",
#"NC_000017.11" : "chr17",
#"NC_000018.10" : "chr18",
#"NC_000019.10" : "chr19",
#"NC_000020.11" : "chr20",
#"NC_000021.9" : "chr21",
#"NC_000022.11" : "chr22",
#"NC_000023.11" : "chrX",
#"NC_000024.10" : "chrY"


#Loacation of the meth_freq file
SAMPLE = '/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/PDX661/PDX661.meth_freq.tsv'
#Telomere bed file
TELOMERES = '/icgc/dkfzlsdf/analysis/C010/brooks/hg38_telomere_annots.bed'
#Chromosome of interest, in "NC_000001.11" format
CHROMOSOME = "NC_000007.14"
#Chromosome of interest, in "chr1" format
T.CHROM = "chr7"
#Desired Telomere size
TELOMERE.SIZE = 100000
#Bin size for tiling methylation values
BIN.SIZE = 1000
#Location to write output files 
OUTPUT.LOC = "./"

####Loading the data & formatting####

#Loading telomere locations

telomeres <- read.csv(file = TELOMERES, sep = '\t', header = FALSE)

#Renaming columns for ease of reading

colnames(telomeres) <- c("chromosome", "start", "end")

#Expanding telomeres to be the desired size

telomere.start <- subset(telomeres, telomeres$start == 0)
telomere.ends <- subset(telomeres, telomeres$start != 0)

if (TELOMERE.SIZE != 100000) {
  telomere.ends$start <- (telomere.ends$start + 10000) - TELOMERE.SIZE 
} else {
  telomere.ends$start <- (telomere.ends$start - 90000)
}

if (TELOMERE.SIZE != 100000) {
  telomere.start$end <- (telomere.start$end - 100000) + TELOMERE.SIZE 
} else {
  telomere.start$end <- (telomere.start$end)
}

telomeres <- rbind(telomere.start, telomere.ends)

rm(telomere.ends, telomere.start)

#Loading methylation data

meth <- read.csv(file = SAMPLE, sep = '\t')

#Subsetting both of the above for desired chromosome

meth.chrom <- subset(meth, meth$chromosome == CHROMOSOME)
telomeres.chrom <- subset(telomeres, telomeres$chromosome == T.CHROM)

telomeres.chrom.start <- telomeres.chrom[1, ]
telomeres.chrom.end <- telomeres.chrom[2, ]

#Pulling out telomeric positions

meth.chrom.starts <- subset(meth.chrom, meth.chrom$start > telomeres.chrom.start$start & meth.chrom$end < telomeres.chrom.start$end)
meth.chrom.ends <- subset(meth.chrom, meth.chrom$start > telomeres.chrom.end$start & meth.chrom$end < telomeres.chrom.end$end)

meth.chrom.starts$pos <- "start"
meth.chrom.ends$pos <- "end"

#Merging the above data frames back into one and cleaning things up !!Decided not to do this, as keeping starts and ends seperate works much quicker in the subsequent steps, will merge later

#meth.telomeres <- rbind(meth.chrom.starts, meth.chrom.ends)

#Cleaning things up

rm(telomeres, telomeres.chrom, telomeres.chrom.end, telomeres.chrom.start)

####Binning the methylation####

#The next two functions help me bin the methylation by a desired window size, this will allow me to group positions to get "average" methylation in 1kb, 10kb, ect. tiles

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

binData <- function(sample, bins) {
  for (i in (seq_len(nrow(sample)))) {
    for (z in (seq_len(nrow(bins)))) {
      if (sample$start[i] %in% seq(from = bins$start[z], to = bins$end[z], by = 1)) {
        sample$bin[i] = bins$bin[z]
      } 
    }
  }
  return(sample)
}

#Creating the bins within the data - doing this seperately for both the starts and ends as it speeds up computation time/reduces resource use

#meth.chrom.bins <- createBins(meth.telomeres$start, meth.telomeres$end, BIN.SIZE)

start.bins <- createBins(meth.chrom.starts$start, meth.chrom.starts$end, BIN.SIZE)
end.bins <- createBins(meth.chrom.ends$start, meth.chrom.ends$end, BIN.SIZE)

#Binning the methylation data

#meth.prebin <- binData(meth.telomeres, meth.chrom.bins)

meth.start.prebin <- binData(meth.chrom.starts, start.bins)
meth.end.prebin <- binData(meth.chrom.ends, end.bins)

#Getting average methylation across each bin

#meth.binned <- setDT(meth.telomeres)[, mean(methylated_frequency), by = bin]

meth.start.binned <- setDT(meth.start.prebin)[, mean(methylated_frequency), by = bin]
meth.end.binned <- setDT(meth.end.prebin)[, mean(methylated_frequency), by = bin]

####Formatting the data####

#Translating the binned data back into ranges

meth.start.bed <- meth.start.binned[match(start.bins$bin, meth.start.binned$bin), 2, drop=F]
meth.end.bed <- meth.end.binned[match(end.bins$bin, meth.end.binned$bin), 2, drop=F]

start.bins$meth <- meth.start.bed$V1
end.bins$meth <- meth.end.bed$V1

#Adding chromosome info
start.bins$chromosome <- CHROMOSOME
end.bins$chromosome <- CHROMOSOME

#Finally merging back together, reordering columns, dropping bin label
merged <- rbind(start.bins, end.bins)

merged <- merged[ ,c(5, 2, 3, 4)]

#Saving bedGraph file for later visualization

OUTBG = paste0(OUTPUT.LOC,CHROMOSOME,'_binned_methylation.bedGraph')

write.table(merged, OUTBG, row.names = FALSE, sep = '\t', quote = FALSE)

#Saving summary txt file so you know what is what


#Cleaning things up

rm(end.bins, meth.chrom.ends, meth.chrom.starts, meth.end.bed, meth.end.binned, meth.end.prebin, meth.start.bed, meth.start.binned, meth.start.prebin, start.bins)

####Plotting methylation#### 



ggplot(PDX661.telomeres, aes(x=start, y=methylated_frequency)) +
  geom_point() +
  facet_wrap(~pos, scales = 'free_x')










