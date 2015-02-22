## run_analysis.R

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##   average of each variable for each activity and each subject.

## load test and train subjects data 
subjects1 <- read.table("test\\subject_test.txt", header=FALSE, sep=" ")
subjects2 <- read.table("train\\subject_train.txt", header=FALSE, sep=" ")

## load names of activities
activities_names <- read.table("activity_labels.txt", header=FALSE, sep=" ")

## load test and train activities data
activities1 <- read.table("test\\y_test.txt", header=FALSE, sep=" ")
activities2 <- read.table("train\\y_train.txt", header=FALSE, sep=" ")

## change activities numbers for names
names(activities1) <- c('Activity')
names(activities2) <- c('Activity')

activities1$Activity <- as.character(activities1$Activity)
activities2$Activity <- as.character(activities2$Activity)
activities_names$V2 <- as.character(activities_names$V2)

for (name in activities_names$V1) {
    activities1$Activity[activities1$Activity==as.character(name)] <- activities_names[activities_names$V1==as.character(name),2]
    activities2$Activity[activities2$Activity==as.character(name)] <- activities_names[activities_names$V1==as.character(name),2]
}

## load names of features
features_names <- read.table("features.txt", header=FALSE, sep="")

## load test and train features data
features1 <- read.table("test\\X_test.txt", header=FALSE, sep="")
features2 <- read.table("train\\X_train.txt", header=FALSE, sep="")

## set features names
names(features1) <- features_names$V2
names(features2) <- features_names$V2

## bind all data together into test and train dataframes
test <- cbind(subjects1,activities1)
train <- cbind(subjects2,activities2)
names(test) <- c("subject", "activity")
names(train) <- c("subject", "activity")

## choose all means and sds from features

for (name in features_names$V2) {
    if ((length(grep('mean', name) !=0)) | (length(grep('std', name) !=0))) {
        test <- cbind(test, features1[name])
    }
}


for (name in features_names$V2) {
    if ((length(grep('mean', name) !=0)) | (length(grep('std', name) !=0))) {
        train <- cbind(train, features2[name])
    }
}

## bind test and train dataframes together
all <- rbind(test, train)

## create a new dataframe

tidy <- data.frame()

## for each subject aggregate fields' values
for (subject in c(1:30)){
    
    sdf <- all[all$subject==as.character(subject),]
    new_sdf<- aggregate(sdf, list(activity_type = sdf$activity), mean)
    
    ## now activity is designated as activity_type
    ## since aggregate has set the activity column to NAs, get rid of it
    new_sdf$activity <- NULL
    tidy <- rbind(tidy, new_sdf)
}

# reorder columns so that subject be in the first place
tidy <- tidy[c(2,1,3:length(tidy))]

# restore name for activity
names(tidy)[2] <- "activity"
