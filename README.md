# ANALYSIS OF DATASET 5 BY Group 22

# Requirements
  - Rstudio
  - lubridate
  - car
  - leaps
  - knitr
  

---
title: "**Stat 3340 Final Project**"  
author: 
        - Zonglin Wu (B00764717)                      
        - Ziwei Wang (B00776666)
        - Yuchan Zhong (B00791155)

        
date: "2020-12-07"
output: 
  pdf_document: default
  word_document: default
  html_document:
    df_print: paged
---

### Abstract

The goal of this project is to find which company is undervalued by using 2013 and 2014 data. By using stepwise feature selection, we choose Depreciation, Net.Income, Retained,Earnings and Estimated.Shares.Outstanding as predictors. We build
Market.Capital=6.366Net.Income+0.347Retained.Earnings+13.152Estimated.Shares.
OutstandingMarket.Capital
As a result, the top 20 undervalued stocks which investors can buy into are found by using 2013 and 2014 data, which include PBCT, EW, IDXX, HBAN, NFLX, SPLS, HPQ, PBI, AIZ, CHD, MAS, DNB, HRL, PDCO, MPC, CNC, WU, XRX, FLIR and ARNC.


### Introduction

The goal of this project is to find which company is undervalued by using 2013 and 2014 data. To predict undervalued stocks, we use multiple linear regression model's predicted market capitalization from the model, dividing the difference by shares outstanding , then selecting the top 20 stocks as the undervalued stocks.

<br>

```{r}
#packages input
library(leaps)
library(lubridate)
library(car)
library(knitr)
#data input
fundamental<-read.csv("../data/fundamentals.csv",header=TRUE)
price_s<-read.csv("../data/prices-split-adjusted.csv",header=TRUE)
security<-read.csv("../data/securities.csv",header=TRUE)
```

<br>

<br>

### Data Pre-processing

```{r}
#Creating yearly stock price mean
price_s$date<-ymd(price_s$date)
price_s$year<-year(price_s$date)
sprice_year<-aggregate(close~symbol+year,data=price_s,FUN=mean) #the mean of annual stock price
#Add Industry from "security" to "fundamental"
names(security)[1]<-"Ticker.Symbol"
information<-security[,c(1,4,5)] #the basic information
data<-merge(fundamental,information,by="Ticker.Symbol",all.x=TRUE) #grouped by Ticker.Symbol
#Date procession
data$Period.Ending<-ymd(data$Period.Ending)
data$year.Ending<-year(data$Period.Ending)
#Add yearly split-adj stock price to "fundamental"
sprice_year$num<-paste(as.character(sprice_year$symbol),sprice_year$year,sep="")
data$num<-paste(as.character(data$Ticker.Symbol),data$year.Ending,sep="")
data<-merge(data,sprice_year[,c(3,4)],by="num",all.x=TRUE) #grouped by the Ticker.Symbol and year.Ending
#Choose data and compute the market capital
data<-subset(data,year.Ending>2012&year.Ending< 2015) #choose 2013 and 2014
data<-subset(data,select=c(Ticker.Symbol,year.Ending,GICS.Sector,Cost.of.Revenue,Depreciation,Earnings.Before.Interest.and.Tax,Net.Cash.Flow,Net.Income,Profit.Margin,Pre.Tax.ROE,Retained.Earnings,Earnings.Per.Share,Estimated.Shares.Outstanding,close))
data$Market.Capital<-data$close*data$Estimated.Shares.Outstanding
data<-subset(data,data$Estimated.Shares.Outstanding>0)
#Missing value processing
data<-na.omit(data)
data$GICS.Sector<-as.factor(as.character(data$GICS.Sector))
t<-table(data$Ticker.Symbol)
data<-subset(data,Ticker.Symbol %in% names(t[t==2]))
data$Ticker.Symbol<-as.factor(as.character(data$Ticker.Symbol))
data<-data[,-c(12,14)]
```

<br>

<br>

### Stepwise Feature Selection

```{r}
#train and test
train<-data[data$year.Ending==2013,-c(1,2,3)]
test<-data[data$year.Ending==2014,-c(1,2,3)]
#Exhaustive feature search
set.seed(1234)
p<-8
best<-regsubsets(Market.Capital~.,data=train,nvmax=p,method="exhaustive")
plot(best,scale="adjr2")
```

<br>

This plot shows the model strength according to features. From that, we may choose Depreciation, Net.Income, Retained.Earnings and Estimated.Shares.Outstanding.

<br>

```{r}
#Cross-validation
train.matrix<-model.matrix(Market.Capital~.,data=train)
test.matrix<-model.matrix(Market.Capital~.,data=test)
train.error<-c()
MSE<-c()
for(i in 1:p){
  coefficient<-coef(best,id=i)
  pred<-test.matrix[,names(coefficient)]%*%coefficient
  MSE[i]<-mean((test$Market.Capital-pred)^2)
}
plot(MSE, type="b", xlab="The numbers of Feature", ylab="MSE", main="Cross Validating Error for Model Size ")
```


```{r}
which.min(MSE)
MSE[which.min(MSE)]
```

<br>

From this plot, we can choose 3 features to build the model and the smallest MSE equals 6.445555e+20.

<br>

