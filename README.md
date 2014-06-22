## Getting and Cleaning Data Course Project

An R script to tidy the Human Activity Recognition Using Smartphones Data Set from the UCI Machine Learning Repository

### Running the script

The Human Activity Recognition Using Smartphones Data Set from the UCI Machine Learning Repository must exist in the following directory:
	./UCI HAR Dataset

If the data does not exist in this directory the script will attempt to download the data from the Internet.

Execute the script using the following commands:
```
 > r
 > source("./run_analysis.R")
```

### Aim of the script in creating a tidy data set

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names. 
1. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

### Actions taken by the script

1. Check to see if data exists if not then download and unzip the archive from the Internet
1. Merge the training and test data sets to create a single data set by irst rbind the test and train sets for each dataset then cbind the 3 data sets (subject, y, x)
 1. First column is subject
 1. Second column is the activity label
 1. Remaining columns are the results
1. Create a variable for the clean data set so that we can modify and store it
1. Extract the measurements on the mean and standard deviation only
1. Extracts the feature names from ./UCI HAR Dataset/features.txt and creates a list of those values that match the strings "mean()" and "std()" and stores them in a new list meanSDFeatures
1. Takes a subset of cleanDS that only includes the first two columns and the list of columns in meanSDFeatures
1. Applies descriptive names to the activities by using the provided descriptions in ./UCI HAR Dataset/activity_names.txt
1. Appropriately labels the data set with descriptive variable names developed by reading ./UCI HAR Dataset/features_info.txt
1. Uses melt and dcast to generate a tidy dataset containing the average of all the measurements
1. Writes the data to disk as a text file using write.table to write the following file: ./UCI HAR Dataset/tidy_dataset.txt

### Justification of only using the strings "mean()" and "std()" from ./UCI HAR Dataset/features.txt

Several discussions occurred in the forum regarding how to grep to include only the following two variations of mean and standard deviation:
* mean(): Mean value
* std(): Standard deviation

These discussions include:
* https://class.coursera.org/getdata-004/forum/thread?thread_id=219
* https://class.coursera.org/getdata-004/forum/thread?thread_id=311

Most pertinent I think is David M. Hashman's comment in the following thread:

  "The instructions said to extract "only the measurements on the mean and 
   standard deviation for each measurement." To me, that implies taking the
   33 feature variables * 2 measurements each = 66 (like others have done).
   Additional items that have "mean" in their name only apply to a subset of
   the feature variables, so, right, wrong, or indifferent, I chose to exclude
   them." (https://class.coursera.org/getdata-004/forum/thread?thread_id=258)

I concur with David's statement above.

Thus it seems the consensus is that we should not include other variations including:
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean
