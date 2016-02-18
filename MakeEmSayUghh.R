#######################################
#### MAKE EM SAY UGHHHHHHHHHHHHH ######
#######################################

#### DROPBOX VERSION #######

######################################
#### ENVIRONMENT / PACKAGES ##########
######################################

options(scipen = 3)
setwd("/storage-home/a/ara6/STAT640")
print("working directory set")

# load packages
require(Matrix)
require(lsa)
require(methods)
require(dplyr)
require(randomForest)
require(ada)
require(glmnet)
print("packages loaded")

######################################
#### LOAD DATA ###### CLEAR ##########
######################################

# raw data
ratings <- read.table("/storage-home/a/ara6/STAT640/Data/ratings.csv",header=TRUE,sep=",")
idmap <- read.table("/storage-home/a/ara6/STAT640/Data/IDMap.csv",header=TRUE,sep=",")
sex <- read.table("/storage-home/a/ara6/STAT640/Data/gender.csv", header=TRUE, sep=",")
ratings$Gender <- sex$Gender[ratings[,1]]

# home made objects
cosmat <- readRDS("/storage-home/a/ara6/STAT640/Objects/cosmatrixU.RData")
# simrate <- readRDS("/storage-home/a/ara6/STAT640/Objects/simrate.RData")
# cosmatP <- readRDS("/storage-home/a/ara6/STAT640/Objects/cosmatrixP.RData")

# latent.p <- readRDS("/storage-home/a/ara6/STAT640/Objects/latentp.RData")
# latent.u <- readRDS("/storage-home/a/ara6/STAT640/Objects/latentu.RData")

# train and test data
# train.in <- readRDS("/storage-home/a/ara6/STAT640/Samples/train1.RData")
# test.in <- readRDS("/storage-home/a/ara6/STAT640/Objects/test1.RData")
big.samp <- readRDS("/storage-home/a/ara6/STAT640/Objects/big_samp.RData")
submish <- readRDS("/storage-home/a/ara6/STAT640/Objects/submission_latent.RData")
submish <- inner_join(as.data.frame(sex), submish, by = "UserID")

# ada models
ada1 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada1.RData")
ada2 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada2.RData")
ada3 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada3.RData")
ada4 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada4.RData")
ada5 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada5.RData")
ada6 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada6.RData")
ada7 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada7.RData")
ada8 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada8.RData")
ada9 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada9.RData")
ada10 <- readRDS("/storage-home/a/ara6/STAT640/Objects/ada10.RData")

# glm models
glm.mesu <- readRDS("/storage-home/a/ara6/STAT640/Objects/glm.mesu.RData")

######################################
#### LOAD DATA ###### LAPTOP #########
######################################

# raw data
ratings <- read.table("~/Dropbox/Rice/Stat 640/Competition/Kaggle Data/ratings.csv",
                      header=TRUE,sep=",")
idmap <- read.table("~/Dropbox/Rice/Stat 640/Competition/Kaggle Data/IDMap.csv",
                    header=TRUE,sep=",")
sex <- read.table("~/Dropbox/Rice/Stat 640/Competition/Kaggle Data/gender.csv",
                  header=TRUE, sep=",")
ratings$Gender <- sex$Gender[ratings[,1]]

# home made objects
# cosmat <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/cosmatrixU.RData")
# simrate <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/simrate.RData")
# cosmatP <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/cosmatrixP.RData")

# latent.p <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/latentp.RData")
# latent.u <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/latentu.RData")

# train and test data
train.in <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/Samples/train3.RData")
test.in <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/Samples/test1.RData")
big.samp <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/Samples/big_samp.RData")
submish <- readRDS("~/Dropbox/Rice/Stat 640/Competition/R Objects/Samples/submission_latent.RData")
submish <- inner_join(as.data.frame(sex), submish, by = "UserID")

# ada models
ada1 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada1.RData")
ada2 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada2.RData")
ada3 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada3.RData")
ada4 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada4.RData")
ada5 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada5.RData")
ada6 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada6.RData")
ada7 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada7.RData")
ada8 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada8.RData")
ada9 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada9.RData")
ada10 <- readRDS("/Users/ARA/Desktop/MESU/Objects/ada/ada10.RData")

# glm model
glm.mesu <- readRDS("/Users/ARA/Desktop/MESU/Objects/glm.mesu.RData")

##########################################
### CLEAN UP DATA  #######################
##########################################

# create ratings matrix
rmat <- sparseMatrix(i=ratings[,1],j=ratings[,2],x=ratings[,3])

