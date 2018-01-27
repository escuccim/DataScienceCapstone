library(tm)
library(RWeka)
library(dplyr)
library(magrittr)
library(tokenizers)

# Load the data
load("news.RData")
load("twitter.RData")
load("blog.RData")

# Combine them into one big file
# text <- c(blog,news,twitter)

# Let's try with just the news data, as all the data is too big

# Remove non-ASCII characters as they cause problems
text = iconv(news, "latin1", "ASCII", sub="")
save(text, file="text.RData")
rm("blog","news","twitter")

# Get the text down to a manageable size because when we convert it to a corpus it gets huge
rfilter <- rbinom(length(text), size=1, prob=0.125) == 1
text <- text[rfilter]
rm("rfilter")

corpus <- VCorpus(VectorSource(text))
save(corpus, file="corpus.RData")
#tdm = as.matrix(TermDocumentMatrix(corpus))
tdm <- as.matrix(TermDocumentMatrix(corpus, control = list(wordLengths = c(3, Inf))))
frequencycount <- rowSums(tdm)
save(tdm, file="tdm.RData")
rm("tdm")
frequencycount <- sort(frequencycount, decreasing=TRUE)
save(frequencycount, file="frequencycount.RData")