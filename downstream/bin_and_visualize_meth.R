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
#Chromosome of interest, in "NC_000001.11" format <- now automated
#CHROMOSOME = "NC_000016.10"
#Chromosome of interest, in "chr1" format
T.CHROM = "chr12"
#Desired Telomere size
TELOMERE.SIZE = 100000
#Bin size for tiling methylation values
BIN.SIZE = 5000
#Location to write output files 
OUTPUT.LOC = "./GCTB/methylation_analysis/"

#Getting alternative chromosome name and setting "CHROMOSOME" variable

chroms <- data.frame(
  chrom = c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY"),
  alts = c("NC_000001.11","NC_000002.12","NC_000003.12","NC_000004.12","NC_000005.10","NC_000006.12","NC_000007.14","NC_000008.11","NC_000009.12","NC_000010.11","NC_000011.10","NC_000012.12","NC_000013.11","NC_000014.9","NC_000015.10","NC_000016.10","NC_000017.11","NC_000018.10","NC_000019.10", "NC_000020.11", "NC_000021.9", "NC_000022.11","NC_000023.11", "NC_000024.10" )
)

if (T.CHROM %in% chroms$chrom) {
  pos <- as.numeric(match(T.CHROM, chroms$chrom))
  CHROMOSOME <- as.character(chroms$alt[pos])
} else {
  print("Unrecognized chromosome!")
  break
}

####Loading files####

#Telomere reference
telomeres <- read.csv(file = TELOMERES, sep = '\t', header = FALSE)

#Methylation data
meth <- read.csv(file = SAMPLE, sep = '\t')

####Formatting Telomere data####

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

#Cleaning things up

rm(telomere.ends, telomere.start)

####Formatting/subsetting methylation data####

#Subsetting both of the datasets for desired chromosome

meth.chrom <- subset(meth, meth$chromosome == CHROMOSOME)
telomeres.chrom <- subset(telomeres, telomeres$chromosome == T.CHROM)

telomeres.chrom.start <- telomeres.chrom[1, ]
telomeres.chrom.end <- telomeres.chrom[2, ]

#Preserving telomere coords for figure
PTER.START <- as.numeric(telomeres.chrom.start[,2])
PTER.END <- as.numeric(telomeres.chrom.start[,3])
QTER.START <- as.numeric(telomeres.chrom.end[,2])
QTER.END <- as.numeric(telomeres.chrom.end[,3])


#Pulling out telomeric positions out of methylation data

meth.chrom.starts <- subset(meth.chrom, meth.chrom$start > telomeres.chrom.start$start & meth.chrom$end < telomeres.chrom.start$end)
meth.chrom.ends <- subset(meth.chrom, meth.chrom$start > telomeres.chrom.end$start & meth.chrom$end < telomeres.chrom.end$end)





####Plotting methylation#####

