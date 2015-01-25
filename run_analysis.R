#This script does the following.
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for 
#each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.


#First clear the workspace and load are required packages.
rm(list =ls())
#get the needed libraries
library(stringr)

################################################################################
#Merge the training and test sets to create one data set. 
################################################################################

#First get the parent path to the data (This assumes that the UCI Har Dataset
#directory is a sub directory of the current working directory)
path <- getwd()
path <- file.path(path, 'UCI Har Dataset')

##### Second, Get the data for the Features, the X information for both the 
#test and training data set. 

#Import the test data set
X <-read.table( 
        file.path(path, 'test','X_test.txt'), 
        header = FALSE, colClasses = 'numeric')

#Import the training data set and bind it to the X data.frame using rbind.
X <-rbind(X,
        read.table(
                file.path(path,'train','X_train.txt'),
                header = FALSE, colClasses = 'numeric')
        )


##Third Import the Y information for both the X and Y (This is the Activity)
#Import the test Y data.
Y <-read.table( 
        file.path(path, 'test','Y_test.txt'), 
        header = FALSE, colClasses = 'factor',
        col.names = 'Activity')
#Import the training activity
Y <-rbind(Y,
          read.table(
                  file.path(path,'train','Y_train.txt'),
                  header = FALSE, colClasses = 'factor',
                  col.names = 'Activity')
)

#Fourth, import the individual Subject information as a factor. 
#First load in the ids for the test
Subject <-read.table( 
        file.path(path, 'test','subject_test.txt'), 
        header = FALSE, colClasses = 'factor')
#second import the ids for the test information and bind it to the Subject data.frame.
Subject <-rbind(Subject,
           read.table(
                   file.path(path,'train','subject_train.txt'),
                   header = FALSE, colClasses = 'factor')
)

## Finally Merge the Data sets to create one Data Set using the cbind function
DataSet <- cbind(Subject, X, Y)

################################################################################
# Extracts only the measurements on the mean and standard deviation for 
#each measurement. 
################################################################################

#To do this first import the second column of the features data to 
#identify the columns that represent the mean and standard deviation for the 
#parameters
features<- read.table(file.path(path, 'features.txt'), 
                      sep =' ', 
                      colClasses = c('numeric', 'character'))[,2]

### Use logical indexing  and the str_detect function to identify the features 
#that represent either the mean or standard deviation and store the index as the 
#variable keep. 
keep <-which(str_detect(features,'mean') | 
                     str_detect(features,'std') | 
                     str_detect(features,'Mean') )
#use the keep index to partition the data
DataSet <- DataSet[,c(1,keep+1, 563)]   #partition the data set 

################################################################################
#Appropriately labels the data set with descriptive variable names. 
################################################################################
#Name the data with descriptive variable names by using the names 
#from the features file
names(DataSet)<-c('Subject', features[keep], 'Activity')

################################################################################
#Uses descriptive activity names to name the activities in the data set
################################################################################

###First 
#Get the names of the activties from the activity labels by importing in the 
#activity_label information

activity_Label<-read.table(
        file.path(path, 'activity_labels.txt'),
        header = FALSE, colClasses = 'character')

#Use the levels function to map the Labels of the Activities factor vector in 
levels(DataSet$Activity)<- activity_Label[[2]] 

################################################################################
#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
################################################################################

#First use the interaction function to compute a compound factor (which represents
#The unique)
CompoundFactor <- interaction(DataSet$Subject, DataSet$Activity)

#Second: Use the aggregate function to calculate the mean of each columns in the 
#DataSet split on the subject id and activity

tidy<- aggregate(DataSet[2:87], by=list(CompoundFactor), FUN = mean)

#Third use str_split on the first column of the tidy data set to obtain 
#a data.frame with the subject information located in the first row
#and the activity information located in the second row 
temp<- data.frame(sapply(as.character(tidy[[1]]),str_split, '[.]', simplify = TRUE))

#Fourth, attach the Subject and Activity to the tidy data frame. 
tidy$Subject <- as.numeric(t(temp[1,]))   #this needs to be transposed first. 
tidy$Activity <- as.factor(t(temp[2,] ))  #this needs to be transposed first. 

#Fifth: tidy up the tidy data set by removing uneeded columns (eg column1 ) and 
#properly ordering the data by subject and activity

#order the columns: Subject, Activity, Features..../ 
tidy<- tidy[,c(88,89,2:87)]

#Reorder the rows: by subject and then activity
tidy<- tidy[order(tidy$Subject,tidy$Activity),]


#save the data using write table
write.table(tidy, file = 'tidy.txt', sep = '\t', row.names = FALSE)
