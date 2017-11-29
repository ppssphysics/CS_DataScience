
# P. Saouter, 09.12.2017

fc_removeurls <- function(x){ 
  x <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", x)
  x <- gsub("www.(.+? )", "", x) #url followed by something
  x <- gsub("www.(.+)", "", x) #url followed by nothing (needs to be preceeded by before)
  return(x)
}

fc_removealonenumb <- function(x){
  x <- gsub(" +[[:digit:]]+ ", " ", x,perl=TRUE)
  x <- gsub("[[:digit:]]", " ", x,perl=TRUE)
  return(x)
}

fc_removepunc <- function(x){ 
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

fc_cleantext <- function(text){
  text <- tolower(text)
  text <- fc_removeurls(text)
  text <- fc_removepunc(text)
  text <- fc_removealonenumb(text)
  text <- fc_cleantwitter(text)
  text <- removePunctuation(text)
  text <- removeNumbers(text)
  text <- stripWhitespace(text)
  return(text)
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

