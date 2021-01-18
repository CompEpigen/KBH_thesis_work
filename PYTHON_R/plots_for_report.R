#Setting WD
setwd("/icgc/dkfzlsdf/analysis/C010/brooks/downstream")

#Loading libraries
library(ggplot2) #ckAML and GCTB (R V. 4.0.0)
library(Gviz) #(R V. 4.0.0)
library(GenomicRanges) #(R V. 4.0.0)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(rtracklayer)
library(circlize) #GCTB (R V. 3.5.3)

####Overview####

#This script contains all the code used for all R-based plots included in my thesis work, it is broken up by project
#Each project needs to be run in a different version of R!! :(

####Loading general needed data####


chroms <- data.frame(
  chrom = c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY"),
  alts = c("NC_000001.11","NC_000002.12","NC_000003.12","NC_000004.12","NC_000005.10","NC_000006.12","NC_000007.14","NC_000008.11","NC_000009.12","NC_000010.11","NC_000011.10","NC_000012.12","NC_000013.11","NC_000014.9","NC_000015.10","NC_000016.10","NC_000017.11","NC_000018.10","NC_000019.10", "NC_000020.11", "NC_000021.9", "NC_000022.11","NC_000023.11", "NC_000024.10" )
)


TELOMERES = '/icgc/dkfzlsdf/analysis/C010/brooks/hg38_telomere_annots.bed'
TELOMERE.SIZE = 100000

#Telomere reference
telomeres <- read.csv(file = TELOMERES, sep = '\t', header = FALSE) 
#Renaming telomere and centromere columns for ease of reading
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


####ckAML####

#This code needs to be run in R v. 4.0.0

#Loading the del7q methylation files that were generated using the do_filter_meth_by_readid.sh script
meth_del <- read.csv(file = "./PDX661/PDX661_del7q_deletion_freq.tsv", sep = '\t')
meth_nodel <- read.csv(file = "./PDX661/PDX661_del7q_nodeletion_freq.tsv", sep = '\t')

#Assigning each data file to a group
meth_del$del7q <- "Yes"
meth_nodel$del7q <- "No"

#Subsetting to only get equivalent positions
meth_del <- subset(meth_del, meth_del$start %in% meth_nodel$start)
meth_nodel <- subset(meth_nodel, meth_nodel$start %in% meth_del$start)

meth_freq_wide <- data.frame(chromosome = meth_del$chromosome,
                                 start = meth_del$start,
                                 end = meth_del$end,
                                 del7q = meth_del$methylated_frequency,
                                 no_del7q = meth_nodel$methylated_frequency)


#Binding the data together
meth_freq_long <- rbind(meth_del, meth_nodel)

#Pulling out cpgs that are in the ROIs
meth.cdk6 <- subset(meth_freq_long, meth_freq_long$start >= 92634292 & meth_freq_long$end <= 92669575)
meth.mnx1 <- subset(meth_freq_long, meth_freq_long$start > 157002751 & meth_freq_long$end < 157008159)

#Labelling the ROIs
meth.cdk6$region <- "CDK6"
meth.mnx1$region <- "MNX1"

#Binding the data again
meth_freq_long <- rbind(meth.cdk6, meth.mnx1)

#Plotting
ggplot(meth_freq_long, aes(x=start, y=methylated_frequency, color=del7q)) + 
  geom_point(size=.5) +
  geom_smooth() +
  ylab("Methylated Frequency") +
  xlab("Position") +
  facet_wrap(~region, scale="free_x")

#Trying to plot using GViz for nicer plots

meth_freq_wide$chromosome <- "chr7"

#Converting the data to GRange objects

meth_gr <- makeGRangesFromDataFrame(meth_freq_wide, 
                                    keep.extra.columns = TRUE,
                                    seqnames.field = 'chromosome',
                                    start.field = 'start',
                                    end.field = 'end')

#Loading gene info

#human.genes <- genes(TxDb.Hsapiens.UCSC.hg38.knownGene)

grtrack <- GeneRegionTrack(TxDb.Hsapiens.UCSC.hg38.knownGene, genome = "hg38",
                           chromosome = "chr7", name = "Genes", 
                           transcriptAnnotation = "symbol",
                           background.panel = "#FFFEDB",
                           background.title = "darkblue",
                           showId=TRUE,
                           geneSymbol=TRUE,
                           id = "id")

# ucscGenes <- UcscTrack(genome = "hg38", 
#                        chromosome = "chr7", 
#                       from = min(start(meth_gr)), 
#                       to = max(end(meth_gr)), 
#                       track = "knownGene", 
#                       trackType = "GeneRegionTrack", 
#                       rstarts = "exonStarts", 
#                       rends = "exonEnds", 
#                       gene = "name", 
#                       symbol = "name", 
#                       transcript = "name", 
#                       strand = "strand", 
#                       fill = "#8282d2", 
#                       name = "Genes",
#                       showId=TRUE,
#                       geneSymbol=TRUE,
#                       id = "id")

#Loadig chromosome track

ideoTrack <- IdeogramTrack(genome = "hg38", chromosome = "chr7")

gatrack = GenomeAxisTrack()

