
suppressMessages(library(dplyr))
suppressMessages(library(stringi))
suppressMessages(library(tm))
suppressMessages(library(ggplot2))
suppressMessages(library(doParallel))
suppressMessages(library(wordcloud))
suppressMessages(library(rJava)); .jinit()
suppressMessages(library(RWeka))
suppressMessages(library(qdap))
suppressMessages(library(knitr))
suppressMessages(library(gridExtra))

cpath <- "Data/en_US/corpus/"
npath <- "Data/en_US/ngrams/"

paths <- c("Data/en_US/en_US.blogs.txt",
											"Data/en_US/en_US.news.txt",
											"Data/en_US/en_US.twitter.txt")