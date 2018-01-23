library(tm)
library(RWeka)
library(dplyr)
library(magrittr)
library(tokenizers)

# Split the strings into features
splitngrams <- function(x) {
    strsplit(x, " ")
}

createngrams <- function(text, n, filter=FALSE){
    ngrams <- tokenize_ngrams(text, lowercase=TRUE, n=n, n_min=n, simplify=TRUE)
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

createmodel <- function(ngramfreq){
    ngramfreq$ngrams <- as.character(ngramfreq$ngrams)
    
    splits <- splitngrams(ngramfreq$ngrams)
    splits <- do.call(rbind, splits)
    splits <- as.data.frame(splits)
    
    # Name the columns
    numcols = ncol(splits)
    names(splits)[numcols] <- "y"
    nums <- 1:(numcols-1)
    names = c(paste("x",nums,sep=""),"y")
    names(splits) <- names
    
    # names(splits) <- c("xone","xtwo","xthree","y")
    
    splits$weight <- ngramfreq$Freq
    ngrammodel <- splits
    return(ngrammodel)
}