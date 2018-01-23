source("functions.R")
# Create a model for 3 grams
load("threegramfreq.RData")

# Change the threegrams column into a character
threegramfreq$threegrams <- as.character(threegramfreq$threegrams)

splits <- splitngrams(threegramfreq$threegrams)
splits <- do.call(rbind, splits)
splits <- as.data.frame(splits)
names(splits) <- c("xone","xtwo","y")
splits$weight <- threegramfreq$Freq
threegrammodel <- splits
save(threegrammodel, file="threegramFeatureMatrix.RData")


## Create one for four grams
load("fourgramfreq.RData")

# Change the threegrams column into a character
fourgramfreq$fourgrams <- as.character(fourgramfreq$fourgrams)

splits <- splitngrams(fourgramfreq$fourgrams)
splits <- do.call(rbind, splits)
splits <- as.data.frame(splits)
names(splits) <- c("xone","xtwo","xthree","y")
splits$weight <- fourgramfreq$Freq
fourgrammodel <- splits
save(fourgrammodel, file="fourgramFeatureMatrix.RData")


## And again for two grams
load("twogramfreq.RData")

# Change the threegrams column into a character
twogramfreq$twograms <- as.character(twogramfreq$twograms)

splits <- splitngrams(twogramfreq$twograms)
splits <- do.call(rbind, splits)
splits <- as.data.frame(splits)
names(splits) <- c("xone","y")
splits$weight <- twogramfreq$Freq
twogrammodel <- splits
save(twogrammodel, file="twogramFeatureMatrix.RData")

## And once more for five grams
load("fivegramfreq.RData")

# Change the threegrams column into a character
fivegramfreq$fivegrams <- as.character(fivegramfreq$fivegrams)

splits <- splitngrams(fivegramfreq$fivegrams)
splits <- do.call(rbind, splits)
splits <- as.data.frame(splits)
names(splits) <- c("xone","y")
splits$weight <- fivegramfreq$Freq
fivegrammodel <- splits
save(fivegrammodel, file="fivegramFeatureMatrix.RData")


## Clean up
rm("splits","fourgramfreq","threegramfreq","twogramfreq", "fivegramfreq")

