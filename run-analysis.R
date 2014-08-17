setwd("~/Dropbox/RAssignments/Getting and cleaning data/Project")
# install.packages("data.table")
# install.packages("reshape2")
library(data.table)
library(reshape2)

## Merges the training and the test sets to create one data set.

features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

testing = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

dataset <- rbind(training,testing)
names(dataset) = c(as.character(features$V2),"activityid","subjectid")

## Extracts only the measurements on the mean and standard deviation for each measurement. 

filter <- grep(".*mean.*|.*std.*", features[,2])
filteredDataset <-dataset[,c(filter,562,563)]

## Uses descriptive activity names to name the activities in the data set

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
names(activityLabels) = c("id","activity")
mergedDataset = merge(filteredDataset,activityLabels,by.x="activityid",by.y="id")

## Appropriately labels the data set with descriptive variable names. 

names(mergedDataset) <- tolower(gsub('[()-]', '', names(mergedDataset)))

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

meltDataset <- melt(mergedDataset,id=c("activity","subjectid"),measure.vars=names(mergedDataset)[2:80])
tidyDataset <- dcast(meltDataset, activity+subjectid ~ variable, mean)
write.table(tidyDataset, file = "./tidydataset.txt",row.name=FALSE)

