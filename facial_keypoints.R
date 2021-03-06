data.dir <- '/home/student/Downloads/'
train.file <- paste0(data.dir, 'training.csv')
test.file  <- paste0(data.dir, 'test.csv')
d.train <- read.csv(train.file, stringsAsFactors=F)
im.train <- d.train$Image
d.train$Image <- NULL
head(d.train)
im.train[1]
as.integer(unlist(strsplit(im.train[1], " ")))
install.packages('doMC')
library(doMC)
registerDoMC()
im.train <- foreach(im = im.train, .combine=rbind) %dopar% {
  as.integer(unlist(strsplit(im, " ")))
}
str(im.train)
d.test  <- read.csv(test.file, stringsAsFactors=F)
im.test <- foreach(im = d.test$Image, .combine=rbind) %dopar% {
  as.integer(unlist(strsplit(im, " ")))
}
d.test$Image <- NULL
save(d.train, im.train, d.test, im.test, file='model.Rd')
load('model.Rd')
im <- matrix(data=rev(im.train[1,]), nrow=96, ncol=96)
image(1:96, 1:96, im, col=gray((0:255)/255))
points(96-d.train$nose_tip_x[1],         96-d.train$nose_tip_y[1],         col="red")
points(96-d.train$left_eye_center_x[1],  96-d.train$left_eye_center_y[1],  col="blue")
points(96-d.train$right_eye_center_x[1], 96-d.train$right_eye_center_y[1], col="green")
for(i in 1:nrow(d.train)) {
  points(96-d.train$nose_tip_x[i], 96-d.train$nose_tip_y[i], col="red")
}
version
idx <- which.max(d.train$nose_tip_x)
im  <- matrix(data=rev(im.train[idx,]), nrow=96, ncol=96)
image(1:96, 1:96, im, col=gray((0:255)/255))
points(96-d.train$nose_tip_x[idx], 96-d.train$nose_tip_y[idx], col="red")
colMeans(d.train, na.rm=T)
p <- matrix(data=colMeans(d.train, na.rm=T), nrow=nrow(d.test), ncol=ncol(d.train), byrow=T)
p
colnames(p) <- names(d.train)
predictions <- data.frame(ImageId = 1:nrow(d.test), p)
head(predictions)
