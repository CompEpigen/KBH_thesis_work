####Overview####

#This script is used to plot mean methylation in telomeres and centromeres using Nanopore-derived methylation data
#It will automatically determine which, if any, of these regions have methylation and will then generate plots 


####

#Setting wd
setwd("/icgc/dkfzlsdf/analysis/C010/brooks/downstream/")

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

####Setting Variables####

#Loacation of the meth_freq file
SAMPLE = '/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AR.meth_freq.tsv'
#Sample Name
SAMPLE.NAME = "AR"
#Telomere bed file
TELOMERES = '/icgc/dkfzlsdf/analysis/C010/brooks/hg38_telomere_annots.bed'
#CytoBand txt file containing the centromere coords
CENTROMERES <- "/icgc/dkfzlsdf/analysis/C010/brooks/hg38_cytoband.txt"
#Chromosome of interest, in "chr1" format
CHROMOSOME = "chr12"
#Desired Telomere size
TELOMERE.SIZE = 100000
#Bin size for tiling methylation values
BIN.SIZE = 5000
#Location to write output files 
OUTPUT.LOC = "./GCTB/methylation_analysis/"

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

####Loading files####

#Methylation data
meth <- read.csv(file = SAMPLE, sep = '\t')

#Telomere reference
telomeres <- read.csv(file = TELOMERES, sep = '\t', header = FALSE)

#Loading the cytoband file that will be used to extract centromere locations
centromeres <- read.csv(file = CENTROMERES, sep = '\t', header = FALSE)

####Formatting Telomere/centromere data####

#Renaming telomere and centromere columns for ease of reading
colnames(telomeres) <- c("chromosome", "start", "end")
#Renaming centromere data columns
colnames(centromeres) <- c("chromosome", "start", "end", "loc", "type")

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

#Cleaning things up

rm(telomere.ends, telomere.start)

####Formatting/subsetting methylation data####

#Subsetting all of the datasets for desired chromosome

meth.chrom <- subset(meth, meth$chromosome == CHROMOSOME.ALT)
telomeres.chrom <- subset(telomeres, telomeres$chromosome == CHROMOSOME)
centromere.chrom <- subset(centromeres, centromeres$chromosome == CHROMOSOME & centromeres$type == "acen")

telomeres.chrom.start <- telomeres.chrom[1, ]
telomeres.chrom.end <- telomeres.chrom[2, ]

#From the above subsetting you get 2 different ranges for the centromere, so in this next step I am merging them together to get 1 centromere range
centromere.chrom <- data.frame("chromosome" = CHROMOSOME,
                               "start" = min(centromere.chrom$start),
                               "end" = max(centromere.chrom$end))

#Preserving telomere/centromere coords for figure
PTER.START <- as.numeric(telomeres.chrom.start[,2])
PTER.END <- as.numeric(telomeres.chrom.start[,3])
QTER.START <- as.numeric(telomeres.chrom.end[,2])
QTER.END <- as.numeric(telomeres.chrom.end[,3])
CENT.START <- as.numeric(centromere.chrom[,2])
CENT.END <- as.numeric(centromere.chrom[,3]) 

#Subsetting methylation data to only pull out centromeric & telomeric positions
meth.cent <- subset(meth.chrom, meth.chrom$start > centromere.chrom$start & meth.chrom$end < centromere.chrom$end)
meth.chrom.starts <- subset(meth.chrom, meth.chrom$start > telomeres.chrom.start$start & meth.chrom$end < telomeres.chrom.start$end)
meth.chrom.ends <- subset(meth.chrom, meth.chrom$start > telomeres.chrom.end$start & meth.chrom$end < telomeres.chrom.end$end)

#Now deciding with which regions to continue

