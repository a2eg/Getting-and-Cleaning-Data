#R script run_analysis.R 

#1 Merge the training ('train/X_train.txt': Training set) 
# and the test ('test/X_test.txt': Test set) sets to create one data set
# 'X_train.txt' ln: 7352 col: 8976 (one number is 15 pos. + 1 space) 8976/16=561  
# 'X_test.txt' ln: 2947 col: 8976 (one number is 15 pos. + 1 space) 8976/16=561 

# Read & merge data x(original feature data set)
x<-rbind(read.table("X_test.txt"),read.table("X_train.txt")) 

# Add the feature names
names(x)<-t(read.table("features.txt"))[2,] 

#4. Appropriately label the data set x with descriptive variable names z(temp var for name cleaning) 
z <- gsub("[()]", "", names(x))
names(x) <- gsub("-", "_", z)

#2. Extract only the measurements on mean() and standard deviation std() for each measurement x1(subset of x)
x1<-x[,sort(c(grep("mean",names(x) ),grep("std",names(x) )))]

#3. Use descriptive activity names to name the activities in the data set x1

# Read and merge data y(activity data set)
y<-rbind(read.table("y_test.txt"),read.table("y_train.txt")) 

# Create activity(factor with labels)
activity<-factor(y$V1, levels=1:6, labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")) 


#5. From the data set create a second, independent tidy data set 
#  with the average of each variable for each activity and each subject.

# Read and merge subject data s(subject names)
s<-rbind(read.table("subject_test.txt"),read.table("subject_train.txt")) 

# Create a new factor of combined subject activity combSubjAct which represents 
# the interaction of the given factors(s, y)  
#combSubjAct <- interaction(s$V1, activity, sep="_")
#combSubjAct

#Add the combSubjAct column to data set x1(x2) 
#x2<-cbind(combSubjAct,x1)
x2<-cbind(activity,x1)
x1<-cbind("subj"=s$V1,x2)
#str(x1)

#Get average of each variable for each activity and each subject using sqldf package
library(sqldf)
s1 <- sqldf("select subj, activity, avg(tBodyAcc_mean_X), avg(tBodyAcc_mean_Y), avg(tBodyAcc_mean_Z),
avg(tBodyAcc_std_X), avg(tBodyAcc_std_Y), avg(tBodyAcc_std_Z), 
avg(tGravityAcc_mean_X), avg(tGravityAcc_mean_Y), avg(tGravityAcc_mean_Z),
avg(tGravityAcc_std_X), avg(tGravityAcc_std_Y), avg(tGravityAcc_std_Z), 
avg(tBodyAccJerk_mean_X), avg(tBodyAccJerk_mean_Y), avg(tBodyAccJerk_mean_Z),
avg(tBodyAccJerk_std_X), avg(tBodyAccJerk_std_Y), avg(tBodyAccJerk_std_Z), 
avg(tBodyGyro_mean_X), avg(tBodyGyro_mean_Y), avg(tBodyGyro_mean_Z),
avg(tBodyGyro_std_X), avg(tBodyGyro_std_Y), avg(tBodyGyro_std_Z), 
avg(tBodyGyroJerk_mean_X), avg(tBodyGyroJerk_mean_Y), avg(tBodyGyroJerk_mean_Z), 
avg(tBodyGyroJerk_std_X), avg(tBodyGyroJerk_std_Y), avg(tBodyGyroJerk_std_Z), 
avg(tBodyAccMag_mean), avg(tBodyAccMag_std), avg(tGravityAccMag_mean), 
avg(tGravityAccMag_std), avg(tBodyAccJerkMag_mean), avg(tBodyAccJerkMag_std), 
avg(tBodyGyroMag_mean), avg(tBodyGyroMag_std), avg(tBodyGyroJerkMag_mean), avg(tBodyGyroJerkMag_std), 
avg(fBodyAcc_mean_X), avg(fBodyAcc_mean_Y), avg(fBodyAcc_mean_Z), 
avg(fBodyAcc_std_X), avg(fBodyAcc_std_Y), avg(fBodyAcc_std_Z), 
avg(fBodyAcc_meanFreq_X), avg(fBodyAcc_meanFreq_Y), avg(fBodyAcc_meanFreq_Z), 
avg(fBodyAccJerk_mean_X), avg(fBodyAccJerk_mean_Y), avg(fBodyAccJerk_mean_Z), 
avg(fBodyAccJerk_std_X), avg(fBodyAccJerk_std_Y), avg(fBodyAccJerk_std_Z), 
avg(fBodyAccJerk_meanFreq_X), avg(fBodyAccJerk_meanFreq_Y), avg(fBodyAccJerk_meanFreq_Z), 
avg(fBodyGyro_mean_X), avg(fBodyGyro_mean_Y), avg(fBodyGyro_mean_Z), 
avg(fBodyGyro_std_X), avg(fBodyGyro_std_Y), avg(fBodyGyro_std_Z), 
avg(fBodyGyro_meanFreq_X), avg(fBodyGyro_meanFreq_Y), avg(fBodyGyro_meanFreq_Z), 
avg(fBodyAccMag_mean), avg(fBodyAccMag_std), avg(fBodyAccMag_meanFreq), avg(fBodyBodyAccJerkMag_mean), avg(fBodyBodyAccJerkMag_std), 
avg(fBodyBodyAccJerkMag_meanFreq), avg(fBodyBodyGyroMag_mean), avg(fBodyBodyGyroMag_std), avg(fBodyBodyGyroMag_meanFreq), 
avg(fBodyBodyGyroJerkMag_mean), avg(fBodyBodyGyroJerkMag_std), avg(fBodyBodyGyroJerkMag_meanFreq)
            from x1 group by subj, activity")

#Revert to original column names (x1)
colnames(s1) <- colnames(x1)

#Output tidy data set to txt file (tidy.txt)
write.table(s1, file="./tidy.txt",row.name=FALSE)