# clean up data
# rename sample and pick a k
train <- (train.in %>% filter(k == 8))
test <- test.in %>% filter(k == 8)

# rename troublesome variable names
colnames(train)[36] <- "TOP1.prat"
colnames(train)[19] <- "TOP1.urat"

colnames(test)[36] <- "TOP1.prat"
colnames(test)[19] <- "TOP1.urat"

# make rating distribution of user and profile percentages, not counts
train[,9:18] <- train[,9:18] / train[,"N.urat"]
train[,26:35] <- train[,26:35] / train[,"N.prat"]
test[,9:18] <- test[,9:18] / test[,"N.urat"]
test[,26:35] <- test[,26:35] / test[,"N.prat"]

#####################################
### ADD MORE LATENT VARIABLES #######
#####################################

# avg differences
train <- train %>% mutate(AVG.updif = AVG.urat - AVG.prat, AVG.kpdif = K.Mean - AVG.prat, AVG.kudif = AVG.urat - K.Mean)
test <- test %>% mutate(AVG.updif = AVG.urat - AVG.prat, AVG.kpdif = K.Mean - AVG.prat, AVG.kudif = AVG.urat - K.Mean)

# fit glm model, add predictions
train$GLM <- as.vector(predict(glm.mesu, newx = as.matrix(train[,-c(1,2,3,4,16,20)])))
test$GLM <- as.vector(predict(glm.mesu, newx = as.matrix(test[,-c(1,2,3,4,16,20)])))


# store ada predictions in temp file
ada.temp <- train[,c("UserID", "ProfileID")]

ada.temp$ADA1 <- as.numeric(as.character(predict(ada1, newdata=train[,-3])))
ada.temp$ADA2 <- as.numeric(as.character(predict(ada2, newdata=train[,-3])))
ada.temp$ADA3 <- as.numeric(as.character(predict(ada3, newdata=train[,-3])))
ada.temp$ADA4 <- as.numeric(as.character(predict(ada4, newdata=train[,-3])))
ada.temp$ADA5 <- as.numeric(as.character(predict(ada5, newdata=train[,-3])))
ada.temp$ADA6 <- as.numeric(as.character(predict(ada6, newdata=train[,-3])))
ada.temp$ADA7 <- as.numeric(as.character(predict(ada7, newdata=train[,-3])))
ada.temp$ADA8 <- as.numeric(as.character(predict(ada8, newdata=train[,-3])))
ada.temp$ADA9 <- as.numeric(as.character(predict(ada9, newdata=train[,-3])))
ada.temp$ADA10 <- as.numeric(as.character(predict(ada10, newdata=train[,-3])))

# bind ada predictions with latent variables
train <- right_join(train, ada.temp, by = c("UserID", "ProfileID"))

# add Prediction and step columns
train$Prediction <- NA
train$Step <- NA

test$Prediction <- NA
test$Step <- NA

#####################################
### MAKE EM SAY UGHHHHHHH ###########
#####################################


mesu.model <- function(DATA){
  train <- DATA

  for (i in 1:nrow(train)) {
    # step 1 
    if (train[i, "K.SD"] == 0) {
      train[i, "Prediction"] <- train[i, "K.Mean"]
      train[i, "Step"] <- "0 K.SD"
    }
    
    # step 2 - 
    else if (train[i, "ADA1"] == 1){
      if (train[i, "Gender.x"] == "F" & train[i, "K.Mean"] > 5) {
        train[i, "Prediction"] <- train[i, "K.Mean"]
      }
      else {
        train[i, "Prediction"] <- 1
      }
      train[i, "Step"] <- "ADA.1"
    }
    
    # step 3 - 
    else if (train[i,"ADA10"] == 1) {
      train[i, "Prediction"] <- 10
      train[i, "Step"] <- "ADA.10"
    }
    
#     # step 4 - 
#     else if (train[i, "ADA2"] == 1){
#       train[i, "Prediction"] <- 2
#       train[i, "Step"] <- 4
#     }
#     
#     # step 5
#     else if (train[i, "ADA3"] == 1){
#       train[i, "Prediction"] <- 3
#       train[i, "Step"] <- 5
#     }
#     
#     # step 6 - 
#     else if (train[i,"ADA4"] == 1) {
#       train[i, "Prediction"] <- 4
#       train[i, "Step"] <- 6
#     }
# 
#     # step 7
#     else if (train[i, "ADA5"] == 1) {
#       train[i, "Prediction"] <- 5
#       train[i, "Step"] <- 7
#     }
#     
#     # step 8
#     else if (train[i, "ADA6"] == 1) {
#       train[i, "Prediction"] <- 6
#       train[i, "Step"] <- 8
#     }
#     
#     # step 9
#     else if (train[i, "ADA7"] == 1) {
#       train[i, "Prediction"] <- 7
#       train[i, "Step"] <- 9
#     }
#     
#     # step 10
#     else if (train[i, "ADA8"] == 1) {
#       train[i, "Prediction"] <- 8
#       train[i, "Step"] <- 10
#     }
#     
#     # step 11
#     else if (train[i, "ADA9"] == 1) {
#       train[i, "Prediction"] <- 9
#       train[i, "Step"] <- 11
#     }
#     
#      # step 12
#      else if (train[i, "K.SD"] > 2) {
#         train[i, "Prediction"] <- (train[i, "K.Mean"] + train[i, "AVG.prat"] + 
#                                      train[i, "GLM"])/3
#         train[i, "Step"] <- 12
#       }
#         
    # step 13
    else {
      train[i, "Prediction"] <- train[i, "K.Mean"]
      train[i, "Step"] <- 3
    }
  print(i)
  }
  train
}
  
