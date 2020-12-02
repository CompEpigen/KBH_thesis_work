setwd("/icgc/dkfzlsdf/analysis/C010/brooks/downstream")

library(ComplexHeatmap)
library(tidyr)
library(dplyr)
library(data.table)

#Loading the mapq scores per readid and fusion
scores <- read.csv("./pdx661_read_summary.txt", sep = '\t', header = FALSE)

#Renaming columns
colnames(scores) <- c("read.id", "MAPQ", "fusion")

#Cleaning things up a bit, removing NAs
scores <- subset(scores, scores$fusion != "None")
scores <- scores[!is.na(scores$read.id), ]

#Reforming data for use in heatmap
#scores.wide <- reshape(data = scores, 
#                idvar = 'read.id',
#                v.names = 'MAPQ',
#                timevar = 'fusion',
#                direction = 'wide')

#Making the read id be indices, and removing the read id column
#rownames(scores.wide) <- scores.wide$read.id
#scores.wide <- subset(scores.wide, select = -read.id)

#Plotting the data

#hm <- Heatmap(scores.wide, 
#              name = "MAPQ", 
#              na_col = 'black', 
#              column_title = 'MAPQ Scores of PDX661 reads aligned to Fusion Reference')

#Trying an alternative approach to mapping scores, filtering for MAPQ > 10

scores.reduced <- subset(scores, scores$MAPQ > 10)
scores.r.wide <- reshape(data = scores.reduced, 
                       idvar = 'read.id',
                       v.names = 'MAPQ',
                       timevar = 'fusion',
                       direction = 'wide')
rownames(scores.r.wide) <- scores.r.wide$read.id
scores.r.wide <- subset(scores.r.wide, select = -read.id)

scores.r.wide <- scores.r.wide %>% mutate_all(na_if,"")

scores.r.wide[is.na(scores.r.wide)] = 0



write.csv(scores.r.wide, file = "./PDX661_fusion_alignment_mapqs.tsv", row.names = TRUE, sep = '\t')

hm <- Heatmap(scores.r.wide, 
              name = "MAPQ", 
              na_col = 'black', 
              column_title = 'MAPQ Scores of PDX661 reads aligned to Fusion Reference',
              cluster_rows = FALSE)


hm
#Ok that works but the heatmap doesn't really give any sort of interesting insight
#I'm now going to try and only find the fusions where the most number of reads mapped

#Starting by getting number of nonzero rows for each column
colsums <- colSums(scores.r.wide != 0)

colsums <- cbind(colnames(scores.r.wide), colsums)


#Ok going back to the original scores df, I'll try extracting the info I want from this

high.mapq <- subset(scores, scores$MAPQ > 10)

fusion.read.count <- group_by(high.mapq, fusion) %>%
  dplyr::summarise(
    count = n())

fusion.read.count <- subset(fusion.read.count, fusion.read.count$count > 20)



write.csv(fusion.read.count, file = "./PDX661_fusion_highcount.txt", row.names = FALSE, sep = '\t')

scores.reduced <- subset(scores.reduced, scores.reduced$fusion %in% fusion.read.count$fusion)

write.table(scores.reduced, file = "./PDX661_readids_fusion_highmapq.txt", row.names = FALSE, sep = '\t', quote = FALSE)

####Trying the same in GCTB#####

#Loading the data
scores <- read.csv("./GCTB/AR_read_summary.txt", sep = '\t', header = FALSE)

#Cleaning things up
colnames(scores) <- c("read.id", "MAPQ", "fusion")
scores <- subset(scores, scores$fusion != "None")
scores <- scores[!is.na(scores$read.id), ]

#Filtering for high MAPQ
scores.reduced <- subset(scores, scores$MAPQ > 10)

fusion.read.count <- group_by(scores.reduced, fusion) %>%
  dplyr::summarise(
    count = n())


scores.reduced <- subset(scores.reduced, scores.reduced$fusion %in% fusion.read.count$fusion)

write.table(scores.reduced, file = "./GCTB/AR_readids_fusion_highmapq.txt", row.names = FALSE, sep = '\t', quote = FALSE)




