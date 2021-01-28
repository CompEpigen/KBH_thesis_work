#Setting WD
setwd("/icgc/dkfzlsdf/analysis/C010/brooks/downstream")

#Loading libraries
library(ggplot2) #ckAML and GCTB (R V. 4.0.0)
library(Gviz) #(R V. 4.0.0)
library(GenomicRanges) #(R V. 4.0.0)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(rtracklayer)
library(circlize) #GCTB (R V. 3.5.3)
library(dplyr)
library(RColorBrewer)
library(org.Hs.eg.db)
library(Biostrings)


####Overview####

#This script contains all the code used for all R-based plots included in my thesis work, it is broken up by project
#Each project needs to be run in a different version of R!! :(

####Loading general needed data####


chroms <- data.frame(
  chrom = c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX"),
  alts = c("NC_000001.11","NC_000002.12","NC_000003.12","NC_000004.12","NC_000005.10","NC_000006.12","NC_000007.14","NC_000008.11","NC_000009.12","NC_000010.11","NC_000011.10","NC_000012.12","NC_000013.11","NC_000014.9","NC_000015.10","NC_000016.10","NC_000017.11","NC_000018.10","NC_000019.10", "NC_000020.11", "NC_000021.9", "NC_000022.11","NC_000023.11")
)


TELOMERES = '/icgc/dkfzlsdf/analysis/C010/brooks/hg38_telomere_annots.bed'
 TELOMERE.SIZE = 100000
# 
# #Telomere reference
 telomeres <- read.csv(file = TELOMERES, sep = '\t', header = FALSE) 
 #Renaming telomere and centromere columns for ease of reading
 colnames(telomeres) <- c("chromosome", "start", "end")
# 
# #Expanding telomeres to be the desired size
# 
telomere.start <- subset(telomeres, telomeres$start == 0)
telomere.ends <- subset(telomeres, telomeres$start != 0)

telomeres.alt <- data.frame(chrom = chroms$chrom,
                            pter_end = telomere.start$end,
                            qter_start = telomere.ends$start)


rm(telomere.ends, telomere.start, telomeres, TELOMERE.SIZE, TELOMERES)
# if (TELOMERE.SIZE != 100000) {
#   telomere.ends$start <- (telomere.ends$start + 10000) - TELOMERE.SIZE 
# } else {
#   telomere.ends$start <- (telomere.ends$start - 90000)
# }
# 
# if (TELOMERE.SIZE != 100000) {
#   telomere.start$end <- (telomere.start$end - 100000) + TELOMERE.SIZE 
# } else {
#   telomere.start$end <- (telomere.start$end)
# }
# 
# telomeres <- rbind(telomere.start, telomere.ends)
# 
# #Cleaning things up
# 
# rm(telomere.ends, telomere.start)

#Using chm13 telomere


ref <- readDNAStringSet("/icgc/dkfzlsdf/analysis/C010/brooks/chm13.draft_v1.0.fasta", format = "fasta")

qter_starts <- c(length(ref$chr1), length(ref$chr2), length(ref$chr3), length(ref$chr4), length(ref$chr5), length(ref$chr6),
                 length(ref$chr7), length(ref$chr8), length(ref$chr9), length(ref$chr10), length(ref$chr11), length(ref$chr12), 
                 length(ref$chr13), length(ref$chr14), length(ref$chr15), length(ref$chr16), length(ref$chr17), length(ref$chr18), 
                 length(ref$chr19), length(ref$chr20), length(ref$chr21), length(ref$chr22), length(ref$chrX))

qter_starts = qter_starts - 100000

telomeres.alt <- data.frame(chrom = chroms$chrom,
                                  pter_end = rep(100000, 23),
                                  qter_start = qter_starts)

rm(ref, qter_starts)



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
                           gene = "MNX1",
                           transcriptAnnotation = "symbol",
                           background.panel = "#FFFEDB",
                           background.title = "darkblue",
                           showId=TRUE,
                           geneSymbol=TRUE,
                           id = "id")

#This next bit of ugly code is to get human-readable gene names, found via: https://support.bioconductor.org/p/69602/
z <- mapIds(org.Hs.eg.db, gene(grtrack), "SYMBOL", "ENTREZID", multiVals = "first")
zz <- sapply(z, is.null)
z[zz] <- gene(grtrack)[zz]
gr <- ranges(grtrack)
mcols(gr)$symbol <- z

grtrack@range <- gr

#Loading chromosome track

ideoTrack <- IdeogramTrack(genome = "hg38", chromosome = "chr7")

