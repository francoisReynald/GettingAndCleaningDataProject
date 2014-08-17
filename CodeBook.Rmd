---
title: "CodeBook.md"
author: "François Reynald"
date: "17 août 2014"
output: html_document
---

This code book describes the variables, the data, and the transformations performed to clean up the data collected from the accelerometers from the Samsung Galaxy S smartphone https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
A full description of the dataset is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


# Variables
The variables are the activities : WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING 
and the subjects indexed from 1 to 30.

# Data

The data is the average of the mean and standard deviation of the measures in the initial dataset.

# Transformations

The initial dataset has been split in two datasets, training and testing; for machine learning purposes.
The first transformation is to merge those dataset to gather all the observations.
```{r}
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

testing = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

dataset <- rbind(training,testing)
names(dataset) = c(as.character(features$V2),"activityid","subjectid")
```

Next, only the measurements on the mean and standard deviation for each measurement are filtered.
```{r}
filter <- grep(".*mean.*|.*std.*", features[,2])
filteredDataset <-dataset[,c(filter,562,563)]
```

A column with the activity values is added using a merge join on the activity keys.
```{r}
activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
names(activityLabels) = c("id","activity")
mergedDataset = merge(filteredDataset,activityLabels,by.x="activityid",by.y="id")
```

The names of the columns are then stripped from parenthesis and dashes and converted to lower case.
```{r}
names(mergedDataset) <- tolower(gsub('[()-]', '', names(mergedDataset)))
```
Last a second independent tidy data set with the average of each variable for each activity and each subject is created in the working directory using the functions melt and dcast from reshape2 package.
```{r}
meltDataset <- melt(mergedDataset,id=c("activity","subjectid"),measure.vars=names(mergedDataset)[2:80])
tidyDataset <- dcast(meltDataset, activity+subjectid ~ variable, mean)
write.table(tidyDataset, file = "./tidydataset.txt",row.name=FALSE)
```


