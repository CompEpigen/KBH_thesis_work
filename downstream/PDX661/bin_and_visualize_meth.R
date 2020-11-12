

library(ggplot2)
library(RColorBrewer)
library(dplyr)
library(rtracklayer)
library(data.table)
library(OneR)

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

PDX661$bins <- NA
PDX661.bins <- createBins(PDX661$start, PDX661$end, 1000)
PDX661 <- binData(PDX661, PDX661.bins)

PDX661.binned <- setDT(PDX661)[, mean(methylated_frequency), by = bin]


ggplot(all.binned, aes(x=pos, y=V1, color=sample)) +
  geom_point(size=.25) +
  geom_line() +
  scale_y_continuous(name='Methylated Frequency') +
  scale_x_continuous(name='Position', breaks = c(65560000, 65564174, 65569000), limits =c(65560000, 65569000)) 





