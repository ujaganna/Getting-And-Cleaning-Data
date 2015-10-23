#########################################################################################################

## Coursera Getting and Cleaning Data Course Project

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################


# First, Clean up workspace
rm(list=ls())

# 1. Merge the training and the test sets to create one data set.

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('/Users/Adarsh/Desktop/coursera/gcd/project');

# Read in the data from files for Training data
features      = read.table('./features.txt',header=FALSE); #imports features.txt
act_Type 	  = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
sub_Train 	  = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
x_Train       = read.table('./train/X_train.txt',header=FALSE); #imports x_train.txt
y_Train       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt

# Assign column names to the data imported above, Activity type has 2 cols, Subject train has one col, Xtrain maps to features
# and y_Train has a single col
colnames(act_Type) 	 = c('activityId','act_Type');
colnames(sub_Train) 	 = "subjectId";
colnames(x_Train)        = features[,2]; 
colnames(y_Train)        = "activityId";

# The Training data merge is done by merging y_Train, sub_Train, and XTrain
trainingData = cbind(y_Train,sub_Train,x_Train);

# Next, read in the test data
sub_Test = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
x_Test       = read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
y_Test       = read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

# Assign column names to the test data imported above in a similar manner to training data
colnames(sub_Test) 	= "subjectId";
colnames(x_Test)       	= features[,2]; 
colnames(y_Test)      	= "activityId";


# Create the final test set by merging the x_Test, y_Test and sub_Test data
testData = cbind(y_Test,sub_Test,x_Test);


# Combine training and test data to create a final data set
desiredData = rbind(trainingData,testData);

# Create a vector for the column names from the desiredData, which will be used
# to select the desired mean() & stddev() columns
columnNames  = colnames(desiredData); 

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

# Create a logical Vector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
desiredNames = (grepl("activity..",columnNames) | grepl("subject..",columnNames) | grepl("-mean..",columnNames) & !grepl("-meanFreq..",columnNames) & !grepl("mean..-",columnNames) | grepl("-std..",columnNames) & !grepl("-std()..-",columnNames));

# Subset desiredData table based on the logicalVector to keep only desired columns
desiredData = desiredData[desiredNames==TRUE];

# 3. Use descriptive activity names to name the activities in the data set

# Merge the desiredData set with the acitivityType table to include descriptive activity names
desiredData = merge(desiredData,act_Type,by='activityId',all.x=TRUE);

# Updating the columnNames vector to include the new column names after merge
columnNames  = colnames(desiredData); 

# 4. Give the data set descriptive activity names. 

# Proper variable names
for (i in 1:length(columnNames)) 
{
  columnNames[i] = gsub("\\()","",columnNames[i])
  columnNames[i] = gsub("-std$","StdDev",columnNames[i])
  columnNames[i] = gsub("-mean","Mean",columnNames[i])
  columnNames[i] = gsub("^(t)","time",columnNames[i])
  columnNames[i] = gsub("^(f)","freq",columnNames[i])
  columnNames[i] = gsub("([Gg]ravity)","Gravity",columnNames[i])
  columnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columnNames[i])
  columnNames[i] = gsub("[Gg]yro","Gyro",columnNames[i])
  columnNames[i] = gsub("AccMag","AccMagnitude",columnNames[i])
  columnNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columnNames[i])
  columnNames[i] = gsub("JerkMag","JerkMagnitude",columnNames[i])
  columnNames[i] = gsub("GyroMag","GyroMagnitude",columnNames[i])
};

# Assigning new descriptive column names to the desiredData set
colnames(desiredData) = columnNames;

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Create a new table, desiredDataNoActivityType without the act_Type column
desiredDataNoActivityType  = desiredData[,names(desiredData) != 'act_Type'];

# Summarizing the desiredDataNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData    = aggregate(desiredDataNoActivityType[,names(desiredDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=desiredDataNoActivityType$activityId,subjectId = desiredDataNoActivityType$subjectId),mean);

# Merging the tidyData with act_Type to include descriptive acitvity names
tidyData    = merge(tidyData,act_Type,by='activityId',all.x=TRUE);

# Export the tidyData set 
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t');