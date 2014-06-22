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

