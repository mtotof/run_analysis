library(reshape2)

setwd("./data/")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/data.zip")
unzip("./data.zip", exdir = "data.csv")

#Load the data
setwd("~/data/data.csv/UCI HAR Dataset/test")
testsubject <- read.table("subject_test.txt")
test_x <- read.table("X_test.txt")
test_y <- read.table("y_test.txt")

setwd("~/data/data.csv/UCI HAR Dataset/train")
trainsubject <- read.table("subject_train.txt")
train_x <- read.table("X_train.txt")
train_y <- read.table("y_train.txt")

setwd("~/data/data.csv/UCI HAR Dataset")
features <- read.table("features.txt")
act_labels <- read.table("activity_labels.txt")

#1. Merges the training and the test sets to create one data set, with appropriate labels.
merged <- rbind(testsubject, trainsubject)
colnames(merged) <- "merged"

data <- rbind(test_x, train_x)
colnames(data) <- features[,2]

label <- rbind(test_y, train_y)
label <- merge(label, act_labels, by=1)[,2]

data <- cbind(merged, label, data)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
measures <- grep("-mean|-std", colnames(data))
extract <- data[,c(1,2,measures)]

melted = melt(extract, id.var = c("merged", "label"))
means = dcast(melted , merged + label ~ variable, mean)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

write.table(means, file="~/data/data.csv/UCI HAR Dataset/tidy_data.txt")

