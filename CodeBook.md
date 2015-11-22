#Code Book

#R Script

The script run_analysis.R performs the following data manipulation steps:

    1. merges the training and the test sets and creates one data set.
    2. extracts the each measurement of the mean and standard deviation. 
    3. uses descriptive activity names to name the activities in the data set.  
    4. labels the data set with descriptive variable names.
    5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.

At the beginning the similar test and train data are merged using rbind(). 

    x<-rbind(read.table("X_test.txt"),read.table("X_train.txt")) 
Those files refer to the same features and have the same columns.

Only the columns with the mean and standard deviation measures are selected from the original data set. 

    x1<-x[,sort(c(grep("mean",names(x) ),grep("std",names(x) )))]

Then the names from features.txt are extracted for correction.

    names(x)<-t(read.table("features.txt"))[2,] 
    z <- gsub("[()]", "", names(x))
    names(x) <- gsub("-", "_", z)

The activity data is addressed with values 1:6. The activity names are taken from activity_labels.txt 
and they are substituted in the data set.

    y<-rbind(read.table("y_test.txt"),read.table("y_train.txt")) 
    activity<-factor(y$V1, levels=1:6, 
    labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")) 

A new dataset with the average measures for each subject and activity type consist of 180 rows
(30 subjects * 6 activities). 

    x2<-cbind(activity,x1)
    x1<-cbind("subj"=s$V1,x2)

The averages of each activity for each subject were received using sqldf package

    library(sqldf)
    s1 <- sqldf("select subj, activity, avg(tBodyAcc_mean_X),
                 ................................  
                 from x1 group by subj, activity")
             
On the new data set the column names are corrected.

    colnames(s1) <- colnames(x1)

Finally, the output file tidy.txt uploaded to this repository.

    write.table(s1, file="tidy.txt",row.name=FALSE)

#Variables
Variables below contain the data from the downloaded files.
    
    x - feature data set
    z - descriptive variable names
    x1 - only the measurements on mean() and standard deviation std(), subset of x
    y - activity data set
    activity - type of activity (factor)
    s - subject names

#Output 

    s1 - contains the relevant averages of each variable for each activity and each subject.

#Activities

    WALKING (value 1): subject was walking during the test
    WALKING_UPSTAIRS (value 2): subject was walking up a staircase during the test
    WALKING_DOWNSTAIRS (value 3): subject was walking down a staircase during the test
    SITTING (value 4): subject was sitting during the test
    STANDING (value 5): subject was standing during the test
    LAYING (value 6): subject was laying down during the test

#Resulting data fields

    subj, activity, 
    tBodyAcc_mean_X, tBodyAcc_mean_Y, tBodyAcc_mean_Z,
    tBodyAcc_std_X, tBodyAcc_std_Y, tBodyAcc_std_Z, 
    tGravityAcc_mean_X, tGravityAcc_mean_Y, tGravityAcc_mean_Z,
    tGravityAcc_std_X, tGravityAcc_std_Y, tGravityAcc_std_Z, 
    tBodyAccJerk_mean_X, tBodyAccJerk_mean_Y, tBodyAccJerk_mean_Z,
    tBodyAccJerk_std_X, tBodyAccJerk_std_Y, tBodyAccJerk_std_Z, 
    tBodyGyro_mean_X, tBodyGyro_mean_Y, tBodyGyro_mean_Z,
    tBodyGyro_std_X, tBodyGyro_std_Y, tBodyGyro_std_Z, 
    tBodyGyroJerk_mean_X, tBodyGyroJerk_mean_Y, tBodyGyroJerk_mean_Z, 
    tBodyGyroJerk_std_X, tBodyGyroJerk_std_Y, tBodyGyroJerk_std_Z, 
    tBodyAccMag_mean, tBodyAccMag_std, tGravityAccMag_mean, 
    tGravityAccMag_std, tBodyAccJerkMag_mean, tBodyAccJerkMag_std, 
    tBodyGyroMag_mean, tBodyGyroMag_std, tBodyGyroJerkMag_mean, tBodyGyroJerkMag_std, 
    fBodyAcc_mean_X, fBodyAcc_mean_Y, fBodyAcc_mean_Z, 
    fBodyAcc_std_X, fBodyAcc_std_Y, fBodyAcc_std_Z, 
    fBodyAcc_meanFreq_X, fBodyAcc_meanFreq_Y, fBodyAcc_meanFreq_Z, 
    fBodyAccJerk_mean_X, fBodyAccJerk_mean_Y, fBodyAccJerk_mean_Z, 
    fBodyAccJerk_std_X, fBodyAccJerk_std_Y, fBodyAccJerk_std_Z, 
    fBodyAccJerk_meanFreq_X, fBodyAccJerk_meanFreq_Y, fBodyAccJerk_meanFreq_Z, 
    fBodyGyro_mean_X, fBodyGyro_mean_Y, fBodyGyro_mean_Z, 
    fBodyGyro_std_X, fBodyGyro_std_Y, fBodyGyro_std_Z, 
    fBodyGyro_meanFreq_X, fBodyGyro_meanFreq_Y, fBodyGyro_meanFreq_Z, 
    fBodyAccMag_mean, fBodyAccMag_std, fBodyAccMag_meanFreq, fBodyBodyAccJerkMag_mean, fBodyBodyAccJerkMag_std, 
    fBodyBodyAccJerkMag_meanFreq, fBodyBodyGyroMag_mean, fBodyBodyGyroMag_std, fBodyBodyGyroMag_meanFreq, 
    fBodyBodyGyroJerkMag_mean, fBodyBodyGyroJerkMag_std, fBodyBodyGyroJerkMag_meanFreq
