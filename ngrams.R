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
save(text, file="fulltext.RData")

# Great 2 and 3 grams from the data
twograms <- tokenize_ngrams(text, lowercase=TRUE, n=2L, n_min=2L, simplify=TRUE)
# Unlist it
twograms <- unlist(twograms)
# Get frequency
twogramfreq = as.data.frame(table(twograms))
# Save and remove twograms
save(twograms, file="twograms.Rdata")
rm("twograms")
# Order and save the two grams
twogramfreq <- twogramfreq[order(-twogramfreq$Freq),]
save(twogramfreq, file="twogramfreq_raw.RData")

# Filter out ngrams that only occur once
filter <- twogramfreq$Freq > 1
twogramfreq = twogramfreq[filter,]

# Save
save(twogramfreq, file="twogramfreq.RData")

## Do the same for three grams now
threegrams <- tokenize_ngrams(text, lowercase=TRUE, n=3L, n_min=3L, simplify=TRUE)
# Unlist it
threegrams <- unlist(threegrams)
# Get frequency
threegramfreq = as.data.frame(table(threegrams))
# Save and remove twograms
save(threegrams, file="threegrams.Rdata")
rm("threegrams")
# Order and save the two grams
threegramfreq <- threegramfreq[order(-threegramfreq$Freq),]
save(threegramfreq, file="threegramfreq_raw.RData")

# Filter out ngrams that only occur once
filter <- threegramfreq$Freq > 1
threegramfreq = threegramfreq[filter,]
rm("filter")

# Save
save(threegramfreq, file="threegramfreq.RData")


## One more time for four grams
fourgrams <- tokenize_ngrams(text, lowercase=TRUE, n=4L, n_min=4L, simplify=TRUE)
# Unlist it
fourgrams <- unlist(fourgrams)
# Get frequency
fourgramfreq = as.data.frame(table(fourgrams))
# Save and remove twograms
save(fourgrams, file="fourgrams.Rdata")
rm("fourgrams")
# Order and save the two grams
fourgramfreq <- fourgramfreq[order(-fourgramfreq$Freq),]
save(fourgramfreq, file="fourgramfreq_raw.RData")

# Filter out ngrams that only occur once
filter <- fourgramfreq$Freq > 1
fourgramfreq = fourgramfreq[filter,]
rm("filter")

# Save
save(fourgramfreq, file="fourgramfreq.RData")



## One last time for five grams
fivegrams <- tokenize_ngrams(text, lowercase=TRUE, n=5L, n_min=5L, simplify=TRUE)
# Unlist it
fivegrams <- unlist(fivegrams)
# Get frequency
fivegramfreq = as.data.frame(table(fivegrams))
# Save and remove twograms
save(fivegrams, file="fivegrams.Rdata")
rm("fivegrams")
# Order and save the two grams
fivegramfreq <- fivegramfreq[order(-fivegramfreq$Freq),]
save(fivegramfreq, file="fivegramfreq_raw.RData")

# Filter out ngrams that only occur once
#filter <- fourgramfreq$Freq > 1
#fourgramfreq = fourgramfreq[filter,]
#rm("filter")

# Save
save(fivegramfreq, file="fivegramfreq.RData")

## Old code for one dataframe for ngrams of all lengths
# Filter out ngrams that only appear once
#filter <- ngramfreq$Freq > 1
#ngramfreq = ngramfreq[filter,]

#save(ngrams, file="ngrams.RData")

# Unlist it

#save(ngrams, file="unlisted_ngrams.RData")

# Group by ngram and add a frequency
#rm("text")

#save(ngramfreq, file="ngram_freq.RData")
#rm("ngrams")

# Remove any ngrams that only appear once
#filter <- ngramfreq$Freq > 1
#ngramfreq = ngramfreq[filter,]
#rm("filter")

# Sort the ngrams by frequency
#ngramfreq <- ngramfreq[order(-ngramfreq$Freq),]

# Save the data
save(ngramfreq, file="ngram_freq_filtered.RData")



