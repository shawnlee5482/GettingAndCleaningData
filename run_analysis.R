setwd("E:\\RExercise\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset")

# read test data
x_test <- read.table("test\\x_test.txt", stringsAsFactors = FALSE)
y_test <- read.table("test\\y_test.txt", stringsAsFactors = FALSE)
subject_test <- read.table("test\\subject_test.txt", stringsAsFactors = FALSE)
# feature list
features <- read.table("features.txt", stringsAsFactors = FALSE)

merged_data <- x_test

# names activity column
colnames(y_test) <- "Activity"
colnames(subject_test) <- "Subject"
colnames(merged_data) <- features$V2;

#bind activity and put it into merged data
merged_data <- cbind(merged_data, y_test)
merged_data <- cbind(merged_data, subject_test)

#now read x_train data
x_train <- read.table("train\\X_train.txt", stringsAsFactors = FALSE, row.names=NULL)
y_train <- read.table("train\\Y_train.txt", stringsAsFactors = FALSE, row.names=NULL)
subject_train <- read.table("train\\subject_train.txt", stringsAsFactors = FALSE)

merged_train <- x_train
colnames(y_train) <- "Activity"
colnames(subject_train) <- "Subject"
colnames(merged_train) <- features$V2;

merged_train <- cbind(merged_train, y_train)
merged_train <- cbind(merged_train, subject_train)

#finally merge into merged_data
merged_data <- rbind(merged_data, merged_train)

#find mean, std columns
selected_cols <- grep("mean\\(\\)|std\\(\\)", features$V2)
selected_cols
str(selected_cols)

selected_data <- merged_data[, selected_cols]
activity <- merged_data$Activity
subject <- merged_data$Subject

selected_data <- cbind(selected_data, activity)
selected_data <- cbind(selected_data, subject)

selected_data$activity <- as.character(selected_data$activity)

#substitue the data
activity_labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)

# change activity name more descriptive
for(i in 1:nrow(activity_labels)) {
   print(as.character(i))
   print(activity_labels[i, 2])
   selected_data$activity <- gsub(as.character(i), activity_labels[i, 2], selected_data$activity)
}

#View(head(selected_data))

#used dplyr
# data summarize and generate table
library(dplyr)
data_summarized_activity <- selected_data %>%
  group_by(activity, subject) %>%
  summarise_each(funs(mean))
# data_summarized_activity <- select(data_summarized_activity, - subject)
View(data_summarized_activity)
#write.table(data_summarized_activity, file="mean_std_by_activity.txt", row.name=FALSE, eol="\r\n")
write.table(data_summarized_activity, file="mean_std.txt", row.name=FALSE, eol="\r\n")
