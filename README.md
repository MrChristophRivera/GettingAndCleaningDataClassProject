# GettingAndCleaningDataClassProject
This repo contains code for the Getting and Cleaning Data class project on Coursera.

It contains a single R script named run_analysis.R.
This R script takes the cellphone data from the UCI Har Dataset and performs several operations. 
To function, run_analysis.R must be in the same paerent directory as the UCI Har Dataset directory. 

1) It merges the training and test sets to create one data set. 
It does this by first importing the test and training data using the read.table function into a merged data.frame named X using the rbind function.
Then, it imports the Activity information from both the training and test data sets using the read.table function in a merged data.frame named Y. 
It does the same for the Subject labels by importing the Subject information into data.frame named Subject. 
Finally, it merges the Subject, X and Y dataframes into a combined data.frame named DataSet. 

2) It extracts only the measurements on the mean and standard Deviation for each measurement. 
To do this, it first imports the features.txt file into a data.frame obtain information on the type of information contained in the columns of the DataSet data.frame. 
The which fucnction in combination with the  str_detect funtion from Hadley Wickham is used to obtain the indexes for all the feature names that contain either Mean/mean or sd in their name.
This index (denoted as keep) is used to subset the colums of the DataSet data.frame by keeping only those columns that correspond to mean or standard deviation measurements. 

3) It uses descriptive activity names to name the activities in the data set.
To do this, it first imports the activity_labels.txt as a data frame and uses the levels function to map the factors in the activies colunm of the DataSet df to those labels. 

4) Appropriately labels the data set with descriptive variable names. 
To do this, it name the data with descriptive variable names by using the names 
from the features file. (after they have been properly subset as above.

5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
To do this, it first computes a compound factor using the interaction function. Then it uses the aggregate function (a type of apply function) to compute the average of each varibale for each activity and each subject. 
Then it cleans up the tidy data set and saves it as a tab delimted file in the parent directory. 

Good luck!
