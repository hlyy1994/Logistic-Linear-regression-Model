
mynew=read.csv("2.26_clean.csv")
library(ggplot2)
library(tidyverse)
library(pastecs)
library(lubridate)
library(randomForest)
library(ROCR)
library(dplyr)
options(scipen=999)
table(mynew$IsTransaction)
test= mynew %>% filter(IsTransaction==1)
mynew$fullVisitorId
distinct(mynew,fullVisitorId)

#distribution dig out
mynew%>%group_by(continent) %>% summarise(length(newVisits))
mynew%>%group_by(continent) %>% summarise(sum(IsTransaction))
mynew%>%group_by(is.USA) %>% summarise(sum(IsTransaction))
mynew%>%group_by(medium)%>%summarise(length(pageviews))
mynew%>%group_by(bounces) %>% summarise(sum(IsTransaction))
mynew%>%group_by(pageviews) %>% summarise(sum(IsTransaction))
mynew%>%group_by(medium)%>%summarise(sum(IsTransaction))

mynew %>% group_by(is.USA) %>% summarise(sum(peakhour))
range(mynew$transactionRevenue)
lm(hits~pageviews, data=mynew)
  spread = ggplot(mynew, aes(x=transactionRevenue)) + geom_density()  
  summary(spread)

table(mynew$bounces)  
  exp(0.49)
#change character into factor
mynew = mynew %>% 
  mutate_if(is.character,as.factor)

class(mynew$trncount)
#whole world logistic


mynew$medium
# usa logistic
temp_USA = mynew %>% filter(bounces==0,!is.na(pageviews)==T,is.USA==1)
temp_USA = temp_USA %>% mutate_if
reg_USA=glm(IsTransaction ~ trncount + trncount_sqr + pageviews + pageviews_sqr
            + visitNumber + visitNumber_sqr
            + newVisits  + isMobile + medium
             + month + is.weekend 
            +peakhour 
            #+ deviceCategory + isTrueDirect +peakhour*is.weekend
            + newVisits * pageviews + trncount * medium 
            ,data = temp_USA, family = binomial(link="logit"))
summary(reg_USA)
exp(0.184)


predict.logit_USA=predict.glm(reg_USA,temp_USA,type="response")
predict.logit_USA

table(temp_USA$IsTransaction,predict.logit_USA>0.5)

#non-USA logistic
temp_NUSA = mynew %>% filter(bounces==0, !is.na(pageviews)==T,is.USA==0)

reg_NUSA=glm(IsTransaction ~ trncount + trncount_sqr + pageviews + pageviews_sqr
            #+ visitNumber + visitNumber_sqr
            + newVisits  
            #+ medium 
            + isMobile + deviceCategory + isTrueDirect
             + month + is.weekend + peakhour 
            + newVisits * pageviews
            ,data = temp_NUSA, family = binomial(link="logit"))
summary(reg_NUSA)
predict.logit_NUSA=predict.glm(reg_NUSA,temp_NUSA,type="response")
predict.logit_NUSA
