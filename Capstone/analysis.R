

source("corpuscreation.R")
source("ngramcreation.R")






# g1 <- fc_plotngram(d1,"Blogs")
# g2 <- fc_plotngram(d2,"News")
# g3 <- fc_plotngram(d3,"Twitter")
# 
# g4 <- fc_plotngram(d4,"Blogs No Stopwords")
# g5 <- fc_plotngram(d5,"News No Stopwords")
# g6 <- fc_plotngram(d6,"Twitter No Stopwords")
# 
# #d7 <- getngrams(7,1)
# #g7 <- fc_plotngram(d7,"All")
# 
# grid1 <- grid.arrange(g1, g2,g3, ncol=3)
# grid2 <- grid.arrange(g4, g5,g6, ncol=3)

comparedata <- function(type){
	
	sel <- list()
	if (type==1) sel <- list(d1,d2,d3)
	else sel <- list(d4,d5,d6)
	
	dd <- rbind(sel[[1]],sel[[2]],sel[[3]])
	dd <- subset(dd,!duplicated(word))
	dd <- droplevels(dd); colnames(dd) <- c("uniquewords","totalfreq")
	
	dd_sub <- dd[1:20,]; row.names(dd_sub) <- c(1:nrow(dd_sub))
	dd_sub$blog <- 0
	dd_sub$news <- 0
	dd_sub$twit <- 0
	
	 for (i in 1:nrow(dd_sub)){
	 	dd_sub$blog[i] <- d1[match(dd_sub$uniquewords[i],sel[[1]]$word),2]/sum(sel[[1]]$freq)
	 	dd_sub$news[i] <- d2[match(dd_sub$uniquewords[i],sel[[2]]$word),2]/sum(sel[[2]]$freq)
	 	dd_sub$twit[i] <- d3[match(dd_sub$uniquewords[i],sel[[3]]$word),2]/sum(sel[[3]]$freq)
	 	dd_sub$totalfreq[i] <- dd_sub$blog[i]+dd_sub$news[i]+dd_sub$twit[i]/sum(sel[[1]]$freq+sel[[2]]$freq+sel[[3]]$freq)
	 }
	
	tt <- melt(dd_sub,id.vars="uniquewords",measure.vars=c("blog","news","twit"))
	
	g <- ggplot(data=tt, aes(x=uniquewords,y=value, fill=variable)) 
	g <- g + geom_bar(stat="identity", position=position_dodge())
	g <- g + coord_flip()
	g <- g + theme_minimal()
	
}



#########################################################
## Building predictive model
########################################################

## Retrieve ngrams

loadallngrams <- function(){
	load("Data/en_US/ngrams/ngrams_n1_0.01.RData"); dn1 <- dd; dn1$uniquewords <- as.character(dn1$uniquewords)
	load("Data/en_US/ngrams/ngrams_n2_0.01.RData"); dn2 <- dd; dn2$uniquewords <- as.character(dn2$uniquewords)
	load("Data/en_US/ngrams/ngrams_n3_0.01.RData"); dn3 <- dd; dn3$uniquewords <- as.character(dn3$uniquewords)
	load("Data/en_US/ngrams/ngrams_n4_0.01.RData"); dn4 <- dd; dn4$uniquewords <- as.character(dn4$uniquewords)
	load("Data/en_US/ngrams/ngrams_n5_0.01.RData"); dn5 <- dd; dn5$uniquewords <- as.character(dn5$uniquewords)
}


## Return the "standard" N Gram Data Fram name

getNGramDf <- function(n) {
	if (n == 1) return(dn1)
	else if (n == 2) return(dn2)
	else if (n == 3) return(dn3)
	else if (n == 4) return(dn4)
	else if (n == 5) return(dn5)
	else {stop("N Gram does not exist!")}
}

## Get the N based on string length

getN <- function(txt, seperator = " ") {
	txtLength <- length(strsplit(txt, seperator)[[1]])
	if (txtLength == 0) 1
	else if (txtLength == 1) 2
	else if (txtLength == 2) 3
	else 4
}

