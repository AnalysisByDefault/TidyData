## Read Me
R script run_analysis.R contains code for creating tidy data from raw data set. This code reads the below files and creates tidy data set which is wrote down into working directory. In order to work correctly, working directory must have the following files with raw data.

X_test.txt  
X_train.txt  
y_test.txt  
y_train.txt  
features.txt  
activity_labels.txt

The below is a discription of how this R script works. 

This part of code reads raw data from X_test.txt and X_train.txt and merges them into one data set.

    classes <- rep("numeric", 561)
    x.test <- read.table("X_test.txt", colClasses=classes, comment.char="")
    x.train <- read.table("X_train.txt", colClasses=classes, comment.char="")
    x.data <- rbind(x.test, x.train)

Next part of code reads features names from features.txt and matches them with your data set. At this stage you have data set with appropriate column names which reflects feature variables. 

    features <- read.table("features.txt")
    colnames(x.data) <- features[[2]]
    
Then you need to extract only those variables which was recorded only for "mean" and "std" measurements. By doing this, the code will also exclude "meanFreq" measurement.

    ind1 <- grep("mean()|std()", features[[2]])
    ind2 <- grep("meanFreq", features[[2]])
    index <- ind1[-which(ind1 %in% ind2)]
    data <- x.data[, index]
    
This part of code reads activity names and matches them with data set.

    y.test <- read.table("y_test.txt")
    y.train <- read.table("y_train.txt")
    y.data <- rbind(y.test, y.train)
    activity <- read.table("activity_labels.txt")
    y.data <- merge(y.data, activity, sort=F)
    data <- cbind(y.data, data)
    colnames(data)[1:2] <- c("Act_Lab", "Activity")

Next, the data set is aggregated by feature variables and activity names and calculates average value for each group.

    data <- aggregate(data, list(data$Activity), mean)
    
Now the data set has 6 rows with activity name and 66 columns with feature variables. Final part of code sorts all data by activity name / label and transposes data into 66 rows (feature) and 6 columns (activity). It also writes final tidy data set on the disk in current working directory.

    data <- data[order(data$Act_Lab),]
    rownames(data) <- data$Group.1; 
    data <- as.data.frame(t(data))
    data <- data[-c(1:3),]
    write.table(data, file="data.txt")
