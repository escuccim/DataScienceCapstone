# Read the English data in
blog <- readLines("final/en_US/en_US.blogs.txt", encoding="UTF-8")
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding="UTF-8")
news <- readLines("final/en_US/en_US.news.txt", encoding="UTF-8")

# Save the raw data
save(blog, file="raw_blog.RData")
save(news, file="news.RData")
save(twitter, file="raw_twitter.RData")

# Since we are getting rid of some twitter data, let's filter out the profanity first
profanity <- grepl(" +[Ff]uck|[Ss]hit|[Cc]unt|[Aa]sshole +", twitter)
twitter <- twitter[!profanity]
save(twitter, file="twitter_filtered.RData")

# Only keep half of the twitter data
set.seed(123455)
rfilter <- rbinom(length(twitter), size=1, prob=0.5)
filter <- rfilter == 1
twitter <- twitter[filter]

save(twitter, file="twitter.RData")

## There aren't that many lines with profanity, so let's just remove them
# Filter out blog profanities
profanity <- grepl(" +[Ff]uck|[Ss]hit|[Cc]unt|[Aa]sshole +", blog)
blog <- blog[!profanity]
save(blog, file="blog.RData")

# The news seems fine, no need to filter out profanity

# Clean up
rm("filter", "rfilter","profanity")

## Tokenize the text
library(tokenizers)
tnews <- tokenize_words(news)
tblog <- tokenize_words(blog)
ttwitter <- tokenize_words(twitter)

save(blog, file="token_blog.RData")
save(news, file="token_news.RData")
save(twitter, file="token_twitter.RData")

