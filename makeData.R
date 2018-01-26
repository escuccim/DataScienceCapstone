load("text.RData")
source("functions.R")

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
    model <- createmodel(ngramfreq, 6)
    ngrams <- rbind(ngrams, model)
    rm("ngramfreq","model")
}
rm("text")
# Save the ngram dataframe
save(ngrams, file="sixgrams.RData")

# Reorder the columns
columns <- c("x5","x4","x3","x2","x1","y","weight")
ngrams <- ngrams[columns]
# Clean the dataframe
ngrams <- cleanmodel(ngrams)
ngrams <- scaleweight(ngrams)
save(ngrams, file="ngrams_clean.RData")

