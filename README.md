## Study design

### Set environment
* clean up
* load libraries
* create a directory called "gacdata"
* set that folder as the working directory

### Download raw data
* download the zip file using download.file()
* unzip the file in the working directory using unzip()

### Select variables
* read list of variable names from the file "features.txt".
* create an object "var_ids" containing the ids of the variables for which the name contains "mean()-" or "std()-".

### Create test dataset
* create an object "subject" (vector) containing the subject ids from the file "subject_test.txt".
* create an object "activity" (vector) containing the labels of the activities performed by each subject. For this, I took the activity ids (from "y_test.txt") and merge them with the activity labels ("activity_labels.txt").
* create an object "measures" (matrix) containing the columns of the matrix "X_test.txt" that correspond with the selected variables ("var_ids").
* create an object "test" (data frame) merging the 3 previous objects.

### Transform test dataset
Create a dataframe "test_ds" performing the following transformations to the "test" dataframe:
* colapse all columns (except subject and activity) into one column, using gather().
* split up the column created in the previous step into 3 columns: measurement, statistic and coordinate (using separate()).
* remove the parenthesis of the statistic values so that "mean()" becomes "mean", and "std()" becomes "std".
* create a column "group" with unique value "test" to be used for merging the current dataset with the train_ds dataset.
* reorder the columns in a more intuitive way.

### Create training dataset
* create an object "subject" (vector) containing the subject ids from the file "subject_train.txt".
* create an object "activity" (vector) containing the labels of the activities performed by each subject. For this, I took the activity ids (from "y_train.txt") and merge them with the activity labels ("activity_labels.txt").
* create an object "measures" (matrix) containing the columns of the matrix "X_train.txt" that correspond with the selected variables ("var_ids").
* create an object "train" (data frame) merging the 3 previous objects.

### Transform training dataset
Create a dataframe "train_ds" performing the following transformations to the "train" dataframe:
* colapse all columns (except subject and activity) into one column, using gather().
* split up the column created in the previous step into 3 columns: measurement, statistic and coordinate (using separate()).
* remove the parenthesis of the statistic values so that "mean()" becomes "mean", and "std()" becomes "std".
* create a column "group" with unique value "training" to be used for merging the current dataset with the test_ds dataset.
* reorder the columns in a more intuitive way.

### Create tidy datasets
* create dataframe "tidy_ds1" by appending "test_ds" and "train_ds", using rbind().
* create dataframe "tidy_ds2" by performing the following transformations to "tidy_ds1":
* group the dataset by the variables subject, activity, measurement, statistic and coordinate, using group_by().
* calculate the mean of value (per group) using mutate().
* keep only variables subject, activity, measurement, statistic, coordinate and average, using select().
* filter unique values for those variables, using distinct().


## Code Book
### Variables
* subject : id number for the subject performing the activity. Possible values: 1 to 30.
* activity : label of the activity performed by the subject. Possible values: STANDING, SITTING, LAYING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS.
* measurement : description of the measurement taken to the subject/activity combination. Possible values: tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk, fBodyAcc, fBodyAccJerk, fBodyGyro.
* statistic : name of the statistic calculated to the measurement. Possible values: mean, std.
* coordinate : spatial coordinate in which the measurement was taken. Possible values: X, Y, Z.
* average : mean of the value per subject, activity and variable. Note: in the dataset, variable is a combination of measurement, statistic and coordinate.



