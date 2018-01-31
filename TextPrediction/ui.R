#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text Prediction"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       h3("Instructions"),
       p("Type a phrase in the box and it will predict the next word. Click on the prediction you would like to use and it will be added to your text."),
       h3("About the algorithm"),
       p("The algorithm starts with a corpus of text which is broken up into sentences and words. The words are converted into n-grams of length two through six. When you enter your text, the algorithm goes through the data to find the words that are most likely to follow."),
       h3("The code"),
       p("The source code is on my GitHub:"),
       a("Source code", href="https://github.com/escuccim/DataScienceCapstone"),
       p("Instructions on how to run it are in the ReadMe.md file.")
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       h2("Text Prediction"),
       textInput("text", "Enter your text:"),
      # submitButton("Predict"),
       h3("Predictions:"),
       htmlOutput("prediction"),
       hr(),
       p("Note: it may take a few seconds to load the data the first time this is run. Please be patient!")
    )
  ),
  includeHTML("www/html.html")
))