#Loading scale bar

gatrack = GenomeAxisTrack()

#Loading methylation data

methtrack <- DataTrack(meth_gr, name = "Methylation", chromosome = "chr7", background.title = "darkred")

#Plotting MNX1 region

plotTracks(list(ideoTrack, gatrack, grtrack, methtrack), from =  157002751, to =157008159,
           type = c("smooth", "p"), groups = rep(c("del7q + INV", "No del7q"), each = 1))

#CDK6 region

plotTracks(list(ideoTrack, gatrack, grtrack, methtrack), from = 92634292, to = 92669575,
           type = c("smooth", "p"), groups = rep(c("del7q + INV", "No del7q"), each = 1))


rm(meth_del, meth_freq, meth_nodel, meth.cdk6, meth.mnx1)

####GCTB####

#This code needs to be run in R v. 3.5.3 (circlize) and R v. 4.0.0 (ggplot2)


#Plotting methylation in the telomeres and centromeres
#ar.meth <- read.csv(file = "/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AR.meth_freq.tsv", sep = '\t')
#as.meth <- read.csv(file = "/icgc/dkfzlsdf/analysis/C010/brooks/master_pipeline/output/GCTB/AS.meth_freq.tsv", sep = '\t')

as.bs.meth <- read.csv(file = "/icgc/dkfzlsdf/analysis/C010/brooks/downstream/GCTB/AS_bismark_TtoT_100000bp_telomeric_meth.tsv", header = TRUE, sep = '\t')
as.np.meth <- read.csv(file = "/icgc/dkfzlsdf/analysis/C010/brooks/downstream/GCTB/AS_nanopore_TtoT_100000bp_telomeric_meth.tsv", header = TRUE, sep = '\t')

as.bs.meth$freq <- as.bs.meth$freq / 100

as.bs.meth$method <- "WGBS"
as.np.meth$method <- "Nanopore"

meth <- rbind(as.bs.meth, as.np.meth)

#Reordering factor levels

meth$chromosome <- factor(meth$chromosome, levels = chroms$chrom)

meth <- na.omit(meth)

rm(as.bs.meth, as.np.meth)

for (i in seq_len(nrow(meth))) {
  if (meth$start[i] < 100000) {
    meth$pos[i] <- "pter"
  } else {
    meth$pos[i] <- "qter"
  }
}

#Because the figure is too big if I plot all chromosomes at the same time, I'll break it up into 3 chunks

