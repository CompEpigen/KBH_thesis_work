setwd("/icgc/dkfzlsdf/analysis/C010/brooks")

library(Biostrings)

#Loading the T to T reference genome fasta

ref <- readDNAStringSet("./chm13.draft_v1.0.fasta.gz", format = "fasta")

#Just getting the first/last 100k bases (i.e. telomeric sequences)

heads <- subseq(ref[1:23], start=1, end=100000)
tails <- subseq(ref[1:23], start=-100000)

#Reversing the sequences, my thinking here is that t to t fusions are likely to be end to end (is this a correct assumption/mechanism?)

heads.rev <- reverse(heads)
tails.rev <- reverse(tails)

#Splitting the above DNAStringSets into a list of individual chroms so that I can create all combinations of them

heads.rev.list <- as.list(as.character(heads.rev))
tails.rev.list <- as.list(as.character(tails.rev))

#Joining the individual fragments into fusions

fusion.df <- expand.grid(heads.rev.list, tails.rev.list)

fusion.df$fusion.seqs <- paste0(fusion.df$Var1, fusion.df$Var2) #Change so that it's not paste0, leave gap!

#Adding the correct names

chroms.head <- paste0(names(heads), "h")
chroms.tail <- paste0(names(tails), "t")

names.df <- expand.grid(chroms.head, chroms.tail)
fusion.df$fusion <- paste0(names.df$Var1, names.df$Var2)

#Rejoining all fragments into one DNAStringSet object and saving as a fasta file

fusions <- DNAStringSet(x = fusion.df$fusion.seqs, use.names = TRUE)
names(fusions) <- fusion.df$fusion

writeXStringSet(fusions, './telomeric_fusions_ref.fasta')


##############################################################
#LTR12 reference fasta creation

ltr12 <- readDNAStringSet("./LTR12_repeats.fasta", format = "fasta")

seq_names <- names(ltr12)
alt_names <- seq(1, length(ltr12), by=1)

key <- data.frame(seq_names, alt_names)

write.table(key, "./ltr12_keys.tsv", row.names = FALSE, sep = '\t', quote = FALSE)

names(ltr12) <- key$alt_names

writeXStringSet(ltr12, './LTR12_repeats_ALT.fasta')










