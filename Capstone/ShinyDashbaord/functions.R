

# P. Saouter, 09.12.2017

source("textmining.R")

getngramdf <- function(n) {
	if (n == 1) return(dn1)
	else if (n == 2) return(dn2)
	else if (n == 3) return(dn3)
	else if (n == 4) return(dn4)
	else if (n == 5) return(dn5)
	else {stop("N Gram does not exist!")}
}

getnwords <- function (txt,seperator = " "){
	return(length(strsplit(txt, seperator)[[1]]))
}

getlastwords <- function (txt, n, seperator = " "){
	
	txtElems <- strsplit(txt, seperator)[[1]]
	end <- length(txtElems); srt <- end-(n-1)
	lst <- paste(txtElems[srt:end],collapse = " ")
	return(lst)	
	
}

findfirstmatch <- function(txt1,txt2){
  
  idx <- 0
  for (i in length(txt2):1){
    if (txt2[i]==txt1[length(txt1)]){
      idx <- i
    }
  }
  return(idx)
  
}

searchngram <- function(ngramdf, searchTxt) {
	
	txtElems <- strsplit(searchTxt, " ")[[1]]
	lstwordsearch <- txtElems[length(txtElems)]
	listcases <- as.data.frame(
		ngramdf[grepl(paste(searchTxt," ",sep=""), ngramdf$`Unique Words`,perl=TRUE),][,c("Unique Words","Frequency","Probability","NextWord","ngram")])

	if (nrow(listcases)>0){
	    
	  listcases$Match <- 0
	  
	  for (i in 1:nrow(listcases)){
	    txtElems2 <- strsplit(listcases$`Unique Words`[i], " ")[[1]]
	    str <- findfirstmatch(txtElems,txtElems2)
	    listcases$NextWord[i] <- txtElems2[str+1]
	    listcases$Match[i] <- min(length(txtElems2),length(txtElems))
	  }
	}

	return(listcases)
	
}

# was an attempt but did not provide satisfactory results

applykatzbacook <- function(df){
  
  cat("Katz Application \n")
  df$discount = rep(1, nrow(df))

  for(i in 5:1){
    
    currRTimes = i
    nextRTimes = currRTimes + 1
    
    currN = sum(df$Frequency == currRTimes,na.rm = TRUE)
    nextN = sum(df$Frequency == nextRTimes,na.rm = TRUE)
    
    currd = (nextRTimes / currRTimes) * (nextN / currN) # assumption: 0 < d < 1
    
    df$discount <- currd
  }
  
  return(df)  
}


calcLeftOverProb = function(lastTerm, frequency, discount){
  all_freq = sum(Frequency,na.rm = TRUE)
  
  return(1-sum((discount*frequency)/all_freq))
}

predictnextword <- function(text){
	
  text <- fc_cleantext(text)
  
  #cat(paste("Cleaned up word is ",text,sep=""),"\n")
  
	nlstwords <- maxngram-1
	if (getnwords(text)<maxngram) nlstwords <- getnwords(text)
	
	firstfound <- 1
	final <- head(dn1,10)
	final$Match <- 0
	final$found <- 0
	
	for (i in nlstwords:1){
		
		end <- i+1; if (i>4) end <- 5
		
		for (j in end:5){
		  
			list <- getlastwords(text,i)
			res <- searchngram(listngrams[[j]],list)
			if (nrow(res)>0){
			  
			  res$found <- as.character(list)
			  res$Probability <- with(res,as.numeric(with(res,round((Frequency/sum(res$Frequency,na.rm = TRUE))*100,2))))
			  if (nrow(res)>1 & firstfound==1) {final <- res; firstfound <- 2}
			  else final <- rbind(final,res)
			  
			}
		}
	}
	
	final$MatchScore <- 0
	
	if (sum(final$Match==1,na.rm = TRUE)>0){
	  
	  final <- subset(final,Match>=1)
	  final <- subset(final,!duplicated(c(`Unique Words`)))
	  #final <- applykatzbacook(final)
	  
	  totalfreq <- sum(final$Frequency,na.rm = TRUE)
	  
	  freqw <- ddply(final,.(NextWord),nrow)
	  final$freqword <- freqw[match(final$NextWord,freqw$NextWord),2]
    final$MatchScore <- with(final,round((Match+(freqword/sum(Frequency))*100)*(Probability/100),4))
	  final <- subset(final,select=-c(freqword))
	  final <- final[with(final,order(-Match,-MatchScore)),] 
	}

	return(final)
}


getword <- function(df,item){
  
  return(getlastwords(as.character(df$`Unique Words`[item]),1))
  
}

getwordandprob <- function(df,item){
	
	return(paste(getlastwords(as.character(df$`Unique Words`[item]),1)," ( prob = ",df$Probability[item]," )",sep=""))
	
}


getnextwords <- function(df){
	
	nowords <- "No Suggestions Found"
	
	if (nrow(df)==0){
		
		word1 <- "waiting"
		word2 <- "waiting"
		word3 <- "waiting"
		
	} else {
		
		if (nrow(df)>2) {
			
			word1 <- getword(df,1)
			word2 <- getword(df,2)
			word3 <- getword(df,3)
			
		} else if (nrow(df)==2){
			
			word1 <- getword(df,1)
			word2 <- getword(df,2)
			word3 <- nowords
			
		} else if (nrow(df)==1){
			word1 <- getword(df,1)
			word2 <- nowords
			word3 <- nowords
		}
		else {
			word1 <- nowords
			word2 <- nowords
			word3 <- nowords
		}
	}
	
	return(list(word1,word2,word3))

}



