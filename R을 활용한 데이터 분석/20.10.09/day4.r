library(ggplot2)
library(dplyr)
library(readxl)

# kmeans �� �̿��� Ŭ�����͸�(sns data)

sns_data <- read.csv('./R���������ͼ�/snsdata.csv')

str(sns_data)

table(sns_data$gender) # F:22054 , M:5222
table(!is.na(sns_data$gender)) # NA : 2724

# table �Լ����� NA ���� �ɼ�
table(sns_data$gender,useNA = 'ifany')

table(sns_data$gradyear , useNA = 'ifany') # 2006~2009 ���� 7500 ����

# ���Ľǽ�1. gender �� ��ü : na ���� ���� �л��� ���� ������ �л� 10�� -> ���� �Ǵ� -> Ŭ�����͸�

table(!is.na(sns_data$age))

summary(sns_data$age)

sns_data$age <- ifelse(sns_data$age>=13 &sns_data$age<20,sns_data$age,NA)
# ������� ���� ������ ó��

sns_data$female = ifelse(sns_data$gender=="F",1,0) # ifelse ó���� NA�� ���� X
table(sns_data$female)

sns_data$no_gender = ifelse(is.na(sns_data$gender),1,0)
table(sns_data$no_gender)

sns_data$female = ifelse(sns_data$gender=="F"&!is.na(sns_data$gender),1,0) 
# ifelse ���ǿ���NA �˻縦 �����ϸ� ó�� ����
table(sns_data$female)

# ������ ������ ���� ��� : ��ü������ Ȱ���� ���
mean(sns_data$age , na.rm=T)

# Q1. ���������� ���� ������ ���
sns_data %>% group_by(gradyear) %>% 
  summarise(mean_age = mean(age,na.rm=T)) 

aggregate(data=sns_data,age~gradyear,mean,na.rm=T)
# �����Լ� ���޷� �����ϴ� aggregate func

# R �Լ� �
x <- 1:10
mean(x)
ave(x) # �Է¹��Ϳ� ������ ������ ���͸� ���

mygroup <- rep(1:2,c(3,7))
mygroup
ave(x,mygroup,FUN=mean)
ave(x,mygroup,FUN=sum)
ave(x,mygroup,FUN=function(a)sum(a^2))

kd

x       # 1  2  3  4  5  6  7  8  9 10
mygroup # 1  1  1  2  2  2  2  2  2  2 # �׷� ��ȣ
# ave (������ , �׷����� , �����Լ�) 
# -> �����͸� �� �׷캰�� �����Լ��� ������ ��ȯ���� ������ �����ϰ� ä��


#------------------------------------------------------------------------

ave_age <- ave(sns_data$age,sns_data$gradyear , FUN= function(x) mean(x,na.rm=T))
# �����⵵ ���� ��� ��հ����� �ٲ���� ave_age


sns_data$age <- ifelse(is.na(sns_data$age),ave_age,sns_data$age)
# �������̸� ave_age ���� , �ƴϸ� ������
summary(sns_data$age)

class(sns_data[5:40])

interests <- sns_data[5:40]
lapply(interests,scale) # ����Ʈ �������� ��ȯ

interests_z <- as.data.frame(lapply(interests,scale))

set.seed(12345)

teen_clusters <- kmeans(interests_z,5)

teen_clusters
# �� Ŭ�����Ϳ� ���� �ؼ��� �м����� ��

summary(teen_clusters$centers[1,]) # shopping , 

teen_clusters$centers[1,][order(teen_clusters$centers[1,])]
# �׷�1 : � �Ⱦ���, ���� ������

teen_clusters$centers[2,][order(teen_clusters$centers[2,])]
# �׷�2 : �� Ư���� ����. ������??

teen_clusters$centers[3,][order(teen_clusters$centers[3,])]
# �׷�3 : �̼��� ���� ������ ����

teen_clusters$centers[4,][order(teen_clusters$centers[4,])]
# �׷�4 : ��� ��ģ �����

teen_clusters$centers[5,][order(teen_clusters$centers[5,])]
# �׷�5 : ������ ���� , �׷���� 

sns_data$cluster <- teen_clusters$cluster

sns_data[1:10,c('cluster','gender','age','friends')]

aggregate(data=sns_data,age~cluster,mean)

aggregate(data=sns_data,female~cluster,mean)

aggregate(data=sns_data,friends~cluster,mean)


# ��������� �м��̰� , ���ο� �����Ͱ� �������� ������ ����ұ�?

str(interests_z)


# �ڻ��� ���絵 �޼ҵ带 ���� proxy ��Ű��
install.packages('proxy')
library(proxy)
# d1,d2,d3 : ������ȣ , C : �ܾ� ���� Ƚ�� ����
d1 <- c(1,0,5)
d2 <- c(4,7,3)
d3 <- c(40,70,30)

#���Ϳ��� -> rbind (row-bind) : matrix ��ȯ
doc <- rbind(d1,d2,d3)
colnames(doc)<-c('sky','cloud','rain')

# �Ÿ�����
dist(doc,method = 'cosine')

dist(doc,method = 'euclidean')


# 1�� ������ �м� ������Ʈ ���� (4������ �� , ��ǥ)
# ��õ�ý��� , �ð�ȭ(�м�) , ��ȸ �̽� , �Ǹ�(���� ��ǰ), �� �з� ��
# data.go.kr , uci.edu , ������ , ũ�Ѹ�

# 2�� �ؽ�Ʈ �з� ������Ʈ ���� ����(10�� �� ~ 11�� ��)