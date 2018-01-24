library(tm)

# Load the data
#load("twogrammodel.RData")
#load("threegrammodel.RData")
#load("fourgrammodel.RData")
#load("fivegrammodel.RData")
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
                break
            }
            i <- i + 1    
        } else {
            break
        }
    }
    
    results <- head(unique(matches$y), 5)
    results <- as.character(results)
    return(results)
    
    # if our string only has one word
    if(len == 1){
        model <- subset(twogrammodel, twogrammodel$x1 == string[1])
    }
    # else if our string has two words
    else if(len == 2){
        model <- subset(threegrammodel, threegrammodel$x1 == string[1])
        model <- subset(model, model$x2 == string[2])
    }
    # else if our string has three words
    else if(len == 3){
        model <- subset(fourgrammodel, fourgrammodel$x1 == string[1])
        model <- subset(model, model$x2 == string[2])
        model <- subset(model, model$x3 == string[3])
    }
    # Else if our string is loner use the fivegram model
    else if(len > 0){
        if (len >= 4){
            substring <- tail(string,4)
        }
        model <- subset(fivegrammodel, fivegrammodel$x1 == substring[1])
        model <- subset(model, model$x2 == substring[2])
        model <- subset(model, model$x3 == substring[3])
        model <- subset(model, model$x4 == substring[4])
    }
    results <- head(model$y, 5)
    results <- as.character(results)
    
    # if recurse is true
    if(recurse){
        # if we have no results, remove the first word and try again
        if( (length(results) == 0) & (len > 0) ){
            string <- string[2:length(string)]
            x <- paste(string, collapse=" ")
            results <- predictText(x)
        }    
    }
    
    return(results)
}
