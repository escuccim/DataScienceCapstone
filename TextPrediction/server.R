#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)

# Load the data
if(!exists("ngrams")){
    load("ngrams_clean.RData")    
}

predictText <- function(x, ngrammodel, recurse=TRUE){
    string <- tolower(x)
    string <-removePunctuation(string)
    string <- strsplit(string, " ")
    string <- rev(string[[1]])[1:5]
    len <- length(string)
    
    # Try an easier way
    i <- 1
    matches <- ngrammodel
    for(word in string){
        if(!is.na(word)){
            # Added check for NA to try to prevent overfitting | is.na(matches[,i])
            temp <- subset(matches, (matches[,i] == word  ))
            
            # Check how many unique ys there are, if we have less than 3 we can break and return
            # and no need to continue looping
            if(length(unique(matches$y)) <= 3){
                break;
            }
            
            # if we have matches keep them, otherwise skip the word and continue
            if(nrow(temp) >= 3){
                matches <- temp
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

shinyServer(function(input, output) {
  
  predictFromText <- reactive({
      text <- input$text
      
      matches <- predictText(text, ngrammodel)
  })
     
  output$prediction <- renderUI({
      if(input$text != ''){
          list <- predictFromText()
      }else{
          list <- character()
      }
      if(length(list) > 0){
          html_string <- character()
          for(word in list){
              string <- c("<li>",word,"</li>")
              html_string = c(html_string, string)
          }
          html <- c("<ol>", html_string, "</ol>")
          results <- HTML(html)
      } else {
          results <- list
      }
      results
  })
})
