## Download the file and store it in the data folder

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

## Unzip

unzip(zipfile="./data/Dataset.zip",exdir="./dataset")

## Get the file List
list_file <- file.path("./dataset", "UCI HAR Dataset")
file <- list.files(list_file, recursive = TRUE)
file

## Read data - Activity
activity_test <- read.table(file.path(list_file, "test", "Y_test.txt"), header = FALSE)
activity_train <- read.table(file.path(list_file, "train", "Y_train.txt"), header = FALSE)

## Read data - Subject
subject_train <- read.table(file.path(list_file, "train", "subject_train.txt"), header = FALSE)
subject_test <- read.table(file.path(list_file, "test", "subject_test.txt"), header = FALSE)


## Read data - Features
features_test <- read.table(file.path(list_file, "test", "X_test.txt"), header = FALSE)
features_train <- read.table(file.path(list_file, "train", "X_train.txt"), header = FALSE)

## Look at the variables' structure

str(activity_test)
str(activity_train)
str(subject_test)
str(subject_train)
str(features_test)
str(features_train)

## Merge training and test variables

data_subject <- rbind(subject_train, subject_test)
data_activity <- rbind(activity_train, activity_test)
data_features <- rbind(features_train, features_test)

## Set names to variables

names(data_subject) <- c("subject")
names(data_activity) <- c("activity")
data_features_names <- read.table(file.path(list_file, "features.txt"), head = FALSE)
names(data_features) <- data_features_names$V2

## Merfe columns to het data frame 
data_combines <- cbind(data_subject, data_activity)
Data <- cbind(data_features, data_combines)

## Subset names of features on mean and standard deviation

subset_features_names <- data_features_names$V2[grep("mean\\(\\)|std\\(\\)", data_features_names$V2)]

## Subset data frame by names of features

subset_selected_names <- c(as.character(subset_features_names), "subject", "activity")
Data <- subset(Data, select = subset_selected_names)

## check the structure of the DATA data frame

str(Data)

## Read the activities names from "activity_labels.txt"

activity_labels <- read.table(file.path(list_file, "activity_labels.txt"), header = FALSE)


## Label the dataset with descriptive variable names
## t = Time / acc = Accelerometer / gyro = Gyroscope / f = Frequency / mag = Magnitude / BodyBody = Body

names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## create a tidy data set

library(dplyr)
Data2 <- aggregate(. ~subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject, Data2$activity),]
write.table(Data2, file = "tidydataset.txt", row.names = FALSE)

