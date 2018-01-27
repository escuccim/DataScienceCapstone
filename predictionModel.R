library(tm)

# Load the data
if(!exists("ngrams")){
    load("ngrams_clean.RData")    
}


# create a prediction function
predictText <- function(x){
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
            # Added check for NA to try to prevent overfitting
            # | is.na(matches[,i])
            temp <- subset(matches, (matches[,i] == word  ))
            
            # if we have matches keep them, otherwise skip the word and continue
            if(nrow(temp) >= 2){
                matches <- temp
            } 
            
            # Check how many unique ys there are, if we have less than 3 we can break and return
            # and no need to continue looping
            if(length(unique(matches$y)) <= 3){
                break;
            }
            
            i <- i + 1    
        } else {
            break
        }
    }
    
    # Filter out duplicate ys because they don't add anything
    matches = matches[!duplicated(matches$y, fromLast=TRUE),]
    
    # sort the matches
    matches <- matches[ order(matches$weight, row.names(matches), decreasing=TRUE), ]
    
    # Take the top 3
    results <- head(unique(matches$y), 3)
    results <- as.character(results)
    return(results)
}