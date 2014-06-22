## Code Book

The project requires the inclusion of a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md

## Data

The data for this project was sourced from the UCI Machine Learning Repository and downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data set itself is titled: Human Activity Recognition Using Smartphones Data Set and the UCI website describes the data as a "Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors." (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Variables

The following variables were created as part of the run_analysis.R script:
 * url: The URL to download the data set from if it is not present in the working directory
 * archive: The filename of the data set after it is downloaded
 * datadir: The directory that the data will exist in after the archive is unzipped
 * xCombinedDS: A combined data set (using rbind) containing the X_train and X_test data sets
 * subjectCombinedDS: A combined data set (using rbind) containing the y_train and y_test data sets
 * yCombinedDS: A combined data set (using rbind) containing the subject_train and subject_test data sets
 * completeDS: A combined data set (using cbind) containing subjectCombinedDS, yCombinedDS and xCombinedDS
 * cleanDS: A copy of completeDS to work on when creating the tidy data set
 * features: Contains the contents of the file features.txt
 * meanSDFeatures: Contains the features that end in mean() or std() from the features variable
 * activities: Contains the contents of the file activity_labels.txt
 * meltDS: The result of running melt against the cleanDS to prepare for dcast and the generation of the final tidy data set
 * tidyDS: The final tidy data set containing the Subject, Activity Name and average values for each reading
 * tidyFile: The path and filename to write out the tidy data set to

## Transformations


1. Merges the training and test sets to create a single data set. This is combined in two stages:
 1. Combine each of the test/train data set types (X, y, subject) using rbind.
 2. Combine the resultant data sets using cbind resulting in a data set containing 10299 rows and 563 columns.
1. Reads in the features.txt file then using grep extracts the measurements labelled as mean() or std() to create a list of columns that should remain in the tidy data set.
1. Uses the list of features to subset the combined data set so that it only contains the listed features resulting in a data set containing 10299 rows and 68 columns.
1. Reads in the activity_labels.txt file then uses the factor function to apply the names to the appropriate activity IDs in the data set replacing the IDs as follows:
 * 1 -> WALKING
 * 2 -> WALKING_UPSTAIRS
 * 3 -> WALKING_DOWNSTAIRS
 * 4 -> SITTING
 * 5 -> STANDING
 * 6 -> LAYING
1. The first two columns are labelled using static values of "Subject" and "Activity" with the remaining columns labelled by utilising the list created from reading in features.txt.
1. A series of calls to gsub are made to rename the measurement columns to provide more meaningful descriptions than the shortened names provided in features.txt. These names were derived by reading the descriptions provided in the data set by the text file features_info.txt.
1. The script then generates the tidy data set by using the melt and dcast functions to generate averages for each measurement.
1. Finally, the tidy data set is written to disk in the directory "UCI HAR Dataset" as "tidy_dataset.txt".