if (nrow(meth.chrom.starts) > 0 & nrow(meth.chrom.ends) > 0) {
  
  print('Both pter and qter have positions, continuing with both...')
  
  meth.chrom.starts$pos <- "start"
  meth.chrom.ends$pos <- "end"
  
  #Getting number of positions for summary file
  PTER.METH <- as.numeric(nrow(meth.chrom.starts))
  QTER.METH <- as.numeric(nrow(meth.chrom.ends))
  
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
  
  #Extracting number of bins for summary file
  PTER.BINS <- as.numeric(max(start.bins$bin))
  QTER.BINS <- as.numeric(max(end.bins$bin))
  
  #Binning the methylation data
  
  meth.start.prebin <- binData(meth.chrom.starts, start.bins)
  meth.end.prebin <- binData(meth.chrom.ends, end.bins)
  
  #Getting number of values for each bin, important for knowing how many data points support each methylation call, and useful for plotting
  
  start.bin.sum <- group_by(meth.start.prebin, bin, .drop = FALSE) %>% dplyr::summarise(count = n())
  end.bin.sum <- group_by(meth.end.prebin, bin, .drop = FALSE) %>% dplyr::summarise(count = n())
  
  #Getting average methylation across each bin
  
  meth.start.mean.binned <- setDT(meth.start.prebin)[, mean(methylated_frequency), by = bin]
  meth.end.mean.binned <- setDT(meth.end.prebin)[, mean(methylated_frequency), by = bin]
  
  #Also getting sd for plots
  
  meth.start.sd.binned <- setDT(meth.start.prebin)[, sd(methylated_frequency), by = bin]
  meth.end.sd.binned <- setDT(meth.end.prebin)[, sd(methylated_frequency), by = bin]
  
  ####Formatting the data####
  
  #Translating the binned data back into ranges
  
  meth.start.mean.bed <- meth.start.mean.binned[match(start.bins$bin, meth.start.mean.binned$bin), 2, drop=F]
  meth.end.mean.bed <- meth.end.mean.binned[match(end.bins$bin, meth.end.mean.binned$bin), 2, drop=F]
  
  start.bins$meth <- meth.start.mean.bed$V1
  end.bins$meth <- meth.end.mean.bed$V1
  
  meth.start.sd.bed <- meth.start.sd.binned[match(start.bins$bin, meth.start.sd.binned$bin), 2, drop=F]
  meth.end.sd.bed <- meth.end.sd.binned[match(end.bins$bin, meth.end.sd.binned$bin), 2, drop=F]
  
  start.bins$sd <- meth.start.sd.bed$V1
  end.bins$sd <- meth.end.sd.bed$V1
  
  #Adding chromosome info + head/tail info
  start.bins$chromosome <- CHROMOSOME
  end.bins$chromosome <- CHROMOSOME
  
  #Adding number of samples per bin 
  #Have to account for the fact that some bins might not have any values
 !!!!! Have to figure this out!!!
    
    
  for (i in seq_len(nrow(start.bins))) {
    if (start.bins$bin %in% start.bin.sum$bin & start.bins$bin[i] == start.bin.sum$bin[i]) {
      start.bins$n[i] <- start.bin.sum$count[i]
    } else
      start.bins$n[i] <- 0
      i + 1
  }
  
  
  start.bins$n <- start.bin.sum$count
  end.bins$n <- end.bin.sum$count
  
  #Adding proper position notation
  
  start.bins$pos <- 'pter'
  end.bins$pos <- 'qter'
  
  #Getting pter & qter min/max coords for plots
  PTER.MIN <- min(start.bins$start)
  PTER.MAX <- max(start.bins$end)
  QTER.MIN <- min(end.bins$start)
  QTER.MAX <- max(end.bins$end)
  
  #Finally merging back together, reordering columns, dropping bin label
  merged <- rbind(start.bins, end.bins)
  
  #Calculated SEM
  merged$sem <- merged$sd / sqrt(merged$n)
  
  merged.bed <- merged[ ,c(5, 2, 3, 4)]
  
  #Saving bedGraph file for later visualization
  
  OUTBG = paste0(OUTPUT.LOC,SAMPLE.NAME,"_",T.CHROM,'_binned_methylation.bedGraph')
  
  write.table(merged.bed, OUTBG, row.names = FALSE, sep = '\t', quote = FALSE)
  
  #Saving summary txt file so you know what is what
  
  parameters <- c("chromosome", "alt_chromosome_name", "telomere_size", "bin_size", "output_directory", "methylation_values_in_pter", "methylation_values_in_qter", "bins_in_pter", "bins_in_qter")
  values <- c(T.CHROM, CHROMOSOME, TELOMERE.SIZE, BIN.SIZE, OUTPUT.LOC, PTER.METH, QTER.METH, PTER.BINS, QTER.BINS)
  
  analysis.summary <- data.frame(parameters, values)
  
  OUTSUM = paste0(OUTPUT.LOC, SAMPLE.NAME, "_", T.CHROM, '_parameter_summary.txt')
  
  write.table(analysis.summary, OUTSUM, row.names = FALSE, sep = '\t', quote = FALSE)
  
  #Also saving the merged df for easier reference:
  
  OUTMERGE = paste0(OUTPUT.LOC, SAMPLE.NAME, "_", T.CHROM, "_sample_summary.tsv")
  
  write.table(merged, OUTMERGE, row.names = FALSE, sep = '\t', quote = FALSE)
  
  #Cleaning things up
  
  rm(end.bins, meth.chrom.ends, meth.chrom.starts, meth.end.mean.bed, meth.end.sd.bed, meth.end.mean.binned, meth.end.sd.binned, meth.end.prebin, meth.start.mean.bed, meth.start.sd.bed, meth.start.mean.binned, meth.start.sd.binned, meth.start.prebin, start.bins, start.bin.sum, end.bin.sum)
  
  ####Plotting methylation#### 
  
  #X_SCALE = TELOMERE.SIZE / BIN.SIZE
  
  OUTPNG = paste0(OUTPUT.LOC, SAMPLE.NAME,"_", T.CHROM, '_telomeric_methylation.png')
  
  #jpeg(filename = OUTJPG, width = 948, height = 522)
  png(OUTPNG, pointsize=10, width=948, height=522)
  
  ggplot(merged, aes(x=bin, y=meth, size = n)) +
    geom_point() +
    geom_line(size = .75) + 
    geom_errorbar(data=merged, mapping=aes(x=bin, ymin=(meth-sem), ymax=(meth+sem)), width=0.2, size=.5, color="black") +
    facet_wrap(~pos, scales = 'fixed') +
    xlab(paste0("Bin","\n", "Sample: ", "pter coords: ", PTER.MIN, "-", PTER.MAX, ", ", "qter coords: ", QTER.MIN, "-", QTER.MAX, "\n", "Actual: pter coords: ", PTER.START, "-", PTER.END, ", ", "qter coords: ", QTER.START, "-", QTER.END)) +
    ylab("Methylation Frequency") +
    ggtitle(paste0(SAMPLE.NAME, " ", T.CHROM, " ", "telomeric mean methylation", ", ","bin size = ", BIN.SIZE, "bp"))
  

  
} else if (nrow(meth.chrom.starts) > 0 & nrow(meth.chrom.ends) == 0) {
  
  print('No positions on qter, continuing with pter...')
  
  meth.chrom.starts$pos <- "start"
  
  #Getting number of positions for summary file
  PTER.METH <- as.numeric(nrow(meth.chrom.starts))
  
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
  
  
  #Extracting number of bins for summary file
  PTER.BINS <- as.numeric(max(start.bins$bin))
  
  #Binning the methylation data
  
  #meth.prebin <- binData(meth.telomeres, meth.chrom.bins)
  
  meth.start.prebin <- binData(meth.chrom.starts, start.bins)
  
  #Getting number of values for each bin, important for knowing how many data points support each methylation call, and useful for plotting
  start.bin.sum <- group_by(meth.start.prebin, bin) %>% dplyr::summarise(count = n())
  
  #Getting average methylation across each bin
  
  #meth.binned <- setDT(meth.telomeres)[, mean(methylated_frequency), by = bin]
  
  meth.start.mean.binned <- setDT(meth.start.prebin)[, mean(methylated_frequency), by = bin]
  
  #Also getting sd for plots
  
  meth.start.sd.binned <- setDT(meth.start.prebin)[, sd(methylated_frequency), by = bin]
  
  ####Formatting the data####
  
  #Translating the binned data back into ranges
  
  meth.start.mean.bed <- meth.start.mean.binned[match(start.bins$bin, meth.start.mean.binned$bin), 2, drop=F]
  
  start.bins$meth <- meth.start.mean.bed$V1
  
  meth.start.sd.bed <- meth.start.sd.binned[match(start.bins$bin, meth.start.sd.binned$bin), 2, drop=F]
  
  start.bins$sd <- meth.start.sd.bed$V1
  
  #Adding chromosome info + head/tail info
  start.bins$chromosome <- CHROMOSOME
  
  #Adding number of samples per bin
  
  start.bins$n <- start.bin.sum$count
  
  #Adding proper position notation
  
  start.bins$pos <- 'pter'
  
  #Getting pter & qter min/max coords for plots
  PTER.MIN <- min(start.bins$start)
  PTER.MAX <- max(start.bins$end)
  
  
  #Calculated SEM
  start.bins$sem <- start.bins$sd / sqrt(start.bins$n)
  
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

#To remove everything but the meth df:
rm(list=setdiff(ls(), "meth"))



##########################################


#Testing

#ggplot(merged, aes(x=bin, y=meth, size = n)) +
#  geom_point() +
#  geom_line(size = .75) + 
#  geom_errorbar(data=merged, mapping=aes(x=bin, ymin=(meth-sem), ymax=(meth+sem)), width=0.2, size=.5, color="black") +
#  facet_wrap(~pos, scales = 'fixed') +
#  xlab(paste0("Bin","\n", "Sample: ", "pter coords: ", PTER.MIN, "-", PTER.MAX, ", ", "qter coords: ", QTER.MIN, "-", QTER.MAX, "\n", "Actual: pter coords: ", PTER.START, "-", PTER.END, ", ", "qter coords: ", QTER.START, "-", QTER.END)) +
#  ylab("Methylation Frequency") +
#  ggtitle(paste0(SAMPLE.NAME, " ", T.CHROM, " ", "telomeric mean methylation", ", ","bin size = ", BIN.SIZE, "bp"))



#Playing around with adding centromere info

#CytoBand txt file containing the centromere coords
CENTROMERES <- "/icgc/dkfzlsdf/analysis/C010/brooks/hg38_cytoband.txt"

#Loading the cytoband file that will be used to extract centromere locations
centromeres <- read.csv(file = CENTROMERES, sep = '\t', header = FALSE)

#Renaming centromere data columns
colnames(centromeres) <- c("chromosome", "start", "end", "loc", "type")

#Subsetting for chromosome of interest
centromere.chrom <- subset(centromeres, centromeres$chromosome == T.CHROM & centromeres$type == "acen")

#From the above subsetting you get 2 different ranges, so in this next step I am merging them together to get 1 centromere range
centromere.chrom <- data.frame("chromosome" = T.CHROM,
                               "start" = min(centromere.chrom$start),
                               "end" = max(centromere.chrom$end))

meth.chrom <- subset(meth, meth$chromosome == CHROMOSOME)

#Subsetting methylation data to only pull out centromeric positions
meth.cent <- subset(meth.chrom, meth.chrom$start > centromere.chrom$start & meth.chrom$end < centromere.chrom$end)

#Creating centromere bins
cent.bins <- createBins(meth.cent$start, meth.cent$end, BIN.SIZE)

#Extracting number of bins for summary file
CENT.BINS <- as.numeric(max(cent.bins$bin))

#A bit of a hacky workaround, but filling in the last bins as they will be missed in the next part
#meth.cent$bin <- max(cent.bins$bin)


binData <- function(sample, bin_size) {
  sample$bin <- 1+floor((sample$start-sample$start[1])/bin_size)
  return (sample)
}

test <- binData(meth.chrom.starts, BIN.SIZE)

test.bins <- createBins(meth.chrom.starts$start, meth.chrom.starts$end, BIN.SIZE)
test2 <- cut(meth.chrom.starts$end, test.bins$start, labels = FALSE, include.lowest = TRUE, right = TRUE)


#Binning the methylation data
meth.cent.prebin <- cut(meth.cent$end, cent.bins$start, labels = FALSE, include.lowest = TRUE, right = TRUE)

#Adding bin info to methylation data
meth.cent$bin <- meth.cent.prebin

#Replacing tail NA values with actual bin number
meth.cent$bin[is.na(meth.cent$bin)] <- as.numeric(max(cent.bins$bin))

#Getting number of values for each bin, important for knowing how many data points support each methylation call, and useful for plotting
cent.bin.sum <- group_by(meth.cent, bin) %>% dplyr::summarise(count = n())

#Getting average methylation across each bin
meth.cent.mean.binned <- setDT(meth.cent)[, mean(methylated_frequency), by = bin]

#Also getting sd for plots
meth.cent.sd.binned <- setDT(meth.cent)[, sd(methylated_frequency), by = bin]

#Translating the binned data back into ranges

meth.cent.mean.bed <- meth.cent.mean.binned[match(cent.bins$bin, meth.cent.mean.binned$bin), 2, drop=F]

cent.bins$meth <- meth.cent.mean.bed$V1

meth.cent.sd.bed <- meth.cent.sd.binned[match(cent.bins$bin, meth.cent.sd.binned$bin), 2, drop=F]

cent.bins$sd <- meth.cent.sd.bed$V1

#Adding chromosome info + head/tail info

cent.bins$chromosome <- CHROMOSOME

#Adding number of samples per bin, have to map it again first and then can add it in
cent.bin.count <- cent.bin.sum[match(cent.bins$bin, cent.bin.sum$bin), 2, drop=F]

cent.bins$n <- cent.bin.count$count

#Getting min & max coords for plot
CENT.MIN <- min(cent.bins$start)
CENT.MAX <- min(cent.bins$end)

#Calculating SEM
cent.bins$sem <- cent.bins$sd / sqrt(cent.bins$n)

#Formatting for BED file
cent.bed <- cent.bins[, c("chromosome", "start", "end", "meth")]

ggplot(cent.bins, aes(x=bin, y=meth, size = n)) +
  geom_point() +
  geom_line(size = .75) + 
  geom_errorbar(data=cent.bins, mapping=aes(x=bin, ymin=(meth-sem), ymax=(meth+sem)), width=0.2, size=.5, color="black") #+
  #facet_wrap(~pos, scales = 'fixed') +
  #xlab(paste0("Bin","\n", "Sample: ", "pter coords: ", PTER.MIN, "-", PTER.MAX, ", ", "qter coords: ", QTER.MIN, "-", QTER.MAX, "\n", "Actual: pter coords: ", PTER.START, "-", PTER.END, ", ", "qter coords: ", QTER.START, "-", QTER.END)) +
  #ylab("Methylation Frequency") +
  #ggtitle(paste0(SAMPLE.NAME, " ", T.CHROM, " ", "telomeric mean methylation", ", ","bin size = ", BIN.SIZE, "bp"))
#############################################



