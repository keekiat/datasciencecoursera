
if(!file.exists("./rawdata")){
  dir.create("./rawdata")
}

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              method="auto",destfile="rawdata/data.zip")
unzip("rawdata/data.zip",exdir="rawdata")


features<-read.table("rawdata/UCI HAR Dataset/features.txt")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanSD<-grep("mean()|std()", features$V2)

#read training data
trainX<-read.table("rawdata//UCI HAR Dataset/train/X_train.txt", col.names = features$V2)
trainY<-read.table("rawdata//UCI HAR Dataset/train/y_train.txt", col.names = "activity")
trainSubject<-read.table("rawdata//UCI HAR Dataset/train/subject_train.txt",col.names = "subjectLabel")
trainXReq<-trainX[,meanSD]
training<-cbind(trainSubject,trainY,trainXReq)

#read test data
testX<-read.table("rawdata//UCI HAR Dataset/test/X_test.txt", col.names = features$V2)
testY<-read.table("rawdata//UCI HAR Dataset/test/y_test.txt", col.names = "activity")
testSubject<-read.table("rawdata//UCI HAR Dataset/test/subject_test.txt",col.names = "subjectLabel")
testXReq<-testX[,meanSD]
testing<-cbind(testSubject,testY,testXReq)

# 1. Merges the training and the test sets to create one data set.
final <- rbind(testing, training)


# 3. Uses descriptive activity names to name the activities in the data set
labels<-read.table("rawdata/UCI HAR Dataset/activity_labels.txt")
for (rowcount in 1:nrow(labels)) {
  final[final$activity == as.numeric(labels[rowcount, 1]), 2] <- as.character(labels[rowcount, 2])
}

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
output<-aggregate(final[,3:ncol(final)], by=list(activity= final[,2], subjectLabel=final[,1]), mean)

write.table(test,row.name=FALSE,file="rawdata/output.txt")
