#Download the data and unzip it
if (!file.exists("data")) {
    dir.create("data")
}
if (!file.exists("data/raw")) {
  dir.create("data/raw")
}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  "data/raw/human_activity_smartphones.zip", 
  method="curl")
unzip("data/raw/human_activity_smartphones.zip",
      exdir="data/raw")

#Notes on where to get information from in the raw files
#1. features.txt contains the column names of the test and train X_test.txt files.
#   Only column names with mean() and std() in it should be extracted.
#2. The subject IDs of each line in the X_test.txt files is on the corresponding
#   line number in subject_test.txt and subject_train.txt
#3. The activity of each line in the X_test.txt files is on the corresponding 
#   line number in y_test.txt and y_train.txt. These files contain numbers - their
#   corresponding text descriptions are in activity_labels.txt

#Load packages that will be used in the processing steps
library('stringr')

#Get the column numbers and names that contain means
#Also change the column names to be more descriptive
column.details <- read.delim("data/raw/UCI HAR Dataset/features.txt", sep=" ", header=F)
names(column.details) <- c("Nr", "Name")
mean.column.nrs <- column.details$Nr[grep("mean\\(\\)", column.details$Name)]
column.names <- column.details$Name[grep("mean\\(\\)", column.details$Name)] 
column.names <- str_replace(column.names,'Acc', 'Acceleration')
column.names <- str_replace(column.names,'Gyro', 'Gyroscope')
column.names <- str_replace(column.names,'Mag', 'Magnitude')
column.names <- str_replace(column.names,'BodyBody', 'Body')
column.names <- str_replace(column.names,'-mean\\(\\)', '')
is.time.column <- substring(column.names,1,1) == "t"
column.names[is.time.column] <- paste("time", 
                                           substr(column.names[is.time.column], 
                                                  2,
                                                  nchar(column.names[is.time.column])),
                                           sep="")
is.fourier.column <- substring(column.names,1,1) == "f"
column.names[is.fourier.column] <- paste("fourier", 
                                           substr(column.names[is.fourier.column], 
                                                  2,
                                                  nchar(column.names[is.fourier.column])),
                                           sep="")

#Get the column numbers and names that contain standard deviations
sd.column.nrs <- column.details$Nr[grep("std()", column.details$Name)]

#In the below commented out section, the standard deviation column names were 
#changed in the same way as the mean column names, and a check revealed that the
#mean and std column names are indeed the same
# sd.column.names <- column.details$Name[grep("std\\(\\)", column.details$Name)] 
# sd.column.names <- str_replace(sd.column.names,'Acc', 'Acceleration')
# sd.column.names <- str_replace(sd.column.names,'Gyro', 'Gyroscope')
# sd.column.names <- str_replace(sd.column.names,'Mag', 'Magnitude')
# sd.column.names <- str_replace(sd.column.names,'BodyBody', 'Body')
# sd.column.names <- str_replace(sd.column.names,'-std\\(\\)', '')
# is.time.column <- substring(sd.column.names,1,1) == "t"
# sd.column.names[is.time.column] <- paste("time", 
#                                          substr(sd.column.names[is.time.column], 
#                                                 2,
#                                                 nchar(sd.column.names[is.time.column])),
#                                          sep="")
# is.fourier.column <- substring(sd.column.names,1,1) == "f"
# sd.column.names[is.fourier.column] <- paste("fourier", 
#                                             substr(sd.column.names[is.fourier.column], 
#                                                    2,
#                                                    nchar(sd.column.names[is.fourier.column])),
#                                             sep="")
# length(mean.column.nrs)
# length(sd.column.nrs)
# length(column.names)
# length(sd.column.names)
# sum(sd.column.names == column.names)

#Read the training data set and get the means and standard deviations
train.data <- read.table("data/raw/UCI HAR Dataset/train/X_train.txt", header=F)
train.means <- train.data[,mean.column.nrs]
train.sds <- train.data[,sd.column.nrs]

#Read the test data set and get the means and standard deviations
test.data <- read.table("data/raw/UCI HAR Dataset/test/X_test.txt", header=F)
test.means <- test.data[,mean.column.nrs]
test.sds <- test.data[,sd.column.nrs]

#Give descriptive names to the columns
names(train.means) <- column.names
names(train.sds) <- column.names
names(test.means) <- column.names
names(test.sds) <- column.names

#Add the subject IDs
train.subject.ids <- read.table("data/raw/UCI HAR Dataset/train/subject_train.txt", head=F)
train.means$SubjectID <- train.subject.ids$V1 
train.sds$SubjectID <- train.subject.ids$V1
test.subject.ids <- read.table("data/raw/UCI HAR Dataset/test/subject_test.txt", head=F)
test.means$SubjectID <- test.subject.ids$V1
test.sds$SubjectID <- test.subject.ids$V1

#Add a column for the type of data set (train/test)
train.means$DataSet <- "TRAINING"
train.sds$DataSet <- "TRAINING"
test.means$DataSet <- "TESTING"
test.sds$DataSet <- "TESTING"

#Add the activity labels
train.activity <- read.table("data/raw/UCI HAR Dataset/train/y_train.txt", head=F)
test.activity <- read.table("data/raw/UCI HAR Dataset/test/y_test.txt", head=F)
activity.lables <- read.table("data/raw/UCI HAR Dataset/activity_labels.txt", head=F)
train.activity <- merge(train.activity, activity.lables)
test.activity <- merge(test.activity, activity.lables)
train.means$Activity <- train.activity$V2
train.sds$Activity <- train.activity$V2
test.means$Activity <- test.activity$V2
test.sds$Activity <- test.activity$V2

#Add a column for the type of summary (mean/sd)
train.means$Statistic <- "MEAN"
train.sds$Statistic <- "SD"
test.means$Statistic <- "MEAN"
test.sds$Statistic <- "SD"

#Re-order the columns 
nr.var.cols <- length(mean.column.nrs)
nr.cols <- dim(train.means)[2]
col.order <- c((nr.var.cols+1):nr.cols,1:nr.var.cols)
train.means <- train.means[,col.order]
train.sds <- train.sds[,col.order]
test.means <- test.means[,col.order]
test.sds <- test.sds[,col.order]

#Write a combined tidy data set to file
write.table(train.means, "data/movement.txt", row.names=F, quote=F, sep="\t")
write.table(train.sds, "data/movement.txt", row.names=F, quote=F, sep="\t", append=T, col.names=F)
write.table(test.means, "data/movement.txt", row.names=F, quote=F, sep="\t", append=T, col.names=F)
write.table(test.sds, "data/movement.txt", row.names=F, quote=F, sep="\t", append=T, col.names=F)

