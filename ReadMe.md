---
title: "ReadMe"
output: html_document
---

This is a ReadMe file for the Coursera Getting and Cleaning Data course project.

The data for the project was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, which contains data read from subjects' activities while using the Samsung Galaxy SII. More information about the data itself can be found at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. Only the average values of the variables reporting mean and standard deviation of a given measurement for the training and test set data were used for this project.

Codebook.md contains information about each variable contained in the dataset.

==========================================================================

##Pre-processing
###Reading the data 
The data was first downloaded and unzipped into the working directory. The necessary files were then read into R. The datasets were stored as data tables using the data.table package for ease of manipulation.

###Initial merges to complete test and train datasets
The subject data and activity labels were next appended to each dataset, obtained from the Y_---.txt files and the subject---.txt files.

==========================================================================

##Processing
###Merging test and train data
The test and training data were merged using rbind(), and the data was sorted by Subject number.

###Extracting Standard Deviation and Mean
The dataset was subsetted to only include information from mean and standard deviation on each exercise. The mean or standard deviation of an exercise were defined as only on complete measurements - i.e. if an angle was measured between Body Gyro Mean and Gravity Mean, this was not included in the final dataset. Only feature names with "mean()" or "std()" in the variable name were taken. A total of variables were used. They are explained in the codebook.

###Labelling each activity
Following the subset, each number label in the dataset was renamed with the descriptive activity, based on the activity_labels.txt file. The renaming was done by use of the merge() function - automatic reordering of the elements which merge() performs was taken into account.

###Variable names assigned
The variable names in the merged dataset were set according to the list of features found in features.txt, subsetted for only the features measuring mean() or std().

==========================================================================

##Final tidy data set 
###composed of aggregate means
The final tidy data set represents the average of each variable, as measured for each activity and for each subject. The aggregate() function was used to assemble the data.