## CodeBook.md

This file records process following and the steps in the code

PROCESS

The coding steps are recorded below, and correspond to the hashed comments in the R file.

##Step 1a: Load all files from URL
In this step, we download the data files from the online web link, and unzip the downloaded files into UCI HAR Dataset.

##Step 1b: Read test data and check dimensions
We next read the data in the downloaded text files, first the text data. Below is a variable description:

XTestData contains all the observed values (2947) for each of the 561 features* for 30 subjects across 6 different activities.
These 561 features are listed in features.txt file. Several of them are missing from our final tidydataset because
we are interested only in variables about mean and standard deviation.

YTestData contains the code of the activity performed corresponding to each row in the XTestData. Binding these two datasets by column 
(cbind) gives us the whole test data with activity ids. 

##Step 1c: Read train data and check dimensions

Same as step 1b for test data above, we create XTrainData and YTrainData for all observed values (7352) for each of the 561 measured features for 30 subjects across 6 different activities. Again, YTrainData is the code of activityIDs performed.

##Step 1d: Give variables a name based on features.txt

We next name the variables/columns for the new XTrain and XTest Data to know which variables is what. 

##Step 1e: Add variable for activity id (from YTest and YTrain Data) and subject id 
## (from SubjectTest and SubjectTrain data) for both train and test data

Further, we add the activity id and subject number from YData and SubjectData by column binding the two datasets for both 
test and train data. 

## Step 2. Combine train and test data

Here we combine test and train data sets, that now have both activity id and subject number to get XTestWithActivityIDandSubject and XTrainWithActivityIDandSubject.

##Step 3. Only keep variables containing "mean" or "std" by combining subsets of dataframes
## containing "mean", "Mean" or "std" in their variable names; results in 10299 observations with
##86 variables

Variable selection
In our subsetting process, we deselect any other variables such as min, max, correlation, etc. relating to the various measures
on which data is collected for the experiment via gyroscope readings or acceleration ones. We only retain mean and standard deviation.
This leaves us with 86 variables to work with.

##Step 4. Create a column "ActivityDescr" for describing each activity in words for each row

After merging the test and train data, we label the activities, e.g., activity id 1 could mean sitting, and so on. This is based on activity.txt file.

## Step 5. Independent dataset creation with avg of each variable for each subject and activity

Finally we group our data by subject and activity using the function mean, to get a final tidy dataset of means for each subject and activity. This results in the final tidy_dataset we uploaded. 


Credit/source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

Reference

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.



