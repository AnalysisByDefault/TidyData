classes <- rep("numeric", 561)
x.test <- read.table("X_test.txt", colClasses=classes, comment.char="")
x.train <- read.table("X_train.txt", colClasses=classes, comment.char="")

x.data <- rbind(x.test, x.train)

features <- read.table("features.txt")
colnames(x.data) <- features[[2]]

data <- x.data[, grep("mean|std", features[[2]])]

y.test <- read.table("y_test.txt")
y.train <- read.table("y_train.txt")
y.data <- rbind(y.test, y.train)

activity <- read.table("activity_labels.txt")
y.data <- merge(y.data, activity, sort=F)

data <- cbind(y.data, data)
colnames(data)[1:2] <- c("Act_Lab", "Activity")

data <- aggregate(data, list(data$Activity), mean)

data <- data[order(data$Act_Lab),]
rownames(data) <- data$Group.1; 
data <- as.data.frame(t(data))
data <- data[-c(1:3),]

write.table(data, file="data.txt")