```{r}
#For full data
best_all<-regsubsets(Market.Capital~.,data=data[,-c(1,2,3)],nvmax=3)
plot(best_all,scale="adjr2")
names(coef(best_all,id=3))[-1]
```

<br>

From this plot, we can build the model which has the best variables with 3 predictors by using 2013 and 2014 data.

<br>

<br>


### Multiple regression model

```{r}
best_l<-lm(Market.Capital~Net.Income+Retained.Earnings+Estimated.Shares.Outstanding,data=data)
```

<br>

1.Regression Coefficients


```{r}
#Regression coefficient
best_l$coefficient[-1]
#95% CI for regression coefficient
confint(best_l)[4,]
```

Since $\hat\beta=(X'X)^{-1}X'y$, the estimated coefficients of Net.Income, Retained.Earnings and Estimated.Shares.Outstanding are respectively 6.366, 0.347 and 13.152.The 95% CIs for the coefficients of Net.Income,Retained.Earnings and Estimated.Shares.Outstanding are respectively [5.690,7.041], [0.264,0.430] and [13.477,16.827].

The model can be built as 

$$Market.Capital=6.366Net.Income+0.347Retained.Earnings+13.152Estimated.Shares.Outstanding$$
<br>

2.Hypothesis Testing on the Slope

We formulate this hypothesis test as follows:

$$H_0:\beta_1=\beta_2=\beta_3=0;H_1:\beta_j \neq 0\ at\ least\ one\ j$$

Test statistic:

$$t=\frac{\hat\beta_j}{se(\hat\beta_j)}$$

<br>

```{r}
summary(best_l)
```

<br>

The t-statistics of regression coefficients are respectively 18.500, 8.236 and 17.755 and the p-values are all smaller than 0.05. Thus, we reject the null hypothesis, which means the three regressor contributes significantly to the model.

<br>

3.Multicollinearity 

```{r}
print(paste("AIC:",AIC(best_l)))
print(paste("VIF:",vif(best_l)))
pairs(Market.Capital~Net.Income+Retained.Earnings+Estimated.Shares.Outstanding,data=data)
```

<br>

The VIFs mean that Net.Income and Retained.Earnings are nearly linearly dependent on some of the other regressors.

<br>

4.Residual analysis


```{r}
#MSE
n<-length(data$Market.Capital)
b<-length(best_l$coefficients)
(MSE<-sum(best_l$residuals*best_l$residuals)/(n-b))
# Model Adequacy Checking
di<-rstandard(best_l) #standardized residuals
ri<-rstudent(best_l) #studentized residuals
par(mfrow=c(2,2))
plot(best_l)
```

<br>

From the plot, 

1) Residual vs. Fitted: Line remains fairly straight, which means that the model does not break the assumption of linearity.

2) Normal Q-Q: The runoff tails on either end of the plot suggest that the residuals are not normally distributed. This is another limitation of the model.

3) Scale-Location: There appears to be high residual outliers, breaking the assumption of constant variance. x-axis imbalance.

4) Residuals vs Leverage: It appears that residual 10 has large leverage and effect on the regression line.

<br>

```{r}
par(mfrow=c(1,3))
plot(resid(best_l),data$Net.Income)
plot(resid(best_l),data$Retained.Earnings)
plot(resid(best_l),data$Estimated.Shares.Outstanding)
residtable<-cbind(resid(best_l),rstandard(best_l),rstudent(best_l))
```


<br>

<br>

### Find undervalued companies

```{r}
#Highest Residuals
resi_h<-best_l$residuals[order(best_l$residuals,decreasing = TRUE)[1:20]]
com<-c()
for (i in 1:20){
  com[i]<-as.character(data[as.numeric(attributes(resi_h)$names)[i],1])
}
com
```

<br>

```{r}
#Undervalued Companies
ud<-predict(best_l)-data$Market.Capital
frame.ud<-data.frame(data$Ticker.Symbol,data$Market.Capital,ud,data$year.Ending)
undervalue<-subset(frame.ud,data.year.Ending==2014)
names(undervalue)<-c("Ticker", "Market.Capital","Total.Undervalue", "Year")
#Top Companies
undervalue$Percent.Undervalue <-undervalue$Total.Undervalue/undervalue$Market.Capital
top20<-undervalue[order(undervalue$Percent.Undervalue, decreasing=TRUE),]
top20$Company<-unlist(lapply(top20[,1],function(x) security$Security[match(x,security$Ticker.Symbol)]))
top20<-subset(top20,Percent.Undervalue<2)
top20$Year<-NULL
top20<-top20[,c(5,1,2,3,4)]
row.names(top20)<-NULL
kable(top20[1:20,])
```

<br>

<br>

### Result

We can build the linear regression model $Market.Capital=6.366Net.Income+0.347Retained.Earnings+13.152Estimated.Shares.Outstanding$ using 2013 and 2014 year, although there are some limitations in this model like the large MSE. The adjusted R-squared is 0.84 so that the model can fit the data well. 

We can make some actionable recommendations to for potential investors. Abovetable shows the top 20 undervalued stocks which investors can buy into, which include PBCT, EW, IDXX, HBAN, NFLX, SPLS, HPQ, PBI, AIZ, CHD, MAS, DNB, HRL, PDCO, MPC, CNC, WU, XRX, FLIR and ARNC.
