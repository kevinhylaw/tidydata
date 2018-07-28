# download files
# url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# dest <- "~/Year 1/R/Getting and Cleaning Data"
# download.file(url, dest)

# read files
activity_labels <- read.delim("~/Year 1/R/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt", header = FALSE)
features <- read.delim("~/Year 1/R/Getting and Cleaning Data/UCI HAR Dataset/features.txt", header = FALSE)

subject_test <- read.delim("~/Year 1/R/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x_test <- read.delim("~/Year 1/R/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt", header = FALSE, stringsAsFactors = FALSE)
y_test <- read.delim("~/Year 1/R/Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt", header = FALSE)

subject_train <- read.delim("~/Year 1/R/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_train <- read.delim("~/Year 1/R/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt", header = FALSE, stringsAsFactors = FALSE)
y_train <- read.delim("~/Year 1/R/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt", header = FALSE)

# load packages
library(stringr)
library(tidyr)

# extract variable (feature) names
colNames <- as.character(features$V1)

# initialise empty matrix which will contain data
matrix <- matrix(data = NA, nrow = 0, ncol = 561)

# move data into matrix
for(i in 1:nrow(x_test)){
    list <- strsplit(x_test[i,1], " ")
    vec <- sapply(list, as.numeric)
    data <- t(vec[!is.na(vec)])
    matrix <- rbind(matrix, data)
}

# name the variables
colnames(matrix) <- colNames

# extract activity names
activity_list <- sapply(as.character(activity_labels$V1), function(x) {strsplit(x, " ")})
activity <- unname(sapply(activity_list, function(x) {x[2]}))

# name the activities
y_test$V1 <- factor(y_test$V1, levels = 1:6, labels = activity)
colnames(y_test) <- "Activity"

colnames(subject_test) <- "Subject"

# combine subject, activity name and data
test_data <- cbind(subject_test, y_test, matrix)

#repeat for train data
matrix <- matrix(data = NA, nrow = 0, ncol = 561)

for(i in 1:nrow(x_train)){
    list <- strsplit(x_train[i,1], " ")
    vec <- sapply(list, as.numeric)
    data <- t(vec[!is.na(vec)])
    matrix <- rbind(matrix, data)
}

colnames(matrix) <- colNames

y_train$V1 <- factor(y_train$V1, levels = 1:6, labels = activity)
colnames(y_train) <- "Activity"

colnames(subject_train) <- "Subject"

train_data <- cbind(subject_train, y_train, matrix)

# combine test and train data
all_data <- rbind(test_data, train_data)

# choose mean and standard deviation data
mean_sd <- all_data[, sort(c(1, 2, grep("mean(", colnames(all_data), fixed = TRUE), grep("std(", colnames(all_data), fixed = TRUE)))]

# clean up variable names
colnames(mean_sd) <- str_trim(gsub("\\(|\\)", "", gsub("[0-9]","", colnames(mean_sd))))

# nest data by activity
nestcopy <- nest(mean_sd, -2)

# initialise vectors
average <- list()
labels <- character()

# calculate means for different activities
for(i in 1:length(nestcopy$data)){
    i_mean <- aggregate(nestcopy$data[[i]][, -1], list(nestcopy$data[[i]]$Subject), mean)
    average[[i]] <- i_mean
    labels <- c(labels, as.character(nestcopy$Activity[i]))
}

# name data frames
names(average) <- labels

# write data into a txt file
write.table(average, "~/Year 1/R/Getting and Cleaning Data/tidy.txt", row.names = FALSE)