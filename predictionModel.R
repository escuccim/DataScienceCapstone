# Load the data
load("threegrammodel.RData")
load("twogrammodel.RData")
load("fourgrammodel.RData")

# create a prediction function
predictText <- function(x){
    string <- tolower(x)
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
            string <- tail(string,3)
        }
        model <- subset(fourgrammodel, fourgrammodel$xone == string[1])
        model <- subset(model, model$xtwo == string[2])
        model <- subset(model, model$xthree == string[3])
    }
    results <- head(model$y, 3)
    results <- as.character(results)
    return(results)
}
