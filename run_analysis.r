###### create test set
## read test data
test_data <- read.table("./test/X_test.txt")
## read test labels
test_labels <- read.table("./test/y_test.txt")
## read test subject data
subject_test <- read.table("./test/subject_test.txt")

features <- read.table("features.txt")
##activity_labels <- read.table("activity_label.txt")


tests <- as.data.frame(gsub(1,"walking",test_labels$V1)); names(tests) <- "activity"
tests <- as.data.frame(gsub(2,"walking_upstairs",tests$activity)) ;names(tests) <- "activity"
tests <- as.data.frame(gsub(3,"walking_downstairs",tests$activity)); names(tests) <- "activity"
tests <- as.data.frame(gsub(4,"sitting",tests$activity)) ; names(tests) <- "activity"
tests <- as.data.frame(gsub(5,"standing",tests$activity)) ; names(tests) <- "activity"
tests <- as.data.frame(gsub(6,"laying",tests$activity)) ; names(tests) <- "activity"

##update the column names in test data with the features 
names(test_data) <- features[,2]
## add activity data to test data
test_data <- cbind(tests,test_data)

##read subject data and update the column name of subject dataframe
subject_test <- read.table("./test/subject_test.txt")
names(subject_test) <- "subject"
## add subject data to test data 
test_data <- cbind(subject_test,test_data)



###### create training set
## read training data
train_data <- read.table("./train/X_train.txt")
## read training labels
train_labels <- read.table("./train/y_train.txt")
## read training subject data
subject_train <- read.table("./train/subject_train.txt")

train_temp <- as.data.frame(gsub(1,"walking",train_labels$V1)); names(train_temp) <- "activity"
train_temp <- as.data.frame(gsub(2,"walking_upstairs",train_temp$activity)) ;names(train_temp) <- "activity"
train_temp <- as.data.frame(gsub(3,"walking_downstairs",train_temp$activity)); names(train_temp) <- "activity"
train_temp <- as.data.frame(gsub(4,"sitting",train_temp$activity)) ; names(train_temp) <- "activity"
train_temp <- as.data.frame(gsub(5,"standing",train_temp$activity)) ; names(train_temp) <- "activity"
train_temp <- as.data.frame(gsub(6,"laying",train_temp$activity)) ; names(train_temp) <- "activity"

##update the column names in training data with the features 
names(train_data) <- features[,2]
## add activity data to test data
train_data <- cbind(train_temp,train_data)

##read subject data and update the column name of subject dataframe
subject_train <- read.table("./train/subject_train.txt")
names(subject_train) <- "subject"
## add subject data to training data 
train_data <- cbind(subject_train,train_data)


## merge test and train data into merged_data
merged_data <- rbind(test_data,train_data)

##create another data set that has only the data for mean and std
merged_data_mean_std <- merged_data[,grep("mean|std",names(merged_data),value=FALSE)]
## the above action will only get the mean and std columns and will lose subject and activity columns. Add those back
merged_data_mean_std <- cbind(merged_data$activity,merged_data_mean_std)
merged_data_mean_std <- cbind(merged_data$subject,merged_data_mean_std)

##Step5: melt the merged data set, grouped by Subject and Activity, that will have a variable column listing all the variables and their values
data_melt <- melt(merged_data_mean_std,id=c("subject","activity"))
## use dcast to calculate the mean of all the variables and grouped by Subject and Activity
data_melt1 <- dcast(data_melt,subject + activity ~ variable,mean)
## above action will create a dataframew with 80 columns showing means for each varaibles. Melt the data again to have the 
data_melt2 <- melt(data_melt1,id=c("subject","activity"))
## save the dataset in a file final_dataset.txt
write.table(data_melt2,file="final_dataset.txt",row.names=TRUE)