if (nrow(meth.cent) == 0) {
  print('No centromeric positions, skipping centromere methylatin analysis...')
} else {
  
  #Assigning postiton factor for final plot
  meth.cent$pos <- "centromere"
  
  #Getting total number of positions in centromere
  CENT.METH <- as.numeric(nrow(meth.cent))
  
  #Extracting bins for use in BED file
  cent.bins <- createBins(meth.cent$start, meth.cent$end, BIN.SIZE)
  
  #Adding annotation to cent.bins
  cent.bins$pos <- 'centromere'
  
  #Binning the methylation data
  meth.cent <- binData(meth.cent, BIN.SIZE)
  
  #Extracting number of bins for summary file
  CENT.BINS <- as.numeric(max(meth.cent$bin))
  
  #Getting number of values for each bin, important for knowing how many data points support each methylation call, and useful for plotting
  cent.bin.sum <- group_by(meth.cent, bin) %>% dplyr::summarise(count = n())
  
  #Getting average methylation across each bin
  meth.cent.mean.binned <- setDT(meth.cent)[, mean(methylated_frequency), by = bin]
  
  #Also getting sd for plots
  meth.cent.sd.binned <- setDT(meth.cent)[, sd(methylated_frequency), by = bin]
  
  #Translating the binned data back into ranges
  
  meth.cent.mean <- meth.cent.mean.binned[match(cent.bins$bin, meth.cent.mean.binned$bin), 2, drop=F]
  
  cent.bins$meth <- meth.cent.mean$V1
  
  meth.cent.sd <- meth.cent.sd.binned[match(cent.bins$bin, meth.cent.sd.binned$bin), 2, drop=F]
  
  cent.bins$sd <- meth.cent.sd$V1
  
  #Adding chromosome info + head/tail info
  
  cent.bins$chromosome <- CHROMOSOME.ALT
  
  #Adding number of samples per bin, have to map it again first and then can add it in
  cent.bin.count <- cent.bin.sum[match(cent.bins$bin, cent.bin.sum$bin), 2, drop=F]
  
  cent.bins$n <- cent.bin.count$count
  
  #Getting min & max coords for plot
  CENT.MIN <- min(cent.bins$start)
  CENT.MAX <- min(cent.bins$end)
  
  #Calculating SEM for positions where it is possible
  cent.bins$sem <- NA
  
  for (i in seq_len(nrow(cent.bins))) {
    if (!is.na(cent.bins$n[i]) & !is.na(cent.bins$sd[i])) {
      cent.bins$sem[i] <- cent.bins$sd[i] / sqrt(cent.bins$n[i])
    } 
  }
  
  
  rm(cent.bin.sum, meth.cent.mean, meth.cent.mean.binned, meth.cent.sd, meth.cent.sd.binned, cent.bin.count)
}

#Now repeating the above for the PTER

if (nrow(meth.chrom.starts) == 0) {
  print('No PTER positions, skipping PTER methylation analysis...')
} else {
  
  meth.chrom.starts$pos <- "pter"
  
  #Getting number of positions for summary file
  PTER.METH <- as.numeric(nrow(meth.chrom.starts))
  
  #Getting pter bins 
  pter.bins <- createBins(meth.chrom.starts$start, meth.chrom.starts$end, BIN.SIZE)
  
  #Adding annotation to pter bin
  pter.bins$pos <- 'pter'
  
  #Binning methylation data
  meth.chrom.starts <- binData(meth.chrom.starts, BIN.SIZE)
  
  #Extracting number of bins for summary file
  PTER.BINS <- as.numeric(max(meth.chrom.starts$bin))
  
  #Getting number of values for each bin, important for knowing how many data points support each methylation call, and useful for plotting
  start.bin.sum <- group_by(meth.chrom.starts, bin) %>% dplyr::summarise(count = n())
  
  #Getting average methylation across each bin
  meth.start.mean.binned <- setDT(meth.chrom.starts)[, mean(methylated_frequency), by = bin]
  
  #Also getting sd for plots
  meth.start.sd.binned <- setDT(meth.chrom.starts)[, sd(methylated_frequency), by = bin]
  
  #Translating the binned data back into ranges
  
  meth.start.mean <- meth.start.mean.binned[match(pter.bins$bin, meth.start.mean.binned$bin), 2, drop=F]
  
  pter.bins$meth <- meth.start.mean$V1
  
  meth.start.sd <- meth.start.sd.binned[match(pter.bins$bin, meth.start.sd.binned$bin), 2, drop=F]
  
  pter.bins$sd <- meth.start.sd$V1
  
  #Adding chromosome info + head/tail info
  pter.bins$chromosome <- CHROMOSOME.ALT
  
  #Adding number of samples per bin
  
  pter.bin.count <- start.bin.sum[match(pter.bins$bin, start.bin.sum$bin), 2, drop=F]
  
  pter.bins$n <- pter.bin.count$count
  
  #Getting pter & qter min/max coords for plots
  PTER.MIN <- min(pter.bins$start)
  PTER.MAX <- max(pter.bins$end)
  
  #Calculating SEM for positions where it is possible
  pter.bins$sem <- NA
  
  for (i in seq_len(nrow(pter.bins))) {
    if (!is.na(pter.bins$n[i]) & !is.na(pter.bins$sd[i])) {
      pter.bins$sem[i] <- pter.bins$sd[i] / sqrt(pter.bins$n[i])
    } 
  }
  
  rm(start.bin.sum, meth.start.mean, meth.start.mean.binned, meth.start.sd, meth.start.sd.binned, pter.bin.count)
}

