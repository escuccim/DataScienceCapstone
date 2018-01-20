library(tm)

# Combine the character vectors into one for analysis
all <- as.data.frame(c(blog,news,twitter))
save(all, file="all.RData")

# Create a document term matrix
dtm <- as.DocumentTermMatrix(all, weighting=weightTf)
save(dtm, file="dtm.RData")

# Clean up
rm("all","blog","news","twitter")