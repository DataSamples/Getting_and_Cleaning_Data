if(!file.exists("F:/Data_Science_Coursera/Getting_and_Cleaning_Data"))
        dir.create("F:/Data_Science_Coursera/Getting_and_Cleaning_Data")

setwd("F:/Data_Science_Coursera/Getting_and_Cleaning_Data")

library(plyr)
library(data.table)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "courseproject.zip")

unzip("courseproject.zip", exdir = "F:/Data_Science_Coursera/Getting_and_Cleaning_Data")

#Load data into R
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
testLabels <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "Label")
trainLabels <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "Label")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

#Append subject data onto each train and test sets
test <- cbind(testSubject, testLabels, test)
train <- cbind(trainSubject, trainLabels, train)

test <- data.table(test, key = "Subject")
train <- data.table(train, key = "Subject")

#Merge train and test datasets, and sort by Subject number
merged <- rbind(train, test)
setkey(merged, Subject)

#Extract only columns containing mean and std data
meanNames <- grep("mean()", features[[2]], fixed = TRUE)
stdNames <- grep("std()", features[[2]], fixed = TRUE)
featureNames <- c(meanNames, stdNames)
features <- as.character(features[featureNames, 2])
featureNames <- featureNames + 2 ##offset by 2, to account for first two cols of merged dataset

merged <- subset(merged, select = c(1, 2, featureNames))

#Assign activities to the labels
setnames(activityLabels, c("Label", "Activity"))
merged <- merge(x = merged, y = activityLabels, by = "Label")
merged <- subset(merged, select = c(2, 69, 3:68)) #Reorder columns so Subject and Activity are first

#Assign feature names to each variable
setnames(merged, c("Subject", "Activity", features))

#Produce new tidy data
tidy <- data.table(aggregate(subset(merged, select = 3:68), by = list(merged$Activity, merged$Subject), FUN = mean))
tidy <- subset(tidy, select = c(2, 1, 3:68)) #Reorder columns so most general grouping (subject) is on the left
setnames(tidy, c("Subject", "Activity", features))

write.table(tidy, file = "tidy_data.txt", row.names = FALSE)
