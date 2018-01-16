library(data.table)
library(reshape2)
# Download data set
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "./data/dataset.zip")
unzip("./data/dataset.zip", exdir = "./data")
# Data in main dir
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
# Data in train folder
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
# Data in test folder
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

# Merge data into one data set
test <- cbind(subject_test, y_test, x_test)
train <- cbind(subject_train, y_train, x_train)
combined <- rbind(test, train)
View(combined)

# Extract measurements on mean and standard deviation for each measurement
# Acturally, there exist a series of featuers called "meanFreq".
# If these measurements are not required, just change the "mean" 
# in next line to "mean\\b".
feature_index_series <- c(grep("mean|std",features))
index_series <- c(1, 2, feature_index_series + 2)
extracted <- combined[,index_series]
View(extracted)

# Rename activities
activity_series <- activity_labels[extracted[,2]]
extracted[,2] <- activity_series 
View(extracted)

# Mark variables with descriptive names
features_names <- as.character(features[feature_index_series])
colnames(extracted) <- c("subject", "activity", features_names)
View(extracted)

# Create a second, independent tidy data set with the average
# of each variable for each activity and each subject
melted <- melt(extracted, id.vars = c("subject", "activity"))
tidy_data <- dcast(melted, subject+activity~variable, mean)
View(tidy_data)

# Write data set to file
write.table(tidy_data, file = "./data/smart_tidy_data.txt", row.names = FALSE)
View(read.table("./data/smart_tidy_data.txt"))