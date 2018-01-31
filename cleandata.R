# Load a list of English words
words <- read.csv("words.txt")
words <- words$X2
words <- tolower(words)
save(words, file="validwords.RData")

# Create a list of unique words from the model
wordlist <- c(as.character(ngrammodel$y), as.character(ngrammodel$x5), as.character(ngrammodel$x4), as.character(ngrammodel$x3), as.character(ngrammodel$x2), as.character(ngrammodel$x1))
wordlist <- unique(wordlist)

# Load functions
source("functions.R")

# FInd out which words are NOT in the list
filter <- apply(as.matrix(wordlist),1,checkword)
bad_words <- wordlist[!filter]
bad_words <- unique(bad_words)
save(bad_words, file="bad_words.RData")

# Load our Ngram model
load("ngrams_clean.RData")

# We don't want to predict non-existent words, so remove any y's which aren't valid words
y <- ngrammodel$y
filter <- unlist(lapply(as.character(y), function(x) x %in% bad_words))
ngrammodel <- ngrammodel[!filter,]
save(ngrammodel, file="ngrams_clean.RData")

x5 <- ngrammodel$x5
filter <- unlist(lapply(as.character(x5), function(x) x %in% bad_words))
ngrammodel <- ngrammodel[!filter,]
rm(x5)

x4 <- ngrammodel$x4
filter <- unlist(lapply(as.character(x4), function(x) x %in% bad_words))
ngrammodel <- ngrammodel[!filter,]
rm(x4)

x3 <- ngrammodel$x3
filter <- unlist(lapply(as.character(x3), function(x) x %in% bad_words))
ngrammodel <- ngrammodel[!filter,]
rm(x3)

x2 <- ngrammodel$x2
filter <- unlist(lapply(as.character(x2), function(x) x %in% bad_words))
ngrammodel <- ngrammodel[!filter,]
rm(x2)

x1 <- ngrammodel$x1
filter <- unlist(lapply(as.character(x1), function(x) x %in% bad_words))
ngrammodel <- ngrammodel[!filter,]
rm(x1)

rownames(ngrammodel) <- 1:nrow(ngrammodel)

save(ngrammodel, file="ngrams_clean.RData")
saveRDS(ngrammodel, file="ngrammodel.Rds")

# We are going to keep the other word regardless of whether they are real words or not, because having
# them can't hurt the model