meth_1thru9 <- subset(meth, meth$chromosome %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9"))
meth_10thru18 <- subset(meth, meth$chromosome %in% c("chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18"))
meth_19thruX <- subset(meth, meth$chromosome %in% c("chr19", "chr21", "chr22", "chrX"))

#This plot below was for all chromosomes, too big to nicely fit in one figure

# ggplot(meth, aes(x=start, y=freq, color=method)) + 
#   geom_point(size=.1) +
#   geom_smooth() +
#   ylab("Methylated Frequency") +
#   xlab("Position") +
#   facet_wrap(~chromosome+pos, scales = "free", ncol = 2) +
#   theme_classic()#+

#Plotting for each chunk

ggplot(meth_1thru9, aes(x=start, y=freq, color=method)) + 
   geom_point(size=.1) +
   geom_smooth() +
   ylab("Methylated Frequency") +
   xlab("Position") +
   facet_wrap(~chromosome+pos, scales = "free", ncol = 2) +
   theme_classic()#+


ggplot(meth_10thru18, aes(x=start, y=freq, color=method)) + 
  geom_point(size=.1) +
  geom_smooth() +
  ylab("Methylated Frequency") +
  xlab("Position") +
  facet_wrap(~chromosome+pos, scales = "free", ncol = 2) +
  theme_classic()#+


ggplot(meth_19thruX, aes(x=start, y=freq, color=method)) + 
  geom_point(size=.1) +
  geom_smooth() +
  ylab("Methylated Frequency") +
  xlab("Position") +
  facet_wrap(~chromosome+pos, scales = "free", ncol = 2) +
  theme_classic()#+



meth.sub <- meth
meth.sub$n <- meth.sub$n_meth + meth.sub$n_unmeth
meth.sub <- subset(meth.sub, meth.sub$n > 10)

meth_sub_1thru9 <- subset(meth.sub, meth.sub$chromosome %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9"))
meth_sub_10thru18 <- subset(meth.sub, meth.sub$chromosome %in% c("chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18"))
meth_sub_19thruX <- subset(meth.sub, meth.sub$chromosome %in% c("chr19", "chr21", "chr22", "chrX"))

# ggplot(meth.sub, aes(x=start, y=freq, color=method)) + 
#   geom_point(size=.1) +
#   geom_smooth() +
#   ylab("Methylated Frequency") +
#   xlab("Position") +
#   facet_wrap(~chromosome+pos, scales = "free", ncol = 2) #+

meth_sub_1thru9 <- na.omit(meth_sub_1thru9)
meth_sub_10thru18 <- na.omit(meth_sub_10thru18)
meth_sub_19thruX <- na.omit(meth_sub_19thruX)

ggplot(meth_sub_1thru9, aes(x=start, y=freq, color=method)) + 
  geom_point(size=.1) +
  geom_smooth() +
  ylab("Methylated Frequency") +
  xlab("Position") +
  facet_wrap(~chromosome+pos, scales = "free", ncol = 2) #+

ggplot(meth_sub_10thru18, aes(x=start, y=freq, color=method)) + 
  geom_point(size=.1) +
  geom_smooth() +
  ylab("Methylated Frequency") +
  xlab("Position") +
  facet_wrap(~chromosome+pos, scales = "free", ncol = 2) #+

ggplot(meth_sub_19thruX, aes(x=start, y=freq, color=method)) + 
  geom_point(size=.1) +
  geom_smooth() +
  ylab("Methylated Frequency") +
  xlab("Position") +
  facet_wrap(~chromosome+pos, scales = "free", ncol = 2) #+



#Also getting stats on first/last position measured by chromosome

total_sum <- group_by(meth, chromosome, method, pos) %>% dplyr::summarise(count = n())
sub_sum <- group_by(meth.sub, chromosome, method, pos) %>% dplyr::summarise(count = n())




pter <- subset(meth, meth$pos == "pter")
qter <- subset(meth, meth$pos == "qter")

pter_min <- group_by(pter, chromosome, method) %>% dplyr::summarise(min(start))
qter_max <- group_by(qter, chromosome, method) %>% dplyr::summarise(max(end))

pter.sub <- subset(meth.sub, meth.sub$pos == "pter")
qter.sub <- subset(meth.sub, meth.sub$pos == "qter")

pter_sub_min <- group_by(pter.sub, chromosome, method) %>% dplyr::summarise(min(start))
qter_sub_max <- group_by(qter.sub, chromosome, method) %>% dplyr::summarise(max(end))



#Plotting correlation between methylation values

#First creating a new column in the data that will be used to subset

as.bs.meth$sample_id <- apply(as.bs.meth[ , c(1, 2, 3)], 1, paste0, collapse="-")
as.np.meth$sample_id <- apply(as.np.meth[ , c(1, 2, 3)], 1, paste0, collapse="-")


#Subsetting

as.bs.meth.sub <- subset(as.bs.meth, as.bs.meth$sample_id %in% as.np.meth$sample_id)
as.np.meth.sub <- subset(as.np.meth, as.np.meth$sample_id %in% as.bs.meth.sub$sample_id)

as.bs.meth.sub$n_wgbs <- as.bs.meth.sub$n_meth + as.bs.meth.sub$n_unmeth
as.np.meth.sub$n_np <- as.np.meth.sub$n_meth + as.np.meth.sub$n_unmeth

meth.shared <- as.bs.meth.sub
meth.shared$np_meth_freq <- NA
meth.shared$n_np <- NA


for (i in seq_len(nrow(meth.shared))) {
  for (j in seq_len(nrow(as.np.meth.sub))) {
    if (meth.shared$sample_id[i] == as.np.meth.sub$sample_id[j]) {
      meth.shared$np_meth_freq[i] <- as.np.meth.sub$freq[j]
      meth.shared$n_np[i] <- as.np.meth.sub$n_np[j]
    }
  }
}


meth.shared <- meth.shared[, c(1, 2, 3, 4, 9, 10, 11)]
meth.shared$chromosome <- as.factor(meth.shared$chromosome)
names(meth.shared)[names(meth.shared)=="freq"] <- "wgbs_meth_freq"



rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
r <- rf(32)


ggplot(meth.shared, aes(wgbs_meth_freq, np_meth_freq)) +
  geom_bin2d(bins=5) + scale_fill_gradientn(colors=r, trans="log10", name = 'Count') +
  xlab("WGBS Methylation Frequency") +
  ylab("Nanopore Methylation Frequency") +
  theme_bw(base_size=20) +
  #ggtitle(title)
  #facet_wrap(~sample) +
  theme(axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10))

#The heatmap is not really that informative, so I will try using a scatter plot instead

ggplot(meth.shared, aes(x=wgbs_meth_freq, y=np_meth_freq)) +
  geom_point() +
  geom_smooth(method=lm , color="red", se=TRUE) +
  xlab("WGBS methylation frequency") +
  ylab("Nanopore methylation frequency")

ggplot(meth.shared, aes(x=n_wgbs, y=n_np)) +
  geom_point() +
  geom_smooth(method=lm , color="red", se=TRUE) +
  xlab("WGBS depth") +
  ylab("Nanopore depth")



meth.shared.sub <- subset(meth.shared, meth.shared$n_wgbs > 10 & meth.shared$n_np > 10)
        
        
#Plotting tas

library(circlize)

#I will load the AR/AS bedpe files here - Will try making the images again using the TtoT aligned data
ar.bedpe <- read.csv("./GCTB/AR_TtoT_1000bp_split_reads.bedpe", sep = '\t', header = TRUE)
as.bedpe <- read.csv("./GCTB/AS_TtoT_1000bp_split_reads.bedpe", sep = '\t', header = TRUE)

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

ar.bedpe <- na.omit(ar.bedpe)
as.bedpe <- na.omit(as.bedpe)

#Then I will filter for telomeric fusions by subsetting the data to only include positions in the telomeres (±100kb)

#First getting chromosome coordinates 

#Assigning a new column saying whether or not the pair forms a tas for ar
ar.bedpe$tas_1 <- NA
ar.bedpe$tas_2 <- NA

for (i in seq_len(nrow(ar.bedpe))) {
  for (j in seq_len(nrow(telomeres.alt))) {
    if (ar.bedpe$chrom1[i] == telomeres.alt$chrom[j] & ar.bedpe$end1[i] < telomeres.alt$pter_end[j]) {
      ar.bedpe$tas_1[i] <- "Yes"
    } 
  }
}

for (i in seq_len(nrow(ar.bedpe))) {
  for (j in seq_len(nrow(telomeres.alt))) {
    if (ar.bedpe$chrom1[i] == telomeres.alt$chrom[j] & ar.bedpe$start1[i] > telomeres.alt$qter_start[j]) {
      ar.bedpe$tas_1[i] <- "Yes"
    } 
  }
}

for (i in seq_len(nrow(ar.bedpe))) {
  for (j in seq_len(nrow(telomeres.alt))) {
    if (ar.bedpe$chrom2[i] == telomeres.alt$chrom[j] & ar.bedpe$end2[i] < telomeres.alt$pter_end[j]) {
      ar.bedpe$tas_2[i] <- "Yes"
    } 
  }
}

for (i in seq_len(nrow(ar.bedpe))) {
  for (j in seq_len(nrow(telomeres.alt))) {
    if (ar.bedpe$chrom2[i] == telomeres.alt$chrom[j] & ar.bedpe$start2[i] > telomeres.alt$qter_start[j]) {
      ar.bedpe$tas_2[i] <- "Yes"
    } 
  }
}

as.bedpe$tas_1 <- NA
as.bedpe$tas_2 <- NA

for (i in seq_len(nrow(as.bedpe))) {
  for (j in seq_len(nrow(telomeres.alt))) {
    if (as.bedpe$chrom1[i] == telomeres.alt$chrom[j] & as.bedpe$end1[i] < telomeres.alt$pter_end[j]) {
      as.bedpe$tas_1[i] <- "Yes"
    } 
  }
}

for (i in seq_len(nrow(as.bedpe))) {
  for (j in seq_len(nrow(telomeres.alt))) {
    if (as.bedpe$chrom1[i] == telomeres.alt$chrom[j] & as.bedpe$start1[i] > telomeres.alt$qter_start[j]) {
      as.bedpe$tas_1[i] <- "Yes"
    } 
  }
}

for (i in seq_len(nrow(as.bedpe))) {
  for (j in seq_len(nrow(telomeres.alt))) {
    if (as.bedpe$chrom2[i] == telomeres.alt$chrom[j] & as.bedpe$end2[i] < telomeres.alt$pter_end[j]) {
      as.bedpe$tas_2[i] <- "Yes"
    } 
  }
}

for (i in seq_len(nrow(as.bedpe))) {
  for (j in seq_len(nrow(telomeres.alt))) {
    if (as.bedpe$chrom2[i] == telomeres.alt$chrom[j] & as.bedpe$start2[i] > telomeres.alt$qter_start[j]) {
      as.bedpe$tas_2[i] <- "Yes"
    } 
  }
}



ar.bedpe.telomeric <- subset(ar.bedpe, ar.bedpe$tas_1 == "Yes" & ar.bedpe$tas_2 == "Yes")
as.bedpe.telomeric <- subset(as.bedpe, as.bedpe$tas_1 == "Yes" & as.bedpe$tas_2 == "Yes")

rownames(ar.bedpe.telomeric) <- NULL
rownames(as.bedpe.telomeric) <- NULL

#Now classifying each as pter or qter

ar.bedpe.telomeric$pos1 <- NA
ar.bedpe.telomeric$pos2 <- NA

for (x in seq_len(nrow(ar.bedpe.telomeric))) {
  if (ar.bedpe.telomeric$end1[x] < 100000) {
    ar.bedpe.telomeric$pos1[x] <- "pter"
  } else {
    ar.bedpe.telomeric$pos1[x] <- "qter"
  }
}

for (i in seq_len(nrow(ar.bedpe.telomeric))) {
  if (ar.bedpe.telomeric$end2[i] < 100000) {
    ar.bedpe.telomeric$pos2[i] <- "pter"
  } else {
    ar.bedpe.telomeric$pos2[i] <- "qter"
  }
}

as.bedpe.telomeric$pos1 <- NA
as.bedpe.telomeric$pos2 <- NA

for (x in seq_len(nrow(as.bedpe.telomeric))) {
  if (as.bedpe.telomeric$end1[x] < 100000) {
    as.bedpe.telomeric$pos1[x] <- "pter"
  } else {
    as.bedpe.telomeric$pos1[x] <- "qter"
  }
}

for (i in seq_len(nrow(as.bedpe.telomeric))) {
  if (as.bedpe.telomeric$end2[i] < 100000) {
    as.bedpe.telomeric$pos2[i] <- "pter"
  } else {
    as.bedpe.telomeric$pos2[i] <- "qter"
  }
}

#Creating the final columns that will be used for the adjacency data
ar.bedpe.telomeric$final_1 <- paste(ar.bedpe.telomeric$chrom1, ar.bedpe.telomeric$pos1, sep = " ")
ar.bedpe.telomeric$final_2 <- paste(ar.bedpe.telomeric$chrom2, ar.bedpe.telomeric$pos2, sep = " ")

as.bedpe.telomeric$final_1 <- paste(as.bedpe.telomeric$chrom1, as.bedpe.telomeric$pos1, sep = " ")
as.bedpe.telomeric$final_2 <- paste(as.bedpe.telomeric$chrom2, as.bedpe.telomeric$pos2, sep = " ")



#Then I will convert the data to the adjacency data needed by circlize
ar.adjacencyData <- with(ar.bedpe.telomeric, table(final_1, final_2))
as.adjacencyData <- with(as.bedpe.telomeric, table(final_1, final_2))

#Then I will plot

layout(matrix(1:2, 2, 1))
chordDiagram(as.adjacencyData, transparency = 0.5, scale = TRUE)
chordDiagram(ar.adjacencyData, transparency = 0.5, scale = TRUE)

#Getting a summary of each tas found 
as.bedpe.telomeric$fusion <- paste(as.bedpe.telomeric$final_1, as.bedpe.telomeric$final_2, sep = "-")
as.bedpe.telomeric$fusion <- factor(as.bedpe.telomeric$fusion)
as_tas <- data.frame(summary(as.bedpe.telomeric$fusion))

ar.bedpe.telomeric$fusion <- paste(ar.bedpe.telomeric$final_1, ar.bedpe.telomeric$final_2, sep = "-")
ar.bedpe.telomeric$fusion <- factor(ar.bedpe.telomeric$fusion)
ar_tas <- data.frame(summary(ar.bedpe.telomeric$fusion))

as_tas$fusion <- rownames(as_tas)

ar_tas$fusion <- rownames(ar_tas)


fusions <-merge(as_tas, ar_tas, by = "fusion", all = TRUE)
fusions[is.na(fusions)] <- 0

names(fusions)[names(fusions)=="summary.as.bedpe.telomeric.fusion."] <- "n_AS"
names(fusions)[names(fusions)=="summary.ar.bedpe.telomeric.fusion."] <- "n_AR"

write.table(fusions, "./GCTB_tas.tsv", row.names = FALSE, sep = '\t', quote = FALSE)


#Session info
sessionInfo()








