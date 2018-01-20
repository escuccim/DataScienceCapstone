library(tm)

# Combine the character vectors into one for analysis
all <- as.data.frame(c(blog,news,twitter))

# Create a document term matrix
dtm <- as.DocumentTermMatrix(all)
save(dtm, file="dtm.RData")