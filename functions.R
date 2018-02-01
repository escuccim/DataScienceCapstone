library(tm)
library(RWeka)
library(dplyr)
library(magrittr)
library(tokenizers)

# Split the strings into features
splitngrams <- function(x) {
    strsplit(x, " ")
}

# Turn a character vector of text into a data frame of ngrams with their associated frequency
createngrams <- function(text, n, filter_results=FALSE){
    sentences <- unlist(tokenize_sentences(text))
    ngrams <- tokenize_ngrams(sentences, lowercase=TRUE, n=n, n_min=n, simplify=TRUE)
    # Unlist it
    ngrams <- unlist(ngrams)
    # Get frequency
    ngramfreq = as.data.frame(table(ngrams))
    
    rm("ngrams")
    # Order and save the two grams
    ngramfreq <- ngramfreq[order(-ngramfreq$Freq),]
    
    if(filter_results){
        # Filter out ngrams that only occur once
        filter <- ngramfreq$Freq > 1
        ngramfreq = ngramfreq[filter,]    
        rm("filter")
    }
    
    # Return ngram frequency
    return(ngramfreq)
}

createmodel <- function(ngramfreq, cols=6){
    ngramfreq$ngrams <- as.character(ngramfreq$ngrams)
    
    splits <- splitngrams(ngramfreq$ngrams)
    splits <- do.call(rbind, splits)
    splits <- as.data.frame(splits)
    
    # Name the columns
    numcols = ncol(splits)
    numfeatures = numcols - 1
    names(splits)[numcols] <- "y"
    nums <- (cols+1-numcols):(5)
    names = c(paste("x",nums,sep=""),"y")
    names(splits) <- names
    
    splits$weight <- (ngramfreq$Freq)
    ngrammodel <- splits
    
    # Order the data frame by weight
    ngrammodel <- ngrammodel[with(ngrammodel, order(x5,-weight)),]
    
    # Reindex it
    rownames(ngrammodel) <- 1:nrow(ngrammodel)
    
    # Add cols with NAs where appropriate
    if(numcols < cols){
        newcols = 1:(cols-numcols)
        newcolnames = paste("x",newcols,sep="")
        ngrammodel[,newcolnames] <- NA    
    }
    
    return(ngrammodel)
}

# Since we only return the top three matches we only need to keep the top 3 ys for each combination of x's
cleanmodel <- function(model, threshhold=3) {
    numx <- ncol(model) - 2
    xcols <- 1:numx
    cols <- paste("x", xcols, sep="")
    # Create an empty dataframe with same columns
    newmodel <- model[0,]
    
    # Get unique combinations of cols
    uniqueRows <- unique(model[cols])
    filter = rep(FALSE, nrow(model))
    fillvalues = rep(TRUE, threshhold)
    
    for( i in rownames(uniqueRows) ){
        i <- as.numeric(i)
        filter[i:(i+2)] <- TRUE
    }
    model <- model[filter,]
    
    # Drop the last two rows because they are empty
    nrows <- nrow(model)
    model <- model[1:(nrows-2),]
    # Renumber the rows
    rownames(model) <- 1:nrow(model)
    return(model)
}

cleanData <- function(data){
    data <- removeNumbers(data)
    data <- removePunctuation(data)
    data
}

pad  <- function(x, n) {
    len.diff <- n - length(x)
    c(x, rep(NA, len.diff)) 
}

checkword <- function(word){
    return(word %in% words)
}

scaleweight <- function(ngrams){
    ngrams$weight <- log10(ngrams$weight)
    ngrams$weight <- ngrams$weight + 0.1
    return(ngrams)
}

weightweights <- function(ngrammodel){
    
}

# remove non-words
checkwords <- function(list){
    if(!exists("words")){
        words <- read.csv("words.txt")
        words <- words$X2    
    }
    
    filter <- apply(as.matrix(list),1,checkword)
    return(filter)
}

# make a model for a maximum of six-grams from a given text corpus.
# threshhold specifies a minimum required number of occurences in the text of an ngram
makedata <- function(text, threshhold=0) {
    # Create an empty data frame
    ngrams <- data.frame(x1=character(),
                         x2=character(),
                         x3=character(),
                         x4=character(),
                         x5=character(),
                         y=character(),
                         weight=integer(),
                         stringsAsFactors=TRUE)
    
    # Create ngrams from the text
    for(i in 2:6){
        ngramfreq <- createngrams(text, i)
        if(threshhold > 0){
            ngramfreq <- subset(ngramfreq, ngramfreq$Freq > threshhold)
        }
        model <- createmodel(ngramfreq, 6)
        ngrams <- rbind(ngrams, model)
        rm("ngramfreq","model")
    }
    rm("text")
    
    # Reorder the columns
    columns <- c("x5","x4","x3","x2","x1","y","weight")
    ngrams <- ngrams[columns]

    return(ngrams)
}

# For an ngrammodel and a list of INVALID words, remove any rows which contain invalid words
validateWords <- function(ngrammodel, bad_words) {
    y <- ngrammodel$y
    filter <- unlist(lapply(as.character(y), function(x) x %in% bad_words))
    ngrammodel <- ngrammodel[!filter,]
    
    x5 <- ngrammodel$x5
    filter <- unlist(lapply(as.character(x5), function(x) x %in% bad_words))
    ngrammodel <- ngrammodel[!filter,]
    rm(x5)
    
    x4 <- ngrammodel$x4
    filter <- unlist(lapply(as.character(x4), function(x) x %in% bad_words))
    ngrammodel <- ngrammodel[!filter,]
    rm(x4)
    
    x3 <- ngrammodel$x3
    filter <- unlist(lapply(as.character(x3), function(x) x %in% bad_words))
    ngrammodel <- ngrammodel[!filter,]
    rm(x3)
    
    x2 <- ngrammodel$x2
    filter <- unlist(lapply(as.character(x2), function(x) x %in% bad_words))
    ngrammodel <- ngrammodel[!filter,]
    rm(x2)
    
    x1 <- ngrammodel$x1
    filter <- unlist(lapply(as.character(x1), function(x) x %in% bad_words))
    ngrammodel <- ngrammodel[!filter,]
    rm(x1)
    
    rownames(ngrammodel) <- 1:nrow(ngrammodel)
    
    return(ngrammodel)
}

# Get list of unique words
uniquewords <- function(ngrammodel){
    wordlist <- c(as.character(ngrammodel$y), as.character(ngrammodel$x5), as.character(ngrammodel$x4), as.character(ngrammodel$x3), as.character(ngrammodel$x2), as.character(ngrammodel$x1))
    wordlist <- unique(wordlist)
    return(wordlist)
}

# Get list of which words are NOT valid
invalid_word_list <- function(wordlist){
    filter <- apply(as.matrix(wordlist),1,checkword)
    bad_words <- wordlist[!filter]
    bad_words <- unique(bad_words)
    return(bad_words)
}
