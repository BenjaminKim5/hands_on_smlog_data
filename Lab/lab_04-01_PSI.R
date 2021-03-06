##
## lab_04-01_PSI.R
## R's 간단 실습(재고 데이터 분석)
## 
## update: 20.05.14
## update: 20.11.12
## update: 21.05.14

## ----------------------------------------
## 기본환경 설정
  source("lab_00_기본환경설정.R")

## ----------------------------------------
##  Step 0. 
## ----------------------------------------

# install.packages("readxl")
# install.packages("ggplot2")
# install.packages("dplyr")

library(readxl)
library(ggplot2)

## ----------------------------------------
##  Step 1: 원본 데이터 가져오기
## ----------------------------------------
rm(list=ls())

psi_data <- read_excel("./data/PSI_data.xlsx")
View(psi_data)

## ----------------------------------------
##  Step 2: 데이터 편집
## ----------------------------------------
## If 데이터에 NA 값을 0 로 수정
psi_data[is.na(psi_data)] <- 0

## 데이터 그룹화 검색
library(dplyr)

## 건수 =  n()
tmp <- group_by(psi_data, psi_data$일자) %>% 
  summarise(n()) 

# arrange(tmp$`n()`, tmp$`psi_data$일자`)
View(tmp)

## 2012-01-10, 2012-01-11
tmp <- filter(psi_data, 
              psi_data$품목코드=="Item_011" , 
              psi_data$생산량 > 0)
View(tmp)

## ----------------------------------------
##  Step 3: 시각화
## ----------------------------------------
## 생산량(P) 데이터 시각화 
plot(tmp$생산량)
plot(tmp$생산량, type = "l")
plot(tmp$생산량, type = "l", main="생산량 분포")
lines(lowess(tmp$생산량))

## 판매량(S) 데이터 시각화 
plot(tmp$판매량)
plot(tmp$판매량, type = "l")
plot(tmp$판매량, type = "l", main="판매량 분포")
plot(tmp$판매량, type = "l", col='red',
     main="판매량 분포")
lines(lowess(tmp$판매량))

## 재고량(I) 데이터 시각화 
hist(tmp$재고량)
hist(tmp$재고량, main="재고량 분포")
lines(lowess(tmp$재고량))

## 여러 개의 그래프를 하나에 그리기(Combining Graphs)
## Plots clean: Plot  제거하기
if(!is.null(dev.list())) dev.off()

# par(mfrow = c(1, 1))
par(mfrow = c(1, 3))

plot(tmp$판매량, type = "l", col='red', main="판매량 분포")
plot(tmp$생산량, type = "l", main="생산량 분포")
hist(tmp$재고량, main="재고량 분포")

## ggplot()
## 산점도 / 산포도  geom_point( )
## 선 그래프        geom_line( )
## 박스플롯         geom_boxplot( )
## 히스토그램       geom_histogram( )
## 막대 그래프      geom_bar( )

Item_data <- filter(psi_data, psi_data$품목코드=="Item_100" )
## P: 생산량
ggplot(data=Item_data, aes(x=일자,y=생산량)) + 
  geom_line(size=1.5, color="red")
## S: 판매량
ggplot(data=Item_data, aes(x=일자,y=판매량)) + 
  geom_line(size=1.5, color="blue")
## I: 재고
ggplot(data=Item_data, aes(x=일자, y = 재고량)) + 
  geom_area(fill="green", alpha=0.2)

## PSI 통합 그래프
ggplot(data=Item_data, aes(x=일자,y=생산량)) + 
  geom_line(size=1.5, color="red") +
  geom_line(size=1.5, color="blue", 
            data=Item_data, aes(x=일자,y=판매량)) +
  geom_area(fill="green", alpha=0.2,
            data=Item_data, aes(x=일자, y = 재고량))

## END ##