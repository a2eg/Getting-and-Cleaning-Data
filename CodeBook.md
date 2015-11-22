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

This code book summarizes the resulting data fields in tidy.txt.

#Variables
Variables below contain the data from the downloaded files.
    
    x - original feature data set.
    z - descriptive variable names.
    x1 - only the measurements on mean() and standard deviation std(). Subset of x.
    y - activity data set.
    activity - type of activity (factor).
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
