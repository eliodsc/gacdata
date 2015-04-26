###############################################################################
###     set programming environment
###############################################################################

## clean up
rm(list=ls())

## load libraries
library(dplyr)
library(tidyr)

## set working directory
if(!file.exists("gacdata")) {
        dir.create("gacdata")
}

setwd("./gacdata")


###############################################################################
###     download, unzip and list contained files
###############################################################################

### downlaod the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file (fileUrl, destfile = "./accelerometers.zip", method = "curl")

### unzip and list files contained
unzip ("./accelerometers.zip", exdir = "./", overwrite = TRUE)
ls_files <- unzip ("./accelerometers.zip", list=T)


###############################################################################
###     select columns to be taken from matrix X_test / X_train
###############################################################################

## upload dataset with variable names
features <- read.table("./UCI HAR Dataset/features.txt")

## select only mean() and std()
index <- grepl( "mean()-", as.character(features[,2]), fixed=TRUE ) | grepl( "std()-", as.character(features[,2]), fixed=TRUE )
var_names <- as.character(features[ which(index) , 2])
var_ids <- features[ which(index) , 1]


###############################################################################
###     prepare test dataset
###############################################################################

## subjects
subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## activities
act_id <- read.table("./UCI HAR Dataset/test/y_test.txt")
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity <- as.data.frame(left_join(act_id, act_labels, by = "V1")[,2])

## measurements
measures <- read.table("./UCI HAR Dataset/test/X_test.txt")
measures <- measures[, var_ids ]


## test dataset
test <- data.frame(subject, activity, measures)
names(test) <- c("subject", "activity", var_names)

ncoltest <- dim(test)[2]
test_ds <- test %>%
        gather(key, value, 3:ncoltest) %>%
        separate(key,c("measurement","statistic","coordinate"),sep="-") %>%
        mutate(statistic=substr(statistic,1,nchar(statistic)-2)) %>%
        mutate(group="test") %>%
        select(group, subject, activity, measurement, statistic, coordinate, value)


###############################################################################
###     prepare training dataset
###############################################################################

## subjects
subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## activities
act_id <- read.table("./UCI HAR Dataset/train/y_train.txt")
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity <- as.data.frame(left_join(act_id, act_labels, by = "V1")[,2])

## measurements
measures <- read.table("./UCI HAR Dataset/train/X_train.txt")
measures <- measures[, var_ids ]


## training dataset
train <- data.frame(subject, activity, measures)
names(train) <- c("subject", "activity", var_names)

ncoltrain <- dim(train)[2]
train_ds <- train %>%
        gather(key, value, 3:ncoltrain) %>%
        separate(key,c("measurement","statistic","coordinate"),sep="-") %>%
        mutate(statistic=substr(statistic,1,nchar(statistic)-2)) %>%
        mutate(group="training") %>%
        select(group, subject, activity, measurement, statistic, coordinate, value)


###############################################################################
###     create final datasets
###             ds1 : append test and training datasets
###             ds2 : group by and calculate average
###############################################################################

## dataset step 4
tidy_ds1 <- rbind(test_ds,train_ds)

## dataset step 5
tidy_ds2 <- tidy_ds1 %>%
        ## group by subject, activity and variable = (measure, statistic, coordinate)
        group_by(subject, activity, measurement, statistic, coordinate, add=FALSE) %>%
        mutate(average = mean(value)) %>%
        select(subject, activity, measurement, statistic, coordinate, average) %>%
        distinct()

## export dataset for reporting
write.table(tidy_ds2, file="./tidy_ds2.txt", sep=",", row.name=FALSE)


