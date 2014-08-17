---
title: "README"
author: "François Reynald"
date: "17 août 2014"
output: html_document
---

# Getting and cleaning data

## Course Project

You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##Steps to run this script

1. Download and unzip the data in a directory: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2. Download the run-analysis.R script in the same directory
3. Open your R favorite environment
4. Install packages "data.table" and "reshape2"
5. Run the run-analysis.R script:  a tidydataset.txt file will created in the same directory

Plesase refer to the CodeBook for a description of the transformations performed by the script

## Dependencies
"data.table","reshape2"