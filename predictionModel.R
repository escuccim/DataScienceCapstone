library(tm)

# Load the data
load("ngrams_clean.RData")

# create a prediction function
predictText <- function(x, recurse=TRUE){
    string <- tolower(x)
    string <-removePunctuation(string)
    string <- strsplit(string, " ")
    string <- rev(string[[1]])[1:5]
    len <- length(string)
    
    # Try an easier way
    i <- 1
    matches <- ngrams
    for(word in string){
        if(!is.na(word)){
            temp <- subset(matches, matches[,i] == word)
            if(nrow(temp) >= 3){
                matches <- temp
            } else {
                # skip and continue
            }
            i <- i + 1    
        } else {
            break
        }
    }
    
    results <- head(unique(matches$y), 5)
    results <- as.character(results)
    return(results)
}