#Now deciding with which regions to continue

if (nrow(meth.chrom.ends) == 0) {
  print('No QTER positions, skipping QTER methylatin analysis...')
} else {
  meth.chrom.ends$pos <- "qter"
  
  #Getting number of positions for summary file
  QTER.METH <- as.numeric(nrow(meth.chrom.ends))
  
  #Getting pter bins 
  qter.bins <- createBins(meth.chrom.ends$start, meth.chrom.ends$end, BIN.SIZE)
  
  #Adding annotation to qter bin
  qter.bins$pos <- 'qter'
  
  #Binning methylation data
  meth.chrom.ends <- binData(meth.chrom.ends, BIN.SIZE)
  
  #Extracting number of bins for summary file
  QTER.BINS <- as.numeric(max(meth.chrom.ends$bin))
  
  #Getting number of values for each bin, important for knowing how many data points support each methylation call, and useful for plotting
  end.bin.sum <- group_by(meth.chrom.ends, bin) %>% dplyr::summarise(count = n())
  
  #Getting average methylation across each bin
  meth.end.mean.binned <- setDT(meth.chrom.ends)[, mean(methylated_frequency), by = bin]
  
  #Also getting sd for plots
  meth.end.sd.binned <- setDT(meth.chrom.ends)[, sd(methylated_frequency), by = bin]
  
  #Translating the binned data back into ranges
  
  meth.end.mean <- meth.end.mean.binned[match(qter.bins$bin, meth.end.mean.binned$bin), 2, drop=F]
  
  qter.bins$meth <- meth.end.mean$V1
  
  meth.end.sd <- meth.end.sd.binned[match(qter.bins$bin, meth.end.sd.binned$bin), 2, drop=F]
  
  qter.bins$sd <- meth.end.sd$V1
  
  #Adding chromosome info + head/tail info
  qter.bins$chromosome <- CHROMOSOME.ALT
  
  #Adding number of samples per bin
  
  qter.bin.count <- end.bin.sum[match(qter.bins$bin, end.bin.sum$bin), 2, drop=F]
  
  qter.bins$n <- qter.bin.count$count
  
  #Getting pter & qter min/max coords for plots
  QTER.MIN <- min(qter.bins$start)
  QTER.MAX <- max(qter.bins$end)
  
  #Calculating SEM for positions where it is possible
  qter.bins$sem <- NA
  
  for (i in seq_len(nrow(qter.bins))) {
    if (!is.na(qter.bins$n[i]) & !is.na(qter.bins$sd[i])) {
      qter.bins$sem[i] <- qter.bins$sd[i] / sqrt(qter.bins$n[i])
    } 
  }
  
  rm(end.bin.sum, meth.end.mean, meth.end.mean.binned, meth.end.sd, meth.end.sd.binned, qter.bin.count, i)

}


#Now with the above calculations done, I'll check to see what exists, combine it, save stuff, and plot

samples <- 

if (exists(cent.bins)) {samples + "cent.bins"} 
if (exists(pter.bins)) { }
if (exists(qter.bins)) { }


#To remove everything but the meth df:
rm(list=setdiff(ls(), "meth"))
















start.bed <- start.bins[ ,c(5, 2, 3, 4)]

#Saving bedGraph file for later visualization

