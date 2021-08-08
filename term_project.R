setwd("D:\\BU Fall 2020\\2021 Spring\\CS 555\\term project")
data = read.csv("heart.csv")
library(ggplot2)
library("lattice")
attach(data)
data_yes = subset(data, output==1)
data_no = subset(data, output==0)
pairs(data)
levelplot(cor(data), col.regions=heat.colors(90))
boxplot(data$age~data$output, data = data,names=c("Low risk","High risk"))
boxplot(trtbps~output, data = data,names=c("Low risk","High risk"))
boxplot(chol~output,data = data,names=c("Low risk","High risk"))
boxplot(thalachh~output,data=data,names=c("Low risk","High risk"))
boxplot(oldpeak~output,data=data,names=c("Low risk","High risk"))
counts_gender = table(output,sex)
risk = c("high risk", "low risk")
color = c(rgb(0.2,0.4,0.6,0.6),rgb(0.2,0.9,0.6,0.6))
barplot(counts_gender,main="Bar chart of gender",names.arg = c("female","male"),col=color)
legend("topleft",risk,cex=1.3,fill=color)

risk = c("high risk", "low risk")
color = c(rgb(0.2,0.4,0.6,0.6),rgb(0.2,0.9,0.6,0.6))
counts_cp = table(output,cp)
barplot(counts_cp, main = "Bar chart of chest pain type",names.arg = c("typical angina","atypical angina","non-anginal pain","asymptomatic"),col=color)
legend("topright",risk,cex=1.3,fill=color)

counts_fbs = table(output,fbs) 
barplot(counts_fbs, main = "Bar chart of fasting blood sugar",names.arg = c("False","True"),col=color)
legend("topright",risk,cex=1.3,fill=color)

counts_restecg = table(output,restecg) 
barplot(counts_restecg, main = "Bar chart of resting ECG results",names.arg = c("normal","ST-T wave abnormality","hypertrophy "),col=color)
legend("topright",risk,cex=1.3,fill=color)

counts_exng = table(output,exng)
barplot(counts_exng,main="Bar chart of Exercise Induced Angina",names.arg = c("no","yes"),col=color)
legend("topright",risk,cex=1.3,fill=color)

counts_caa = table(output,caa)
barplot(counts_caa,main="Bar chart of CAA",col=color)
legend("topright",risk,cex=1.3,fill=color)

counts_slope = table(output,slp)
barplot(counts_slope,main="Bar chart for Peak Exercise ST Segment",names.arg = c("Downsloping","Flat","upsloping"),col=color)
legend("topleft",risk,cex=1.3,fill=color)

counts_that = table(output,thall)
barplot(counts_that,main="Bar chart for thlassemia",names.arg = c("Unkown","normal","fixed defect","reversible defect"),col=color)
legend("topright",risk,cex=1.3,fill=color)
#Sex: Male, sign of angina pain, abnormal ST Wave pattern. 

lm_1 = lm(trtbps~age)
plot(age,trtbps)
abline(lm_1, lwd=2, lty=2, 
       col="red")
lm_2 = lm(chol~age)
plot(age,chol)
abline(lm_2, lwd=2, lty=2, 
       col="red")
lm_3 = lm(thalachh~age)
plot(age,thalachh)
abline(lm_3, lwd=2, lty=2, 
       col="red")
#3.	Perform logistic regression on the training data in order to predict output using variable that seemed most associated with output. 

library(aod)
#4. Split the data into a training set and a test set with 80/20 ratio
set.seed(103)
train = sample(1:dim(data)[1],dim(data)[1]*.8,rep=FALSE)
test = -train
training_data = data[train,]
testing_data = data[test,]
output.test = output[test]
glm.fit = glm(output~age+sex+cp+trtbps+chol+fbs+restecg+thalachh+exng+oldpeak+slp+caa+thall,data=training_data,family = binomial,subset=train)
summary(glm.fit)

wald.test(b = coef(glm.fit),Sigma = vcov(glm.fit),Term = 2:14)
exp(cbind(OR = coef(glm.fit),confint.default(glm.fit)))
#If the p-value is less than 0.05, we reject the null hypothesis that there's no difference between the means and conclude that a significant difference does exist
glm.fit = glm(output~age+sex+cp+trtbps+chol+fbs+restecg+thalachh+exng+oldpeak+slp+caa+thall,data=training_data,family = binomial,subset=train)
glm.prob = predict(glm.fit,testing_data,type="response")
glm.pred = rep(0, length(glm.prob))
glm.pred[glm.prob>0.5] = 1
table(glm.pred,output.test)
mean(glm.pred!=output.test)


glm.fit = glm(output~sex+cp+exng+caa+thall,data=training_data,family = binomial,subset=train)
summary(glm.fit)

glm.prob = predict(glm.fit,testing_data,type="response")
glm.pred = rep(0, length(glm.prob))
glm.pred[glm.prob>0.5] = 1
table(glm.pred,output.test)
mean(glm.pred!=output.test)


