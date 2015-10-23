# Getting-And-Cleaning-Data. (Note- I have used the internet as a resource for getting help on how to do this program)
The first step is to set the working directory.                                                                                 
Then files are read into R, the files are features.txt, activity_labels.txt, subject_train.txt, x_train.txt and y_train.txt
Column names are assigned to each data frame, namely activity type table, subject training table, x-train table and y-train table                                                                                                                           The training tables are bound into one data frame using cbind

Similarly test tables are also read and columns named for test related tables                                                   The test tables are bound into one data frame using cbind                                                                       

Since we need to combine the test and training data, they are combined using rbind function and placed in a desiredData                                    
Desired column names contain the words mean and stdev therefore a vector of desired column names is created using the grep function. The subsetting is done via a logical vector called desiredData and result placed in desiredData                                                       

The merge function is used to merge the Activity type table and the Desired Data                                                 
Column names are cleaned by looking for the raw column names and giving clean cloumn names like Stdev instead of std etc              
The desiredData is summarised via the aggregate function to include only mean and standard deivation for each activity id and subject id and is placed in placed in tidyData                                                                                  
The data is written to tidyData via the write.table function






