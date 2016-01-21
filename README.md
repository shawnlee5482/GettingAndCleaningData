This file explains the analysis performed on the data collected by experiment for Galaxy-S II.

1. Analysis 

Generated output contains

- mean value for the selected variables grouped by Activity and Subject
- 'mean_std.txt' contains analysis result for each activity group and each tester

* For the detailed explanation of each varaible, please refer to codebook

Alaysis performed by following steps

1) read data in
   test data
   =========
   x_test.txt
   y_test.txt
   subject_test.txt

   train data
   ==========
   x_train.txt
   y_train.txt
   subject_train.txt

   activity label and features used in the data description
   ========================================================
   activity_labels.txt
   features.txt

2) merge the data
	merge test data, train data, subject data, activity data
		# first merge x_test
		merged_data <- x_test
		# add y_test
		merged_data <- cbind(merged_data, y_test)
		# add subject_test for later analysis
		merged_data <- cbind(merged_data, subject_test)
		
		#merge training data
		merged_train <- cbind(merged_train, y_train)
		merged_train <- cbind(merged_train, subject_train)
		merged_train <- cbind(merged_train, y_train)
		merged_train <- cbind(merged_train, subject_train)

3) Filter necessary variables
		Select column by using grep()
		Note that we should use mean() and std() since some derived variable also contains mean and std in their name
		selected_cols <- grep("mean\\(\\)|std\\(\\)", features$V2)

		
4) Make variable names more descriptive
		read activity label description file for later mapping activity number to descriptive string
		#substitue the data
		activity_labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)

		# change activity name more descriptive
		for(i in 1:nrow(activity_labels)) {
   			print(as.character(i))
   			print(activity_labels[i, 2])
   			selected_data$activity <- gsub(as.character(i), activity_labels[i, 2], selected_data$activity)
		}		

5) Generate table by gouping activity and subject
		'dplyr' library is used for ease of manipulation
		for each group, we calculate average value

		library(dplyr)
		# for subject group
		data_summarized_activity <- selected_data %>%
  		group_by(activity) %>%
  		summarise_each(funs(mean))
		data_summarized_activity <- select(data_summarized_activity, - subject)

		# for activity group
		View(data_summarized_activity)
		data_summarized_subject <- select(selected_data, -activity) %>%
  		group_by(subject) %>% 
  		summarise_each(funs(mean))
		View(data_summarized_subject)

6) Writing table out
		write.table(data_summarized_activity, file="mean_std.txt", row.name=FALSE, eol="\r\n")
		write.table(data_summarized_subject, append=TRUE, file="mean_std.txt", row.name=FALSE, eol="\r\n")

