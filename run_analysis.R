## An R script to tidy the Human Activity Recognition Using Smartphones Data Set
## from the UCI Machine Learning Repository
##
## Data must exist in the directory: ./UCI HAR Dataset
##
## If the data does not exist in this directory the script will attempt to 
## download the data from the Internet.
##
## The data set is created by taking the steps listed in the course project:
##  1. Merges the training and the test sets to create one data set.
##  2. Extracts only the measurements on the mean and standard deviation for
##     each measurement. 
##  3. Uses descriptive activity names to name the activities in the data set
##  4. Appropriately labels the data set with descriptive variable names. 
##  5. Creates a second, independent tidy data set with the average of each 
##     variable for each activity and each subject

# Set URL and file locations
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
archive <- "getdata-projectfiles-UCI HAR Dataset.zip"
datadir <- "UCI HAR Dataset"

# If the datafile doesn't exist, download the archive and unzip
if(!file.exists(datadir)) {
    print("Attempting to download data file")
    download.file(url = url,
                  destfile = archive,
                  method = "curl",
                  quiet = TRUE)
    print("Unzipping archive")
    unzip(archive)
}

# Merge the training and test data sets to create a single data set
print("Reading in datasets and merging training and test data...")
print("  * Merging X datasets as xCombinedDS...")
xCombinedDS <- rbind(read.table(paste(datadir,
                                      "/",
                                      "train/X_train.txt",
                                      sep = ""
                                      )
                                ),
                     read.table(paste(datadir,
                                      "/",
                                      "test/X_test.txt",
                                      sep = ""
                                      )
                                )
                     )

print("  * Merging subject datasets as subjectCombinedDS...")
subjectCombinedDS <- rbind(read.table(paste(datadir,
                                            "/",
                                            "train/subject_train.txt",
                                            sep = ""
                                            )
                                      ),
                           read.table(paste(datadir,
                                            "/",
                                            "test/subject_test.txt",
                                            sep = ""
                                            )
                                      )
                           )

print("  * Merging Y datasets as yCombinedDS...")
yCombinedDS <- rbind(read.table(paste(datadir,
                                      "/",
                                      "train/y_train.txt",
                                      sep = ""
                                      )
                                ),
                     read.table(paste(datadir,
                                      "/",
                                      "test/y_test.txt",
                                      sep = ""
                                      )
                                )
                     )

print("  * Merge all data sets to create a single data set for analysis...")
# First column is subject
# Second column is the activity label
# Remaining columns are the results
completeDS <- cbind(subjectCombinedDS, yCombinedDS, xCombinedDS)

# Create a variable for the clean data set so that we can modify and store it
cleanDS <- completeDS

# Extract the measurements on the mean and standard deviation only
# First get the names of the columns using features.txt
print("Extracting mean and standard deviation measurements...")
features <- read.table(paste(datadir, "/", "features.txt", sep = ""))
# Several discussions occurred in the forum regarding how to grep to include 
# only the following two variations of mean and standard deviation:
#   * mean(): Mean value
#   * std(): Standard deviation
# 
# These discussions include:
#   * https://class.coursera.org/getdata-004/forum/thread?thread_id=219
#   * https://class.coursera.org/getdata-004/forum/thread?thread_id=311
#
# Most pertinent I think is David M. Hashman's comment in the following thread:
#
#   "The instructions said to extract "only the measurements on the mean and 
#    standard deviation for each measurement." To me, that implies taking the
#    33 feature variables * 2 measurements each = 66 (like others have done).
#    Additional items that have "mean" in their name only apply to a subset of
#    the feature variables, so, right, wrong, or indifferent, I chose to exclude
#    them." (https://class.coursera.org/getdata-004/forum/thread?thread_id=258)
#
# I concur with David's statement above.
#
# Thus it seems the consensus is that we should not include other variations
# including:
#   * meanFreq(): Weighted average of the frequency components to obtain a mean
#                 frequency
#   * gravityMean
#   * tBodyAccMean
#   * tBodyAccJerkMean
#   * tBodyGyroMean
#   * tBodyGyroJerkMean
meanSDFeatures <- features[grep("(mean|std)\\(\\)",
                                features$V2,
                                perl = TRUE
                                ),
                          ]

# Now extract the columns listed in meanSDFeatures
cleanDS <- cleanDS[,c(1, 2, meanSDFeatures$V1)]

# Apply descriptive names to the activities in the data set
print("Applying descriptive labels to the labels column...")
# Use hte provided descriptions to provide descriptive names to the activities
# in the data set by first reading  in the mapping of activity ids to labels
activities <- read.table(paste(datadir, "/", "activity_labels.txt", sep = ""))
# Then mapping the labels to the second column of the clean data set
cleanDS[,2] <- factor(cleanDS[,2],
                      levels = activities$V1,
                      labels = activities$V2
                      )

# Appropriately label the data set with descriptive variable names. 
print("Labelling columns in data set with descriptive variable names...")
colnames(cleanDS) <- c("Subject", "Activity", as.vector(meanSDFeatures$V2))
colnames(cleanDS) <- gsub("BodyBody", "Body", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("fBody", "FFT Body ", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("tBody", "Time Domain Body ", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("tGravity", "Time Domain Gravity ", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("Acc", "Accelerometer", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("Gyro", "Gyroscope", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("Jerk", " Jerk", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("Mag", " Magnitude", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("-mean()", " Mean", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("-std()", " Standard Deviation", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("-X", " for X Direction", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("-Y", " for Y Direction", colnames(cleanDS), fixed=TRUE)
colnames(cleanDS) <- gsub("-Z", " for Z Direction", colnames(cleanDS), fixed=TRUE)

# Create a tidy data set with the average of each variable for each activity 
# and each subject
print("Calculating averages...")

# First melt
meltDS <- melt(cleanDS, id = c("Subject", "Activity"))

# Then dcast to calculate means
tidyDS <- dcast(meltDS, formula = Subject + Activity ~ variable, mean)

# Now write to disk
tidyFile <- paste(datadir, "/", "tidy_dataset.txt", sep = "")
print(paste("Writing data to ", tidyFile, sep = ""))
write.table(tidyDS, file = tidyFile, sep="\t", row.names=FALSE)
