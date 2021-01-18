setwd("/icgc/dkfzlsdf/analysis/C010/brooks/downstream/PDX661")

#Loading libraries
library(ggplot2)

# #Setting variables 
# SAMPLE = "/icgc/dkfzlsdf/analysis/C010/brooks/downstream/PDX661/PDX661_del7q_meth_calls.tsv"
# 
# #Loading data
# meth <- read.csv(file = SAMPLE, sep = '\t')
# 
# #Need to filter based on the LLR ratio of ±2.5
# meth <- subset(meth, meth$log_lik_ratio > 2.5 | meth$log_lik_ratio < -2.5)
# 
# 
# meth$del7q <- NA
# 
# del7q <- c("60f4fcc7-474c-4698-9f7e-36486a8bc7fc", "e7dd8fec-c39a-42c5-a262-7dff5c9f14f3", "91230b59-076e-4148-9356-131bc21ad369")
# 
# 
# for (i in seq_len(nrow(meth))) {
#   if (meth$read_name[i] %in% del7q) {
#     meth$del7q[i] <- "Yes"
#   } else {
#     meth$del7q[i] <- "No"
#   }
# }
# 
# 
# 
# 
# #Plotting
# ggplot(meth, aes(x=start, y=log_lik_ratio, color=del7q)) + 
#   geom_point(size=.5)
# 
# 
# #Subsetting meth to those around CDK6
# #meth.cdk6 <- subset(meth, meth$start < 92994252)
# meth.cdk6 <- subset(meth, meth$start > 92634087 & meth$end < 92669899)
# 
# 
# ggplot(meth.cdk6, aes(x=start, y=log_lik_ratio, color=del7q)) + 
#   geom_point(size=.5)
# 
# ggplot(meth.cdk6, aes(x=log_lik_ratio, group=del7q, fill=del7q)) +
#   geom_density(adjust=1.5)
# 
# ggplot(meth.cdk6, aes(x=start, y=log_lik_ratio, color=del7q)) + 
#   geom_point(size=.5) +
#   geom_smooth(aes(group=del7q),
#             method = "nls", formula = y ~ a * x + b, se = FALSE,
#             method.args = list(start = list(a = 0.1, b = 0.1)))
# 
# 
# ggplot(meth.cdk6, aes(x=start, y=log_lik_ratio, color=del7q)) + 
#   geom_point(size=.5) + 
#   geom_smooth() +
#   ylab("Log likelihood ratio") +
#   xlab("Position") +
#   ggtitle("Methylation in CDK6")
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# meth.mnx1 <- subset(meth, meth$start > 92994252)
# 
# ggplot(meth.mnx1, aes(x=log_lik_ratio, group=del7q, fill=del7q)) +
#   geom_density(adjust=1.5)
# 
# 
# 
# #Doing a KS test to test the distributions
# 
# del <- subset(meth.cdk6, meth$del7q == "Yes")
# 
# nodel <- subset(meth.cdk6, meth$del7q == "No")
# 
# ks.test(del$log_lik_ratio, nodel$log_lik_ratio)
# 
# #Two-sample Kolmogorov-Smirnov test
# 
# #data:  del$log_lik_ratio and nodel$log_lik_ratio
# #D = 0.24048, p-value = 3.84e-10
# #alternative hypothesis: two-sided
# 
# ###Now trying it with the methylation frequency 
# 
# meth_del <- read.csv(file = "PDX661_del7q_deletion_freq.tsv", sep = '\t')
# meth_nodel <- read.csv(file = "PDX661_del7q_nodeletion_freq.tsv", sep = '\t')
# 
# meth_del <- subset(meth_del, meth_del$start %in% meth_nodel$start)
# meth_nodel <- subset(meth_nodel, meth_nodel$start %in% meth_del$start)
# 
# meth_del$del7q <- "Yes"
# meth_nodel$del7q <- "No"
# 
# meth_freq <- rbind(meth_del, meth_nodel)
# 
# 
# ggplot(meth_freq, aes(x=start, y=methylated_frequency, color=del7q)) + 
#   geom_point(size=.5) +
#   geom_smooth() +
#   ylab("Methylated Frequency") +
#   xlab("Position") +
#   ggtitle("Methylation in CDK6")
# 
# 
# ggplot(meth, aes(x=methylated_frequency, group=del7q, fill=del7q)) +
#   geom_density(adjust=1.5)
# 
# 
# #Subsetting for CDK6
# 
# 
# 
# meth.cdk6 <- subset(meth, meth$start > 92602921 && meth$end < 92838627)
# 
# 
# ggplot(meth.cdk6, aes(x=start, y=methylated_frequency)) + 
#   geom_point(size=.5) +
#   geom_line(data = meth.cdk6, aes(x = start, y = methylated_frequency))
# 
# ggplot(meth.cdk6, aes(x=start, y=methylated_frequency)) + 
#   geom_point(size=.5) +
#   geom_smooth(method = "loess")


###########################################################################


meth_del <- read.csv(file = "PDX661_del7q_deletion_freq.tsv", sep = '\t')
meth_nodel <- read.csv(file = "PDX661_del7q_nodeletion_freq.tsv", sep = '\t')

meth_del$del7q <- "Yes"
meth_nodel$del7q <- "No"

meth_freq <- rbind(meth_del, meth_nodel)


meth.cdk6 <- subset(meth_freq, meth_freq$start >= 92634292 & meth_freq$end <= 92669575)
meth.mnx1 <- subset(meth_freq, meth_freq$start > 157002751 & meth_freq$end < 157008159)


meth.cdk6$region <- "CDK6"
meth.mnx1$region <- "MNX1"

meth_freq <- rbind(meth.cdk6, meth.mnx1)


# ggplot(meth.cdk6, aes(x=start, y=methylated_frequency, color=del7q)) + 
#   geom_point(size=.5) +
#   geom_smooth() +
#   ylab("Methylated Frequency") +
#   xlab("Position") +
#   ggtitle("Methylation in CDK6")
# 
# ggplot(meth.mnx1, aes(x=start, y=methylated_frequency, color=del7q)) + 
#   geom_point(size=.5) +
#   geom_smooth() +
#   ylab("Methylated Frequency") +
#   xlab("Position") +
#   ggtitle("Methylation in MNX1")

ggplot(meth_freq, aes(x=start, y=methylated_frequency, color=del7q)) + 
  geom_point(size=.5) +
  geom_smooth() +
  ylab("Methylated Frequency") +
  xlab("Position") +
  facet_wrap(~region, scale="free_x")