train.final <- mesu.model(train)
train.final <- train.final %>% mutate(Error = Rating - Prediction)

test.final <- mesu.model(test)
test.final <- test.final %>% mutate(Error = Rating - Prediction)

####################################
### NUMERICAL DIAGNOSTICS ##########
####################################

# rmse
train.final %>% summarise(RMSE = sqrt(sum(Error^2) / nrow(train)))
test.final %>% summarise(RMSE = sqrt(sum(Error^2) / nrow(test)))

# rmse, by step
train.final %>% group_by(Step) %>% summarise(RMSE = sqrt(sum(Error^2) / nrow(train)), n = n())
test.final %>% group_by(Step) %>% summarise(RMSE = sqrt(sum(Error^2) / nrow(test)), n = n())

# rmse, by step, by gender
train.final %>% group_by(Step, Gender.x) %>% 
  summarise(RMSE = sqrt(sum(Error^2) / nrow(train)), n = n())
test.final %>% group_by(Step, Gender.x) %>% 
  summarise(RMSE = sqrt(sum(Error^2) / nrow(train)), n = n())

# training wayoffs
train.final %>% dplyr::select(UserID, ProfileID, Gender.x, AVG.urat, AVG.prat, K.Mean, Rating, Prediction, MOD.urat, Step, Error) %>% filter(abs(Error) > 4)

train %>% dplyr::select(UserID, ProfileID, Gender.x, AVG.prat, K.Mean, Rating, Prediction, Step, Error) %>% filter(abs(Error) > 4) %>% group_by(Step, Gender.x) %>% summarise(n=n())

junk <- train %>% filter(Step==5) %>% dplyr::select(Gender.x, Rating, AVG.urat, AVG.prat, K.Mean, GLM, RF, K.SD, SD.urat)

junk2 <- train %>% filter(Step==5) %>% dplyr::select(Gender.x, Rating, GLM, AVG.prat, K.Mean, RF, K.SD) %>% mutate(GLM.E = Rating - GLM, K.MEAN.E = Rating - K.Mean, RF.E = Rating - RF)

junk2 %>% filter(K.SD < 2) %>% group_by(Gender.x) %>% summarise(RMSE.KM = sqrt(sum(K.MEAN.E^2) / nrow(junk2)), RMSE.RF = sqrt(sum(RF.E^2) / nrow(junk2)), RMSE.GLM = sqrt(sum(GLM.E^2) / nrow(junk2)))

####################################
### GRAPHICAL DIAGNOSTICS ##########
####################################

# ratings by gender
ggplot(train.final) + aes(x=as.factor(Rating), y = Prediction, color = Gender.x) + 
  geom_boxplot() + 
  scale_y_continuous(breaks=1:10)

ggplot(test.final) + aes(x=as.factor(Rating), y = Prediction, color = Gender.x) + 
  geom_boxplot() + 
  scale_y_continuous(breaks=1:10)

# error by gender and step
ggplot(train.final) + aes(x=as.factor(Rating), y=Error, color = Gender.x) + 
  geom_boxplot() + 
  facet_grid(Step~.)

ggplot(test.final) + aes(x=as.factor(Rating), y=Error, color = Gender.x) + 
  geom_boxplot() + 
  facet_grid(Step~.)

###################################
#### PLOTS FOR PROJECT WRITEUP ####
###################################

ggplot(ratings) + aes(x=factor(Rating), fill = Gender) + geom_bar() + 
  ggtitle("Ratings by Gender") + 
  xlab("Rating")

