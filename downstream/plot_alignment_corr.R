setwd("/icgc/dkfzlsdf/analysis/C010/brooks/downstream")

library(ComplexHeatmap)
library(tidyr)

#Loading the mapq scores per readid and fusion
scores <- read.csv("./pdx661_read_summary.txt", sep = '\t', header = FALSE)

#Renaming columns
colnames(scores) <- c("read.id", "MAPQ", "fusion")

#Cleaning things up a bit, removing NAs
scores <- subset(scores, scores$fusion != "None")

#Reforming data for use in heatmap
scores.wide <- reshape(data = scores, 
                idvar = 'read.id',
                v.names = 'MAPQ',
                timevar = 'fusion',
                direction = 'wide')

#Making the read id be indices, and removing the read id column
rownames(scores.wide) <- scores.wide$read.id
scores.wide <- subset(scores.wide, select = -read.id)

#Plotting the data

hm <- Heatmap(scores.wide, 
              name = "MAPQ", 
              na_col = 'black', 
              column_title = 'MAPQ Scores of PDX661 reads aligned to Fusion Reference')
