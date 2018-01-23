library(tm)

# Load the data
load("threegramFeatureMatrix.RData")
load("twogramFeatureMatrix.RData")
load("fourgramFeatureMatrix.RData")
load("fourgramFeatureMatrix.RData")

# create a prediction function
predictText <- function(x){
    string <- tolower(x)
    string <-removePunctuation(string)
    split <- strsplit(string, " ")
    string <- split[[1]]
    
    len <- length(string)
    
    # if our string is 2 characters long use the three gram model
    if(len == 2){
        model <- subset(threegrammodel, threegrammodel$xone == string[1])
        model <- subset(model, model$xtwo == string[2])
        
    }
    # If length is 1 use the two gram model
    else if(len == 1){
        model <- subset(twogrammodel, twogrammodel$xone == string[1])
    }
    # Else use the four gram model on the last three words on the string
    else if(len > 0){
        if (len > 3){
            substring <- tail(string,3)
        }
        model <- subset(fourgrammodel, fourgrammodel$xone == substring[1])
        model <- subset(model, model$xtwo == substring[2])
        model <- subset(model, model$xthree == substring[3])
    }
    results <- head(model$y, 5)
    results <- as.character(results)
    
    # if we have no results, remove the first word and try again
    if( (length(results) == 0) & (len > 0) ){
        string <- string[2:length(string)]
        x <- paste(string, collapse=" ")
        results <- predictText(x)
    }
    return(results)
}
