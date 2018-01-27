# Text Prediction
By Eric Scuccimarra (skooch@gmail.com)

This contains the code for my text prediction algorithms and application, as created for the Capstone course in the Johns Hopkins University Data Science specialization on Coursera.

## Loading Data
File: loaddata.R

The data are loaded from text files containing English language data from twitter, blogs and news. Profanity is removed, and the data are randomly subsetting to a manageable size. Then the data are combined into one character vector and saved.

## Exploratory Data Analysis
Files: eda.R, frequencytable.R

A TermDocumentMatrix is created containing words of length 3 characters or longer to give a sense of the frequency of words in the corpus.

## Data Preprocessing
**File makeData.R**

This file creates a full ngram model from the original corpus, using the functions described below. 
1. The corpus is loaded and an empty data frame is initialized. 
2. Frequency tables are created for ngrams of length 2 to 6. These are combined into one large dataframe.
3. The columns are reorderd so that the words appear in reverse order as they do in the actual ngram.
4. The model is cleaned and the weights are scaled.
5. The model is saved to an RData file.

## Prediction Model

I tried to fit some machine learning prediction models to the data, but was unable to do so due to the high amount of RAM required to create random forest or decision trees for such a large dataset.

File predictionModel.R contains the function that actually does the prediction.

Function predictText(x) takes a string as input and returns a character vector with the top three predictions.

1. The string is converted to lowercase, and punctuation is removed. The character vector is reversed and the first five elements are retained.
2. The model of ngrams is copied into a temporary variable.
3. The words in the string vector are looped through:
    1. The ngrams are subsetted by matching the current word to that position in the ngrams.
    2. If there are two or more results in the set the matches are kept. Otherwise the word is skipped and the loop proceeds. This is an attempt to try to avoid returning no results.
    3. If there are three or fewer unique ys remaining in the matches the loop is exited.
4. Duplicate ys are removed from the matches.
5. The matches are ordered by decreasing weight.
6. The first three unique ys are returned as the predictions.

## Application

The algorithm is put into a Shiny application which is contained in the folder TextPrediction.

## Creating the Data Files
The file **loaddata.R** will read in the text files, perform the preprocessing and save the text to an RData file.

The file **makeData.R** will load in the text object and create the model, which will be saved to RData file and RDS file.

The file **predictionModel.R** will read in the ngram models and create a function that takes a string as input and returns the top three matches:

```
predictText("i like to")
```


## Functions
File: functions.R

**function createngrams(text, n, filter_results = FALSE)**

This function takes in a corpus of text (text), the number of grams (n), and whether or not to only keep ngrams that occur more than once (filter). The function tokenizes the sentences, then the words in each sentence into ngrams of length n.

The ngrams are converted into a frequency table dataframe, which contains each ngram and the number of times it occurs. If filter is TRUE only ngrams that occur more than once will be retained. This would be used to ensure that only common ngrams are retained.

The ngram frequency data frame is returned.

**function createmodel(ngramfreq, cols=6)**

This function takes a ngram frequency table returned by createngrams as input and returns a dataframe containing a model for that ngram.

The ngram in the frequency table is broken up into individual words. The last word in the ngram is set as "y" and the preceding cols-1 words are set as features x1-x(cols-1). The feature columns are front-padded with NAs so that the ngrams are right aligned in the available columns.

The frequency of each ngram is stored in the "weight" column.

The ngrammodel is returned.

**function cleanmodel(model, threshhold=3)**

This function takes in a model and only keeps the top threshhold ngrams. The default threshhold is three, so for each unique combination of features, only the top three ys are kept.

The cleaned model is returned.

**function scaleweight(ngrams)***

This function turns the weights into a log10 scale. Most of the ngrams only occur once, while some of the two-grams occur thousands of times. This leads to both the mean and median of the unscaled weights being 1 or close to 1, while the range goes from 1 to 2,000. A lower limit on the weight of 0.1 is set. Doing this brings the range to 0.1 to approximately 4.

The ngrammodel are returned with the scaled weight.

**Other Functions**

Other functions are included in this file which are either unused or used in the preprocessing of the data.

