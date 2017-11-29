suppressMessages(library(dplyr))
suppressMessages(library(stringi))
suppressMessages(library(tm))
suppressMessages(library(ggplot2))
suppressMessages(library(doParallel))
suppressMessages(library(wordcloud))
suppressMessages(library(knitr))
suppressMessages(library(gridExtra))
suppressMessages(library(shiny))
suppressMessages(library(shinyBS))
suppressMessages(library(plyr))
suppressMessages(library(stringr))
suppressMessages(library(rCharts))
suppressMessages(library(DT))

run_ngram <- FALSE

# You might need to run the below script to prepare your 
# ngrams for the app (see R script for more info)
if (run_ngram) source("preparengramdfs.R")

# Set your highest order ngram to use in the app
maxngram <- 5

# Load Rdata object containing all nrgams 
load("Data/en_US/ngrams/finalngrams.RData");

dn1 <- listngrams[[1]]
dn2 <- listngrams[[2]]
dn3 <- listngrams[[3]]
dn4 <- listngrams[[4]]
dn5 <- listngrams[[5]]


