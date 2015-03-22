
library(dplyr) 
library(reshape2)

# common activity labels and features lists to be reuse for test and train dataset 
df_activity_label <- read.table("activity_labels.txt") 
df_activity_relabel <- rename(df_activity_label, Activity_ID = V1, Activity_Desc=V2) #rename columns to a more descriptive name and to facilitate merge 
df_reading_labels <- read.table("features.txt") 

# This section performans the following logically: 
# merge subject ids, descriptive activity labels and variables of test data set 
# rename variable names to descriptive ones. 
df_test_subj <- read.table("subject_test.txt") 
colnames(df_test_subj) <- "Subject_ID" #rename column to a more descriptive name   
df_test_activity_id <- read.table("y_test.txt") 
colnames(df_test_activity_id) <- "Activity_ID"#rename column to a more descriptive name and to facilitate merge 
df_test_activity_ID_Desc <- inner_join(df_test_activity_id,df_activity_relabel) # join using Activity_ID. row order will be preserved 
df_test_F_activity_subject <- cbind(df_test_subj, df_test_activity_ID_Desc) 
df_test_X_readings <- read.table("X_test.txt") 
colnames(df_test_X_readings) <- as.character(df_reading_labels[[2]]) # rename columns to descriptive activity labels provided 
df_full_test <- cbind(df_test_F_activity_subject,df_test_X_readings ) 

# repeat the above section for train data set 
df_train_subj <- read.table("subject_train.txt") 
colnames(df_train_subj) <- "Subject_ID" #rename column to a more descriptive name   
df_train_activity_id <- read.table("y_train.txt") 
colnames(df_train_activity_id) <- "Activity_ID"#rename column to a more descriptive name and to facilitate merge 
df_train_activity_ID_Desc <- inner_join(df_train_activity_id,df_activity_relabel) # join using Activity_ID. row order will be preserved 
df_train_F_activity_subject <- cbind(df_train_subj, df_train_activity_ID_Desc) 
df_train_X_readings <- read.table("X_train.txt") 
colnames(df_train_X_readings) <- as.character(df_reading_labels[[2]]) # rename columns to descriptive activity labels provided 
df_full_train <- cbind(df_train_F_activity_subject,df_train_X_readings ) 

# rbind test and train data sets 
df_full <- rbind(df_full_train,df_full_test) 

#created logical vector of required mean and std measurement columns index 
v_required_col_index <- which(grepl("mean\\(\\)", names(df_full))|grepl("std\\(\\)", names(df_full))) 
v_required_col_index <- append( c(1,3), v_required_col_index) # select only subject_ID, Activity_Desc and the required mean and std measurement columns  
df_sub_mean_std <- df_full[,v_required_col_index] 
df_melt <- melt(df_sub_mean_std, id = c("Subject_ID", "Activity_Desc")) # melt data frame to form a long data frame  
df_data<-dcast(df_melt, Subject_ID + Activity_Desc ~ variable, mean) # dcast data to required form 
write.table(df_data,file="tidyData.txt",row.name=FALSE) 
