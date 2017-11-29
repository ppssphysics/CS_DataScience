

source("config.R")
source("myfunctions.R")


##########################
# Setup for the session
##########################

sample_size <- 0.01
dt <- list()

existpaths <- paste(cpath,"corpus_",sample_size,".RData",sep="")

#############################
# Loading the data sets
#############################

loaddata <- function(){
	
	if (file.exists(existpaths)){
		
		cat("The files for the requested sampling value and sampling type already exist.","\n")
		cat("You can run the createtextcorpus() function.","\n")
		
	} else {
		
		cat("Loading Source files and applying ", sample_size," sampling factor","\n")
		
		# What is fact more reasonnable than retrieving the same number of lines from each file is
		# is more or less the same number of words using the average number of words per line in the
		# file
		
		incr_fct2 <- 41.75/34.62
		incr_fct3 <- 41.75/12.75
		
		dts <- fc_loadsourcefiles(paths)
		total_rows <- min(length(dts[[1]])*sample_size,length(dts[[2]])*sample_size,length(dts[[3]])*sample_size)
		
		dt1 <- fc_sampling(dts[[1]],sample_size,total_rows,111)
		dt2 <- fc_sampling(dts[[2]],sample_size,total_rows*incr_fct2,111)
		dt3 <- fc_sampling(dts[[3]],sample_size,total_rows*incr_fct3,111)
		
		save(dt1,dt2,dt3,file=paste(cpath,"corpus_",sample_size,".RData",sep=""))
		
		remove(dts,dt1,dt2,dt3)
		cat("\n")
	}
}

##########################################
# Formatting to txt corpus (tm package)
##########################################


createtextcorpus <- function(){
	
	cat("1. Loading the data...","\n")
	
	dt <- load(existpaths)
	dt_blog_s <- dt1
	dt_news_s <- dt2
	dt_twit_s <- dt3
	
	cat("\n")
	cat("2. Corpus and cleaning...","\n\n")
	
	crp_blog_1 <- fc_getcleancorpus(dt_blog_s,FALSE)
	crp_news_1 <- fc_getcleancorpus(dt_news_s,FALSE)
	crp_twit_1 <- fc_getcleancorpus(dt_twit_s,TRUE)
	
	remove(dt_blog_s,dt_news_s,dt_twit_s)
	
	crp_blog_2 <- fc_removestopwords(crp_blog_1)
	crp_news_2 <- fc_removestopwords(crp_news_1)
	crp_twit_2 <- fc_removestopwords(crp_twit_1)

	save(crp_blog_1,crp_news_1,crp_twit_1,crp_blog_2,crp_news_2,crp_twit_2,file=paste(cpath,"corpus_clean_",sample_size,".RData",sep=""))
	
	remove(crp_blog_1,crp_blog_2)
	remove(crp_news_1,crp_news_2)
	remove(crp_twit_1,crp_twit_2)
}














