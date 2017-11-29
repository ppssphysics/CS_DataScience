titles <- c("blog","news","twit","blognost","newsnost","twitnost")

# Because of memory issues I really have to do everything step-by-step

getngrams <- function(type=1,n){
	
	load(paste(cpath,"corpus_clean_",sample_size,".RData",sep=""))
	
	corpus <- crp_blog_1
	if (type==2) corpus <- crp_news_1
	else if (type==3) corpus <- crp_twit_1
	else if (type==4) corpus <- crp_news_2
	else if (type==5) corpus <- crp_blog_2
	else if (type==6) corpus <- crp_twit_2
	else if (type==7) corpus <- c(crp_blog_2,crp_news_2,crp_twit_2)
	
	return(fc_getngram(corpus,n))
	remove(corpus)
}

savengramsbytype <- function(n,min,max){
	
	for (i in min:max) {
		dngram <- getngrams(i,n)
		save(dngram,file=paste(npath,"ngrams_n",n,"_",titles[i],"_",sample_size,".RData",sep=""))
	}
	
}

combinengrams <- function(n){
	
	load(paste(npath,"ngrams_n",n,"_blog_",sample_size,".RData",sep="")); d1 <- dngram
	load(paste(npath,"ngrams_n",n,"_news_",sample_size,".RData",sep="")); d2 <- dngram
	load(paste(npath,"ngrams_n",n,"_twit_",sample_size,".RData",sep="")); d3 <- dngram
	
	dd <- rbind(d1,d2,d3)
	dd <- subset(dd,!duplicated(word))
	dd <- droplevels(dd); 
	colnames(dd) <- c("uniquewords","totalfreq")
	rownames(dd) <- c(1:nrow(dd))
	for (i in 1:nrow(dd)){
		dd$totalfreq[i] <- d1$freq[i]+d2$freq[i]+d3$freq[i]
	}
	print(head(dd,20))
	save(dd,file=paste(npath,"ngrams_n",n,"_",sample_size,".RData",sep=""))
	remove(dd)
}


