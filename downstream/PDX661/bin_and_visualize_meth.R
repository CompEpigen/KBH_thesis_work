setwd("/icgc/dkfzlsdf/analysis/C010/brooks/downstream/PDX661")

library(base, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(Rcpp, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(plyr, lib.loc = "/home/k001y/R/x86_64-pc-linux-gnu-library/3.5/")
library(crayon, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(backports, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(vctrs, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(dplyr, lib.loc = "/software/r/3.5.1/lib64/R/library")
library(data.table, lib.loc = "/home/k001y/R/x86_64-pc-linux-gnu-library/3.5/")


#Here I am binning methylation values for chromosome 7, and then visualizing them using ggplot

PDX661 <- read.csv(file = '/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/PDX661/PDX661.meth_freq.tsv', sep = '\t')

PDX661 <- subset(PDX661, PDX661$chromosome == "NC_000007.14")

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


PDX661.bins <- createBins(PDX661$start, PDX661$end, 1000)
PDX661 <- binData(PDX661, PDX661.bins)

PDX661.binned <- setDT(PDX661)[, mean(methylated_frequency), by = bin]

PDX661.bed <- PDX661.binned[match(PDX661.bins$bin, PDX661.binned$bin), 2, drop=F]

PDX661.bins$meth <- PDX661.bed$V1

PDX661.bins$chromosome <- 'NC_000007.14'

PDX661.bins <- PDX661.bins[ ,c(5, 2, 3, 4)]

write.csv(PDX661.bins, "./pdx661_chr7_meth.bedGraph", row.names = FALSE, sep = '\t')

