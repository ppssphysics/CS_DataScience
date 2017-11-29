

# Load raw ngrams and apply some operations to
# prepare for Shiny application format.

getlastwords <- function (txt, n, seperator = " "){
  
  txtElems <- strsplit(txt, seperator)[[1]]
  end <- length(txtElems); srt <- end-(n-1)
  lst <- paste(txtElems[srt:end],collapse = " ")
  return(lst)	
  
}

load(paste(npath,"/ngrams_n1_0.01.RData",sep="")); dn1 <- dd;
load(paste(npath,"/ngrams_n2_0.01.RData",sep="")); dn2 <- dd;
load(paste(npath,"/ngrams_n3_0.01.RData",sep="")); dn3 <- dd;
load(paste(npath,"/ngrams_n4_0.01.RData",sep="")); dn4 <- dd;
load(paste(npath,"/ngrams_n5_0.01.RData",sep="")); dn5 <- dd;

dn1$uniquewords <- as.character(dn1$uniquewords)
dn2$uniquewords <- as.character(dn2$uniquewords)
dn3$uniquewords <- as.character(dn3$uniquewords)
dn4$uniquewords <- as.character(dn4$uniquewords)
dn5$uniquewords <- as.character(dn5$uniquewords)

dn1$totalfreq <- as.numeric(dn1$totalfreq)
dn2$totalfreq <- as.numeric(dn2$totalfreq)
dn3$totalfreq <- as.numeric(dn3$totalfreq)
dn4$totalfreq <- as.numeric(dn4$totalfreq)
dn5$totalfreq <- as.numeric(dn5$totalfreq)

colnames(dn1) <- c("Unique Words","Frequency")
colnames(dn2) <- c("Unique Words","Frequency")
colnames(dn3) <- c("Unique Words","Frequency")
colnames(dn4) <- c("Unique Words","Frequency")
colnames(dn5) <- c("Unique Words","Frequency")

dn1$Frequency[is.na(dn1$Frequency)] <- as.numeric(1)
dn2$Frequency[is.na(dn2$Frequency)] <- as.numeric(1)
dn3$Frequency[is.na(dn3$Frequency)] <- as.numeric(1)
dn4$Frequency[is.na(dn4$Frequency)] <- as.numeric(1)
dn5$Frequency[is.na(dn5$Frequency)] <- as.numeric(1)

dn1$Probability <- with(dn1,as.numeric(with(dn1,round((Frequency/sum(dn1$Frequency,na.rm = TRUE))*100,5))))
dn2$Probability <- with(dn2,as.numeric(with(dn2,round((Frequency/sum(dn2$Frequency,na.rm = TRUE))*100,5))))
dn3$Probability <- with(dn3,as.numeric(with(dn3,round((Frequency/sum(dn3$Frequency,na.rm = TRUE))*100,5))))
dn4$Probability <- with(dn4,as.numeric(with(dn4,round((Frequency/sum(dn4$Frequency,na.rm = TRUE))*100,5))))
dn5$Probability <- with(dn5,as.numeric(with(dn5,round((Frequency/sum(dn5$Frequency,na.rm = TRUE))*100,5))))

dn1$LastWord <- NA
dn2$LastWord <- NA
dn3$LastWord <- NA
dn4$LastWord <- NA
dn5$LastWord <- NA

dn1$ngram <- "1-grams"
dn2$ngram <- "2-grams"
dn3$ngram <- "3-grams"
dn4$ngram <- "4-grams"
dn5$ngram <- "5-grams"

listngrams <- list(dn1,dn2,dn3,dn4,dn5)

for (i in 1:length(listngrams)){
	for (j in 1:nrow(listngrams[[i]])){

		listngrams[[i]]$LastWord[j] <- getlastwords(as.character(listngrams[[i]]$`Unique Words`[j]),1)

	}
}

save(listngrams,file=paste(npath,"FinalNgrams.RData",sep=""))