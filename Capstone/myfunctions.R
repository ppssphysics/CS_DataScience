
# File loading and data sampling
#################################

fc_loadsourcefiles <- function(paths){
	files <- list()
	for (i in 1:length(paths)){
		files[i] <- list(readLines(paths[i], encoding = "UTF-8", skipNul = TRUE, warn=FALSE))
		cat("--> File ",paths[i], " has ",length(files[[i]])," lines","\n",sep="")
	}
	return(files)
}

fc_sampling <- function(f_name, s_size, nrows, s_seed){
	set.seed(s_seed)
	ss <- sample(f_name, length(f_name) * (nrows/length(f_name)))
}

# Text corpus cleaning
#######################

fc_removeurls <- function(x){ 
	x <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", x)
	x <- gsub("www.(.+? )", "", x) #url followed by something
	x <- gsub("www.(.+)", "", x) #url followed by nothing (needs to be preceeded by before)
	return(x)
}

fc_removealonenumb <- function(x){
	x <- gsub(" +[[:digit:]]+ ", " ", x,perl=TRUE)
	return(x)
}

fc_removepunc <- function(x){ 
	# not happy with the way some punctuation is removes, leaving no space between two words
	x <- gsub(" p.m. ", " pm ", x)
	x <- gsub(" a.m. ", " am ", x)
	x <- gsub(" u.s. ", " usa ", x)
	x <- gsub(" u.s.a. ", " usa ", x)
	x <- gsub(" u.s.a ", " usa ", x)
	x <- gsub("[.]", " ", x)
	x <- gsub("[!]", " ", x)
	x <- gsub("[=]"," ",x)
	return(x)
}

fc_cleantwitter <- function(x){
		x <- gsub(" <3 ", " love ", x)
		x <- gsub(" abt ", " about ", x)
		x <- gsub(" u ", " you ", x) 
		x <- gsub(" y ", " why ", x)
		x <- gsub(" n ", " and ", x)
		x <- gsub(" r ", " are ", x)
		x <- gsub(" pls "," please ", x)
		x <- gsub(" ur "," you are ",x)
		x <- gsub(" tho "," though ",x)
		x <- gsub(" (L|l)(O|o)(L|l) ", " laugh out loud ", x)
		return(x)
}

fc_cleancorpus <- function(corpus,twitter=FALSE){
	
	my.corpus <- tm_map(corpus, content_transformer(tolower))
	my.corpus <- tm_map(my.corpus, content_transformer(fc_removeurls))
	my.corpus <- tm_map(my.corpus, content_transformer(fc_removealonenumb))
	my.corpus <- tm_map(my.corpus, content_transformer(fc_removepunc))
	if (twitter==TRUE) my.corpus <- tm_map(my.corpus, content_transformer(fc_cleantwitter))
	my.corpus <- tm_map(my.corpus, removePunctuation)
	my.corpus <- tm_map(my.corpus, removeNumbers)
	my.corpus <- tm_map(my.corpus, stripWhitespace)
	my.corpus <- tm_map(my.corpus, PlainTextDocument)
	return(my.corpus)
	
}

fc_removestopwords <- function(corpus){
	return(tm_map(corpus,removeWords, stopwords("english")))
}

fc_getcleancorpus <- function(dt_name,twitter){
	dt_name_utf8 <- iconv(dt_name, "UTF-8", "ASCII", sub="")
	cleancorpus <- fc_cleancorpus(VCorpus(VectorSource(dt_name_utf8)),twitter)
	return(cleancorpus)
}






##############################
## Ngram creatrion
##############################


fc_getngram <- function(corpus, n){
	
	tokenizerfunc <- function(x) NGramTokenizer(x, Weka_control(min = n, max = n))
	tdm <- TermDocumentMatrix(corpus, control = list(tokenize = tokenizerfunc))
	
	m <- as.matrix(tdm)
	v <- sort(rowSums(m), decreasing=TRUE)
	d <- data.frame(word = names(v),freq=v)

	return(d)
}

fc_plotngram <- function(df,titles){
	df1 <- df[1:30, ]
	plot1 <- ggplot(df1, aes(x = reorder(word, freq), y = freq))
	plot1 <- plot1 + geom_bar(stat = "identity")
	plot1 <- plot1 + ggtitle(titles)
	plot1 <- plot1 + labs(x = "Frequency", y = "")
	plot1 <- plot1 + coord_flip()
	plot1 <- plot1 + theme(axis.text.x = element_text(angle = 45, size = 14, hjust = 1), 
																								plot.title = element_text(size = 20, face = "bold"))
	plot1
}
