## Project for Getting and Cleaning Data

## Step 1a: Load all files from URL
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "test.zip", method="curl")
unzip("test.zip")
getwd()
list.files()
setwd("UCI HAR Dataset")

#3 if files are already downloaded and saved in directory in same place
## simply run the code below

library(dplyr)

##Step 1b: Read test data and check dimensions
XTestData <- read.table("X_test.txt")
YTestData <- read.table("y_test.txt")
SubjectTestData <- read.table("subject_test.txt")
dim(XTestData)
dim(YTestData)
dim(SubjectTestData)

##Step 1c: Read train data and check dimensions

XTrainData <- read.table("X_train.txt")
YTrainData <- read.table("y_train.txt")
SubjectTrainData <- read.table("subject_train.txt")
dim(XTrainData)
dim(YTrainData)
dim(SubjectTrainData)

##Step 1d: Give variables a name based on features.txt

features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")
colnames(XTrainData) <- c(as.character(features[,2]))
colnames(XTestData) <- c(as.character(features[,2]))

##Step 1e: Add variable for activity id (from YTest and YTrain Data) and subject id 
## (from SubjectTest and SubjectTrain data) for both train and test data

XTrainWithActivityID <- cbind(YTrainData, XTrainData)
colnames(XTrainWithActivityID)[1] <- "ActivityID"
XTrainWithActivityIDandSubject <- cbind(SubjectTrainData, XTrainWithActivityID)
colnames(XTrainWithActivityIDandSubject)[1] <- "Subject"
rm(XTrainWithActivityID)

XTestWithActivityID <- cbind(YTestData, XTestData)
colnames(XTestWithActivityID)[1] <- "ActivityID"
XTestWithActivityIDandSubject <- cbind(SubjectTestData, XTestWithActivityID)
colnames(XTestWithActivityIDandSubject)[1] <- "Subject"

##clean global environment
rm(XTestWithActivityID)
rm(features)
rm(activities)
rm(XTrainData)
rm(XTestData)
rm(YTrainData)
rm(YTestData)
rm(SubjectTestData)
rm(SubjectTrainData)

## Step 2. Combine train and test data

CombinedDataXY <- rbind(XTestWithActivityIDandSubject, XTrainWithActivityIDandSubject)
rm(XTestWithActivityIDandSubject)
rm(XTrainWithActivityIDandSubject)

##Step 3. Only keep variables containing "mean" or "std" by combining subsets of dataframes
## containing "mean", "Mean" or "std" in their variable names; results in 10299 observations with
##86 variables
attach(CombinedDataXY)
CombinedDataSubject <- data.frame(CombinedDataXY[,"Subject"])
CombinedDataActivityID <- data.frame(CombinedDataXY[,"ActivityID"])
CombinedDataXYforMean <- CombinedDataXY[,grep("mean", names(CombinedDataXY), value=TRUE)]
CombinedDataXYforMeanM <- CombinedDataXY[,grep("Mean", names(CombinedDataXY), value=TRUE)]
CombinedDataXYforSD <- CombinedDataXY[,grep("std", names(CombinedDataXY), value=TRUE)]
CombinedDataXYforMeanandSD <- cbind(CombinedDataSubject, CombinedDataActivityID, CombinedDataXYforMean, CombinedDataXYforMeanM, CombinedDataXYforSD)
colnames(CombinedDataXYforMeanandSD)[1] <- "Subject"
colnames(CombinedDataXYforMeanandSD)[2] <- "ActivityID"
rm(CombinedDataSubject)
rm(CombinedDataActivityID)
rm(CombinedDataXYforMean)
rm(CombinedDataXYforMeanM)
rm(CombinedDataXYforSD)
rm(CombinedDataXY)

##Step 4. Create a column "ActivityDescr" for describing each activity in words for each row

activitylabels <- read.table("activity_labels.txt")
colnames(activitylabels) <- c("ActivityID", "ActivityDescr")
CombinedDataXYforMeanandSDwithLabels <- merge(activitylabels, CombinedDataXYforMeanandSD, by="ActivityID")
aggdata <-aggregate(TEST, by=list(CombinedDataXYforMeanandSDwithLabels$Subject, CombinedDataXYforMeanandSDwithLabels$ActivityID), 
                      FUN=mean, na.rm=TRUE)

## Remove older "activityid" and "subject" columns that have been replaced by "group"
tidy_dataset <- cbind(data.frame(aggdata[,(1:2)]),data.frame(aggdata[,(6:89)]))
colnames(tidy_dataset)[1:2] <- c("Subject", "ActivityID")
write.table(tidy_dataset, "tidy_dataset.txt", row.names=FALSE)
rm(aggdata)
rm(CombinedDataXYforMeanandSDwithLabels)

## Step 5. Independent dataset creation with avg of each variable for each subject and activity
