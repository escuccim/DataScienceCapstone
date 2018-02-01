library(tm)
source("functions.R")

# load the raw data
load("raw_blog.RData")
load("raw_news.RData")
load("raw_twitter.RData")

# Remove profanity
profanity <- grepl(" +[Ff]uck|[Ss]hit|[Cc]unt|[Aa]sshole +", twitter)
twitter <- twitter[!profanity]

profanity <- grepl(" +[Ff]uck|[Ss]hit|[Cc]unt|[Aa]sshole +", blog)
blog <- blog[!profanity]

# subset data
rfilter <- rbinom(length(twitter), size=1, prob=0.5)
filter <- rfilter == 1
twitter <- twitter[filter]

rfilter <- rbinom(length(blog), size=1, prob=0.5)
filter <- rfilter == 1
blog <- blog[filter]

# clean data
blog <- cleanData(blog)
news <- cleanData(news)
twitter <- cleanData(twitter)

# Combine the files into one and save it
text = c(news, twitter, blog)

# Clean up
rm("news","twitter","blog")

# Remove non-ASCII characters
text = iconv(text, "latin1", "ASCII", sub="")

# Save
save(text, file="big_text.RData")

ngrammodel <- makedata(text)
save(ngrammodel, file="ngrammodel_big.RData")
rm(text)

# Clean the model
ngrammodel <- cleanmodel(ngrammodel, threshhold=3)
ngrammodel <- scaleweight(ngrammodel)

# Get list of valid words
words <- read.csv("words.txt")
words <- words$X2
words <- tolower(words)

# Get list of unique words
wordlist <- uniquewords(ngrammodel)

# Get list of invalid words
bad_words <- invalid_word_list(wordlist)

# Filter out invalid words
ngrammodel <- validateWords(ngrammodel, bad_words)