OUTBG = paste0(OUTPUT.LOC,SAMPLE.NAME,"_",T.CHROM,'_pter_binned_methylation.bedGraph')

write.table(start.bed, OUTBG, row.names = FALSE, sep = '\t', quote = FALSE)

#Saving summary txt file so you know what is what

parameters <- c("chromosome", "alt_chromosome_name", "telomere_size", "bin_size", "output_directory", "methylation_values_in_pter", "bins_in_pter")
values <- c(T.CHROM, CHROMOSOME, TELOMERE.SIZE, BIN.SIZE, OUTPUT.LOC, PTER.METH, PTER.BINS)

analysis.summary <- data.frame(parameters, values)

OUTSUM = paste0(OUTPUT.LOC, SAMPLE.NAME, "_", T.CHROM, '_pter_parameter_summary.txt')

write.table(analysis.summary, OUTSUM, row.names = FALSE, sep = '\t', quote = FALSE)

#Also saving the merged df for easier reference:

OUTMERGE = paste0(OUTPUT.LOC, SAMPLE.NAME, "_", T.CHROM, "_pter_sample_summary.tsv")

write.table(start.bins, OUTMERGE, row.names = FALSE, sep = '\t', quote = FALSE)

#Cleaning things up

rm(meth.chrom.starts, meth.start.mean.bed, meth.start.sd.bed, meth.start.mean.binned, meth.start.sd.binned, meth.start.prebin, start.bin.sum)

####Plotting methylation#### 

#X_SCALE = TELOMERE.SIZE / BIN.SIZE

OUTPNG = paste0(OUTPUT.LOC, SAMPLE.NAME,"_", T.CHROM, '_pter_telomeric_methylation.png')

#jpeg(filename = OUTJPG, width = 948, height = 522)
png(OUTPNG, pointsize=10, width=948, height=522)

