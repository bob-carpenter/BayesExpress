# run from directory in which it resides: BayesExpress/R/

library("ggplot2")
df <- read.csv("../data/isoform-lengths-human-refseq-GRCh38.csv",
               header=TRUE)

plot <-
    ggplot(df, aes(x = length)) +
    geom_histogram(color="white", fill="darkblue", bins=60) +
    scale_x_log10(breaks=c(1e2, 1e3, 1e4, 1e5),
                  labels=c("100", "1K", "10K", "100K")) +
    xlab("human isoform lengths") +
    ylab("count")

ggsave('isoform-human-length-histogram.pdf', width=4, height=3)
