library(tm)
library(RWeka)
library(dplyr)
library(magrittr)
library(tokenizers)

load("news.RData")
load("twitter.RData")
load("blog.RData")

text = c(news, twitter, blog)
text = iconv(text, "latin1", "ASCII", sub="")
rm("news","twitter","blog")

# Great 2 and 3 grams from the data
ngrams <- tokenize_ngrams(text, lowercase=TRUE, n=3L, n_min=2L, simplify=TRUE)
save(ngrams, file="ngrams.RData")

# Unlist it
ngrams <- unlist(ngrams)
save(ngrams, file="unlisted_ngrams.RData")

# Group by ngram and add a frequency
rm("blog","news","twitter","text")
ngramfreq = as.data.frame(table(ngrams))
save(ngramfreq, file="ngram_freq.RData")

# Remove any ngrams that only appear once
filter <- ngramfreq$Freq > 1
ngramfreq = ngramfreq[filter,]

# Sort the ngrams by frequency
ngramfreq <- ngramfreq[order(ngramfreq, -ngramfreq$Freq),]

# Save the data
save(ngramfreq, file="ngram_freq_filtered.RData")

rm("ngrams")

