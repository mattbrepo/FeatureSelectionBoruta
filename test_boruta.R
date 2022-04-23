library("Boruta")
library("mlbench")
library("lmvar")
library("caret")

#
# Feature Selection with the Boruta Package - Miron B. Kursa (2010)
#

# --- test from the paper
data("Ozone")
Ozone2 <- na.omit(Ozone)

set.seed(1)
OzoneBoruta <- Boruta(V4 ~ ., data=Ozone2, doTrace=2, ntree=500)
OzoneBoruta
plot(OzoneBoruta)

# --- test with non-classification target (V9)
colnames(Ozone2)[9] <- "y"
OzoneBoruta2 <- Boruta(y ~ ., data=Ozone2, doTrace=2, ntree=500)
OzoneBoruta2
plot(OzoneBoruta2)
colMeans(OzoneBoruta2$ImpHistory) # to identify the best features found

# ---- compare Q2 of 3 lm models
# the 'train' function seems to have some issues with V12,V13 columns...
colnames(Ozone2)[12] <- "X12"
colnames(Ozone2)[13] <- "X13"

# with worst 3 features
fit <- train(y ~ V2+V6+X13, data=Ozone2, method="lm", trControl=trainControl(method = "cv", number = 5))
fit$results$Rsquared # Q2 CV 5

# with all the features
fit <- train(y ~ ., data=Ozone2, method="lm", trControl=trainControl(method = "cv", number = 5))
fit$results$Rsquared # Q2 CV 5

# with best 3 features
fit <- train(y ~ V5+V8+X12, data=Ozone2, method="lm", trControl=trainControl(method = "cv", number = 5))
fit$results$Rsquared # Q2 CV 5

# ---- test on my data
data <- read.csv("data/X.txt", sep=",", header=FALSE)
data_Y <- read.csv("data/Y.txt", sep=",", header=FALSE)
data$y <- data_Y

# for some reasong this is needed:
mdata <- as.matrix(data)
data <- as.data.frame(mdata) 

dataBoruta <- Boruta(y ~ ., data=data, doTrace=2, ntree=500)
plot(dataBoruta)
cm <- colMeans(dataBoruta$ImpHistory)
cm <- cm[cm > 4] # the threshold 4 was identified looking at the plot!

# take the 7 best features (to compare it with data_OLS)
head(sort(cm, decreasing = TRUE), 7)
fit <- train(y ~ V1040+V1597+V2070+V2071+V2082+V1080+V2081, data=data, method="lm", trControl=trainControl(method = "cv", number = 5))
fit$results$Rsquared # Q2 CV 5 ==> circa 0.53

# test with more trees ==> similar results...
dataBoruta <- Boruta(y ~ ., data=data, doTrace=2, ntree=2000)
cm <- colMeans(dataBoruta$ImpHistory)
cm <- cm[cm > 4] # the threshold 4 was identified looking at the plot!
head(sort(cm, decreasing = TRUE), 7)
fit <- train(y ~ V1040+V1597+V2071+V2070+V2080+V1080+V2081, data=data, method="lm", trControl=trainControl(method = "cv", number = 5))
fit$results$Rsquared # Q2 CV 5
