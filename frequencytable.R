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
#tdm = as.matrix(TermDocumentMatrix(corpus))
tdm <- as.matrix(TermDocumentMatrix(corpus, control = list(wordLengths = c(1, Inf))))
frequencycount <- rowSums(tdm)


df <- as.data.frame(corpus)
save(df, file="corpus_df.RData")
rm("df")

# Get ngrams out of the data
ngrams <- tokenize_ngrams(corpus, lowercase=TRUE, n=4L, n_min=2L, simplify=TRUE)
save(ngrams, file="ngrams.RData")
rm("ngrams")

# Tokenize the words
words <- tokenize_words(corpus)
words <- unlist(words)
save(words, file="words.RData")
rm("words")

#uniqueWords = function(d) {
    return(paste(unique(strsplit(d, " ")[[1]]), collapse = ' '))
}

#corpus = VCorpus(VectorSource(corpus))
#corpus = tm_map(corpus, content_transformer(uniqueWords))
#tdm = as.matrix(TermDocumentMatrix(corpus, control = list(wordLengths = c(1, Inf))))



tdm
rowSums(tdm)