methtrack <- DataTrack(meth_gr, name = "Methylation", chromosome = "chr7")

plotTracks(list(ideoTrack, gatrack, grtrack, methtrack), from =  157002751, to =157008159,
           type = c("smooth", "p"), groups = rep(c("del7q", "no_del7q"), each = 1))

rm(meth_del, meth_freq, meth_nodel, meth.cdk6, meth.mnx1)

####GCTB####

#This code needs to be run in R v. 3.5.3 (circlize) and R v. 4.0.0 (ggplot2)


#Plotting methylation in the telomeres and centromeres
ar.meth <- read.csv(file = "/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AR.meth_freq.tsv", sep = '\t')
as.meth <- read.csv(file = "/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AS.meth_freq.tsv", sep = '\t')

TELOMERES = '/icgc/dkfzlsdf/analysis/C010/brooks/hg38_telomere_annots.bed'
telomeres <- read.csv(file = TELOMERES, sep = '\t', header = FALSE)
colnames(telomeres) <- c("chromosome", "start", "end")

# ar.meth <- subset(ar.meth, ar.meth$chromosome %in% chroms$alts)
# as.meth <- subset(as.meth, as.meth$chromosome %in% chroms$alts)
# 
# ar.pter <- subset(ar.meth, ar.meth$start < 2500000)
# as.pter <- subset(as.meth, as.meth$start < 2500000)
# 
# ar.pter <- subset(ar.pter, ar.pter$called_sites > 10)
# as.pter <- subset(as.pter, as.pter$called_sites > 10)
# 
# ar.pter$pos <- "pter"
# as.pter$pos <- "pter"
# 
# ar.pter$sample <- "AR"
# as.pter$sample <- "AS"
# 
# pter <- rbind(ar.pter, as.pter)


ar.meth <- subset(ar.meth, ar.meth$chromosome %in% chroms$alts)
as.meth <- subset(as.meth, as.meth$chromosome %in% chroms$alts)

ar.meth <- subset(ar.meth, ar.meth$called_sites > 10)
as.meth <- subset(as.meth, as.meth$called_sites > 10)

#for (i in seq_len(nrow(ar.meth))) {
#  if (ar.meth$end[i] < 2500000) {
#    ar.meth$pos[i] <- "pter"
#  } else if (ar.meth$start)
#}






ggplot(pter, aes(x=start, y=methylated_frequency)) + 
  geom_point(size=.1) +
  geom_smooth() +
  ylab("Methylated Frequency") +
  xlab("Position") +
  facet_wrap(~sample) +
  scale_x_continuous(breaks = c(0, 2500000),
               minor_breaks = c(500000, 1000000, 1500000, 2000000),
               labels = c("pter", "+2.5 MB"))

#Need to filter qter based on individual 

#for (i in seq_len(nrow(ar.meth))) {
#  if (ar.meth$chromosome[i] == )
#}




#Plotting tas

library(circlize)

#I will load the AR/AS bedpe files here
ar.bedpe <- read.csv("./GCTB/AR_hg38_ngmlr_1000bp_clipped_split_reads.bedpe", sep = '\t', header = TRUE)
as.bedpe <- read.csv("./GCTB/AS_hg38_ngmlr_1000bp_split_reads.bedpe", sep = '\t', header = TRUE)

#There are blanks in this dataframe, those come from positions that mapped to the weird chromosomes and can be excluded
ar.bedpe <- ar.bedpe[!(!is.na(ar.bedpe$chrom2) & ar.bedpe$chrom2==""), ]
ar.bedpe <- ar.bedpe[!(!is.na(ar.bedpe$chrom1) & ar.bedpe$chrom1==""), ]

as.bedpe <- as.bedpe[!(!is.na(as.bedpe$chrom2) & as.bedpe$chrom2==""), ]
as.bedpe <- as.bedpe[!(!is.na(as.bedpe$chrom1) & as.bedpe$chrom1==""), ]

#Refactorizing
ar.bedpe$chrom1 <- factor(ar.bedpe$chrom1, levels = chroms$chrom)
ar.bedpe$chrom2 <- factor(ar.bedpe$chrom2, levels = chroms$chrom)

as.bedpe$chrom1 <- factor(as.bedpe$chrom1, levels = chroms$chrom)
as.bedpe$chrom2 <- factor(as.bedpe$chrom2, levels = chroms$chrom)

#Then I will filter for telomeric fusions by subsetting the data to only include positions in the telomeres (±100kb)




#Then I will convert the data to the adjacency data needed by circlize
ar.adjacencyData <- with(ar.bedpe, table(chrom1, chrom2))
as.adjacencyData <- with(as.bedpe, table(chrom1, chrom2))

#Then I will plot

#All positions
chordDiagram(ar.adjacencyData, transparency = 0.5)
chordDiagram(as.adjacencyData, transparency = 0.5)






#Just those with one in a telomere
ar.tel.bedpe <- subset(ar.bedpe, ar.bedpe$end1 < 100000 | ar.bedpe$end2 < 100000)

ar.tel.adjacencyData <- with(ar.tel.bedpe, table(chrom1, chrom2))

chordDiagram(ar.tel.adjacencyData, transparency = 0.5, scale = TRUE)