## Get number of words from the end of string

getEndingWords <- function (txt, seperator = " ") {

	txtElems <- strsplit(txtToLower, seperator)[[1]]
	lengthOfTxt <- length(txtElems)
	lowerBound <- 0
	upperBound <- lengthOfTxt
	offset <- 1 ## sequence indexing starts from 1
	
	if (lengthOfTxt == 0) {lowerBound <- upperBound} 
	else if (lengthOfTxt == 1) {lowerBound <- 1} 
	else if (lengthOfTxt == 2) {lowerBound <- 1} 
	else {lowerBound <- lengthOfTxt - 3 + offset}
	
	paste(txtElems[lowerBound:upperBound], collapse = " ")
}

## Get last word out of a string

getLastWord <- function (txt, n, seperator = " ") {
	
	txtElems <- strsplit(txt, seperator)[[1]]
	end <- length(txtElems); srt <- end-(n-1)
	lst <- paste(txtElems[srt:end],collapse = " ")
	return(lst)	

}

## Get last word out of a vector of strings

getLastWords <- function(txts) {
	numOfTxt <- length(txts)
	lastWords <- vector(length = numOfTxt)
	for(i in c(1:numOfTxt)) lastWords[i] <- getLastWord(txts[i])
	return(lastWords)
}

## Match search text with entries in N Gram data.frame

filterNgrams <- function(nGramDf, searchTxt) {
	
	txtElems <- strsplit(searchTxt, " ")[[1]]
	lstwordsearch <- txtElems[length(txtElems)]
	listcases <-nGramDf[grepl(paste(searchTxt," ",sep=""), nGramDf$uniquewords,perl=TRUE),][,c("uniquewords")]
	
	print(lstwordsearch)
	print(listcases)
	
	for (i in 1:length(listcases)){
		txtElems2 <- strsplit(listcases[i], " ")[[1]]
		if (txtElems2[length(txtElems2)]!=lstwordsearch){
			stringfound <- listcases[i]
			break
		}
	}
	
	return(stringfound)
	
}

predictnextword <- function(inputTxt) {
	
	for (i in 4:1){
		
		txt_lstwords <- getLastWord(inputTxt,i)
		print(txt_lstwords)
		#filteredNgrams <- filterNgrams(getNGramDf(i+1), txt_lstwords)
		filteredNgrams <- filterNgrams(dn5, txt_lstwords)
		print(filteredNgrams)
	}
	
}

#########################################################
## Week3 quiz
########################################################

cleantext	<- function(x){
	clentxt <- tolower(x)
	clentxt <- gsub("[.!?,#]","",clentxt)
}

inputData <- c(
	"The guy in front of me just bought a pound of bacon, a bouquet, and a case of",
	"You're the reason why I smile everyday. Can you follow me please? It would mean the",
	"Hey sunshine, can you follow me and make me the",
	"Very early observations on the Bills game: Offense still struggling but the",
	"Go on a romantic date at the",
	"Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my",
	"Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some",
	"After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little",
	"Be grateful for the good times and keep the faith during the",
	"If this isn't the cutest thing you've ever seen, then you must be")

cleaninput <- cleantext(inputData)

week3_quizz <- function() {
	
	for(i in 1:length(cleaninput)) {
		predict <- getNextWordsSuggestion(cleaninput[i])
		answer <- paste("Q", i, ": ", paste(predict, collapse = ","), sep = "")
		print(answer)
	}
	
}






## Given a text string as input, predict the 3 following possible words

getNextWordsSuggestion <- function(inputTxt) {
	N <- getN(inputTxt)
	cat("N value is :",N,"\n")
	filteredNgrams <- filterNgrams(getNGramDf(N), getEndingWords(inputTxt))
	cat("filteredNgrams :",filteredNgrams,"\n")
	getLastWords(filteredNgrams)
	cat("lastwords :",getLastWords(filteredNgrams),"\n")
	
}
