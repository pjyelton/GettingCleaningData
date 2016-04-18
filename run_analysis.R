# Check to see if data has been unzipped

if (!file.exists('UCI HAR Dataset')) {
  print('Opening zip file')
  unzip('getdata-projectfiles-UCI HAR Dataset.zip')
}

# Read feature data and give meaningful column names
dataFeatures <- read.table('UCI HAR Dataset/features.txt', header=FALSE)
names(dataFeatures) <- c('feature_id', 'feature_name')

# Only care about mean and std info
# Clean up column names
dataFeatures <- subset(dataFeatures, grepl('-(mean|std)\\(\\)-(X|Y|Z)', feature_name))
dataFeatures$feature_name <- gsub('\\(\\)', '', dataFeatures$feature_name)


# Read activities data and give meaningful column names
dataActivities <- read.table('UCI HAR Dataset/activity_labels.txt')
names(dataActivities) <- c('activity_id', 'activity_name')


# Get the train and test data
train <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
train <- train[, dataFeatures$feature_id]
test <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
test <- test[, dataFeatures$feature_id]
names(train) <- dataFeatures$feature_name
names(test) <- dataFeatures$feature_name

# Get the subjects
subjectsTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
subjectsTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)
names(subjectsTrain) <- c('subject_id')
names(subjectsTest) <- c('subject_id')

# Get the activities
activitiesTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)
activitiesTest <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)
names(activitiesTrain) <- c('activity_id')
names(activitiesTest) <- c('activity_id')

# Combine into one 
trainingData <- cbind(subjectsTrain, activitiesTrain, train)
testData <- cbind(subjectsTest, activitiesTest, test)


# Merge datasets
combinedData <- rbind(trainingData, testData)
combinedData <- merge(dataActivities, combinedData, by.x=c('activity_id'), by.y=c('activity_id'))


#calculate summaries
summaryData <- aggregate(combinedData[, 4:ncol(combinedData)],by=list(subject=combinedData$subject_id,activity=combinedData$activity_name
  ),  mean,  length.warning=FALSE)

names(summaryData)[3:ncol(summaryData)] <- paste0(names(summaryData)[3:ncol(summaryData)], '-mean')

# Save the summaries to a file
write.table(summaryData, 'tidy-data.txt', row.names=FALSE)



