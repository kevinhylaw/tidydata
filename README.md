# tidydata
Final Assignment for "Getting and Cleaning Data"

This repo contains a script "run_analysis.R" which gets and cleans the UCI HAR dataset from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

It writes a txt file containing a tidy data set of averages of the measured variables for each activity and each subject.
The main idea of the script is:
1. get the files from the internet, read the files into R
2. extract data from the raw data
3. match the data with their subject and activity
4. select only the mean and standard deviations
5. split data into 6 data frames according to activity
6. use aggregate to calculate the average of each variable for each subject
7. write the data into a txt file

Detailed xplanation of the script is included in the script as comment lines.

There is also a modified codebook in this repo