ggplot(start.bins, aes(x=bin, y=meth, size = n)) +
  geom_point() +
  geom_line(size = .75) + 
  geom_errorbar(data=start.bins, mapping=aes(x=bin, ymin=(meth-sem), ymax=(meth+sem)), width=0.2, size=.5, color="black") +
  xlab(paste0("Bin","\n", "Sample: ", "pter coords: ", PTER.MIN, "-", PTER.MAX, "\n", "Actual: pter coords: ", PTER.START, "-", PTER.END)) +
  ylab("Methylation Frequency") +
  ggtitle(paste0(SAMPLE.NAME, " ", T.CHROM, " ", "pter mean methylation", ", ","bin size = ", BIN.SIZE, "bp"))



} else if (nrow(meth.chrom.starts) == 0 & nrow(meth.chrom.ends) > 0) {
  
  print('No positions on pter, continuing with qter...')
  
  meth.chrom.ends$pos <- "end"
  
  #Getting number of positions for summary file
  QTER.METH <- as.numeric(nrow(meth.chrom.ends))
  
  #Merging the above data frames back into one and cleaning things up !!Decided not to do this, as keeping starts and ends seperate works much quicker in the subsequent steps, will merge later
  
  #meth.telomeres <- rbind(meth.chrom.starts, meth.chrom.ends)
  
  #Cleaning things up
  
  rm(telomeres, telomeres.chrom, telomeres.chrom.end)
  
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
  
  end.bins <- createBins(meth.chrom.ends$start, meth.chrom.ends$end, BIN.SIZE)
  
  #Extracting number of bins for summary file
  QTER.BINS <- as.numeric(max(end.bins$bin))
  
  #Binning the methylation data
  
  #meth.prebin <- binData(meth.telomeres, meth.chrom.bins)
  
  meth.end.prebin <- binData(meth.chrom.ends, end.bins)
  
  #Getting number of values for each bin, important for knowing how many data points support each methylation call, and useful for plotting
  end.bin.sum <- group_by(meth.end.prebin, bin) %>% dplyr::summarise(count = n())
  
  #Getting average methylation across each bin
  
  #meth.binned <- setDT(meth.telomeres)[, mean(methylated_frequency), by = bin]
  
  meth.end.mean.binned <- setDT(meth.end.prebin)[, mean(methylated_frequency), by = bin]
  
  #Also getting sd for plots
  
  meth.end.sd.binned <- setDT(meth.end.prebin)[, sd(methylated_frequency), by = bin]
  
  ####Formatting the data####
  
  #Translating the binned data back into ranges
  
  meth.end.mean.bed <- meth.end.mean.binned[match(end.bins$bin, meth.end.mean.binned$bin), 2, drop=F]
  
  end.bins$meth <- meth.end.mean.bed$V1
  
  meth.end.sd.bed <- meth.end.sd.binned[match(end.bins$bin, meth.end.sd.binned$bin), 2, drop=F]
  
  end.bins$sd <- meth.end.sd.bed$V1
  
  #Adding chromosome info + head/tail info
  
  end.bins$chromosome <- CHROMOSOME
  
  #Adding number of samples per bin
  
  end.bins$n <- end.bin.sum$count
  
  #Adding proper position notation
  
  end.bins$pos <- 'qter'
  
  #Getting pter & qter min/max coords for plots
  
  QTER.MIN <- min(end.bins$start)
  QTER.MAX <- max(end.bins$end)
  
  
  #Calculated SEM
  end.bins$sem <- end.bins$sd / sqrt(end.bins$n)
  
  end.bed <- end.bins[ ,c(5, 2, 3, 4)]
  
  #Saving bedGraph file for later visualization
  
  OUTBG = paste0(OUTPUT.LOC,SAMPLE.NAME,"_",T.CHROM, '_qter_binned_methylation.bedGraph')
  
  write.table(end.bed, OUTBG, row.names = FALSE, sep = '\t', quote = FALSE)
  
  #Saving summary txt file so you know what is what
  
  parameters <- c("chromosome", "alt_chromosome_name", "telomere_size", "bin_size", "output_directory", "methylation_values_in_qter", "bins_in_qter")
  values <- c(T.CHROM, CHROMOSOME, TELOMERE.SIZE, BIN.SIZE, OUTPUT.LOC, QTER.METH, QTER.BINS)
  
  analysis.summary <- data.frame(parameters, values)
  
  OUTSUM = paste0(OUTPUT.LOC, SAMPLE.NAME, "_", T.CHROM, '_qter_parameter_summary.txt')
  
  write.table(analysis.summary, OUTSUM, row.names = FALSE, sep = '\t', quote = FALSE)
  
  #Also saving the merged df for easier reference:
  
  OUTMERGE = paste0(OUTPUT.LOC, SAMPLE.NAME, "_", T.CHROM, "_qter_sample_summary.tsv")
  
  write.table(end.bins, OUTMERGE, row.names = FALSE, sep = '\t', quote = FALSE)
  
  #Cleaning things up
  
  rm(meth.chrom.ends, meth.end.mean.bed, meth.end.sd.bed, meth.end.mean.binned, meth.end.sd.binned, meth.end.prebin, end.bin.sum)
  
  ####Plotting methylation#### 
  
  #X_SCALE = TELOMERE.SIZE / BIN.SIZE
  
  OUTPNG = paste0(OUTPUT.LOC, SAMPLE.NAME,"_", T.CHROM, '_qter_telomeric_methylation.png')
  
  #jpeg(filename = OUTJPG, width = 948, height = 522)
  png(OUTPNG, pointsize=10, width=948, height=522)
  
  ggplot(end.bins, aes(x=bin, y=meth, size = n)) +
    geom_point() +
    geom_line(size = .75) + 
    geom_errorbar(data=end.bins, mapping=aes(x=bin, ymin=(meth-sem), ymax=(meth+sem)), width=0.2, size=.5, color="black") +
    xlab(paste0("Bin","\n", "Sample: ", "qter coords: ", QTER.MIN, "-", QTER.MAX, "\n", "Actual: ", "qter coords: ", QTER.START, "-", QTER.END)) +
    ylab("Methylation Frequency") +
    ggtitle(paste0(SAMPLE.NAME, " ", T.CHROM, " ", "qter mean methylation", ", ","bin size = ", BIN.SIZE, "bp"))
  
  
  
  
} else {
  print('pter and qter have no positions! Stopping run.')
}

dev.off() #For some reason including this in the if else statement above breaks it and it won't save the png :(












