
library(dplyr)

## Importing data. First importing features so that I can name columns of tha datasets directly in import afterwards.
features <- read.table("UCI HAR Dataset\\features.txt", col.names=c("row","feature"))
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt", col.names=c("activity","activity_label"))

X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt", col.names=features$feature)
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt", col.names=c("activity"))
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt", col.names=c("subject"))
X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt", col.names=features$feature)
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt", col.names=c("activity"))
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt", col.names=c("subject"))

## Bind activity and subject id into the datasets
test <- X_test %>%
  cbind(y_test,subject_test)

train <- X_train %>%
  cbind(y_train,subject_train)

## Binding test and train datasets. Then joining in the acivity labels. Finally selecting only columns with mean and standard deviation, in addition to subject and activity label.

tidy <- test %>%
  rbind(train) %>%
  left_join(activity_labels, by="activity") %>%
  select(contains(c("subject","activity_label",".mean.","std.")))

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
average <- tidy %>%
  group_by(subject, activity_label) %>%
  summarise_all(mean) %>%
  ungroup()

write.table(average, "average.txt", row.names = FALSE)