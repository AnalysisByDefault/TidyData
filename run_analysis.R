## Read raw data from x.test and x.train data sets
classes <- rep("numeric", 561)
x.test <- read.table("X_test.txt", colClasses=classes, comment.char="")
x.train <- read.table("X_train.txt", colClasses=classes, comment.char="")

## Merge two data sets into one set
x.data <- rbind(x.test, x.train)

## Assign columns with appropriate names 
features <- read.table("features.txt")
colnames(x.data) <- features[[2]]

## Extract "mean" and "std" measurements from entire data set and
## Delete "meanFreq" measurement from extracted data set
ind1 <- grep("mean()|std()", features[[2]])
ind2 <- grep("meanFreq", features[[2]])
index <- ind1[-which(ind1 %in% ind2)]
data <- x.data[, index]

## Read data sets with Activity codes and merge them into one data set
y.test <- read.table("y_test.txt")
y.train <- read.table("y_train.txt")
y.data <- rbind(y.test, y.train)

## Read date set with Acivity names linked with Activity codes and
## Merge Activity code data set with Activity names
activity <- read.table("activity_labels.txt")
y.data <- merge(y.data, activity, sort=F)

## Add two columns with Activity code and Activity name into data
data <- cbind(y.data, data)
colnames(data)[1:2] <- c("Act_Lab", "Activity")

## Aggregate data to get mean for every variable and every activity
data <- aggregate(data, list(data$Activity), mean)

## Sort data by Activity code and
## Transpose data set to change dimention from (6*66) to (66*6)
data <- data[order(data$Act_Lab),]
rownames(data) <- data$Group.1; 
data <- as.data.frame(t(data))
data <- data[-c(1:3),]

## save final tidy data on the disk
write.table(data, file="data.txt")
