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
#Centromere bin size
C.BIN.SIZE = 10000
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
  cent.bins <- createBins(meth.cent$start, meth.cent$end, C.BIN.SIZE)
  
  #Adding annotation to cent.bins
  cent.bins$pos <- 'centromere'
  
  #Binning the methylation data
  meth.cent <- binData(meth.cent, C.BIN.SIZE)
  
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

samples <- c()

if (exists("cent.bins")) { samples <- cent.bins} 
if (exists("pter.bins")) { samples <- rbind(samples, pter.bins)}
if (exists("qter.bins")) { samples <- rbind(samples, qter.bins)}

#making position a factor and ordering:
samples$pos <- factor(samples$pos, levels = c('pter', 'centromere', 'qter'))

#Making and saving BED file
bed.file <- samples[ , c('chromosome', 'start', 'end', 'meth')]

OUTBG = paste0(OUTPUT.LOC,SAMPLE.NAME,"_",CHROMOSOME,'_binned_methylation.bedGraph')

write.table(bed.file, OUTBG, row.names = FALSE, sep = '\t', quote = FALSE)

#Making and saving the merged file:
OUTMERGE = paste0(OUTPUT.LOC, SAMPLE.NAME, "_",CHROMOSOME, "_sample_summary.tsv")

write.table(samples, OUTMERGE, row.names = FALSE, sep = '\t', quote = FALSE)

####Plotting methylation#### 
OUTPNG = paste0(OUTPUT.LOC, SAMPLE.NAME,"_",CHROMOSOME, '_binned_methylation.png')

#jpeg(filename = OUTJPG, width = 948, height = 522)
png(OUTPNG, pointsize=10, width=948, height=522)

ggplot(samples, aes(x=bin, y=meth, size = n)) +
  geom_point() +
  geom_line(size = .75) + 
  facet_wrap(~pos, scales = 'free_x') +
  geom_errorbar(data=samples, mapping=aes(x=bin, ymin=(meth-sem), ymax=(meth+sem)), width=0.2, size=.5, color="black") +
  xlab("Bin") +
  ylab("Methylation Frequency") +
  ggtitle(paste0(SAMPLE.NAME, " ", CHROMOSOME, " ", "mean methylation", ", ","bin size = ", BIN.SIZE, "bp", ", ","centromere bin size = ", C.BIN.SIZE, "bp"))

dev.off()






#To remove everything but the meth df:
rm(list=setdiff(ls(), "meth"))





