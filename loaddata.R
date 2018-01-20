## R Script to load raw data in from txt files, remove profanity, remove punctuation and numbers
## and trim the data down to a manageable size
## Data is then saved to RData files

# Function to clean data
library(tm)
cleanData <- function(data){
    data <- removeNumbers(data)
    data <- removePunctuation(data)
    data
}


# Read the  data in
blog <- readLines("final/en_US/en_US.blogs.txt", encoding="UTF-8")
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding="UTF-8")
news <- readLines("final/en_US/en_US.news.txt", encoding="UTF-8")

# Save the raw data
save(blog, file="raw_blog.RData")
save(news, file="raw_news.RData")
save(twitter, file="raw_twitter.RData")

## Twitter
# Remove profanity
profanity <- grepl(" +[Ff]uck|[Ss]hit|[Cc]unt|[Aa]sshole +", twitter)
twitter <- twitter[!profanity]

# Only keep half of the twitter data
set.seed(123455)
rfilter <- rbinom(length(twitter), size=1, prob=0.5)
filter <- rfilter == 1
twitter <- twitter[filter]

# Clean the data and save it
twitter <- cleanData(twitter)
save(twitter, file="twitter.RData")

## Blog 
# remove profanity
profanity <- grepl(" +[Ff]uck|[Ss]hit|[Cc]unt|[Aa]sshole +", blog)
blog <- blog[!profanity]

# Get the blog down to a manageable size by removing half
rfilter <- rbinom(length(blog), size=1, prob=0.5)
filter <- rfilter == 1
blog <- blog[filter]

# Clean and save the data
blog <- cleanData(blog)
save(blog, file="blog.RData")

## News
# There is no need to remove profanity, so just clean and save it
news <- cleanData(news)
save(news, file="news.RData")
# Clean up
rm("filter", "rfilter","profanity")

## Tokenize the text
#library(tokenizers)
#tnews <- tokenize_words(news)
#tblog <- tokenize_words(blog)
#ttwitter <- tokenize_words(twitter)

#save(tblog, file="token_blog.RData")
#save(tnews, file="token_news.RData")
#save(ttwitter, file="token_twitter.RData")


