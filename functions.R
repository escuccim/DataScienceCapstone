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
createngrams <- function(text, n, filter=FALSE){
    sentences <- unlist(tokenize_sentences(text))
    ngrams <- tokenize_ngrams(sentences, lowercase=TRUE, n=n, n_min=n, simplify=TRUE)
    # Unlist it
    ngrams <- unlist(ngrams)
    # Get frequency
    ngramfreq = as.data.frame(table(ngrams))
    # Save and remove twograms
    
    rm("ngrams")
    # Order and save the two grams
    ngramfreq <- ngramfreq[order(-ngramfreq$Freq),]
    
    if(filter){
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
cleanmodel <- function(model) {
    numx <- ncol(model) - 2
    xcols <- 1:numx
    cols <- paste("x", xcols, sep="")
    # Create an empty dataframe with same columns
    newmodel <- model[0,]
    
    # Get unique combinations of cols
    uniqueRows <- unique(model[cols])
    filter = rep(FALSE, nrow(model))
    fillvalues = rep(TRUE, 3)
    
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