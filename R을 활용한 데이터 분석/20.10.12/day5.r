install.packages('ggplot2')
installed.packages('proxy')
install.packages('dplyr')
install.packages('readxl')

member <- data.frame(spent=c(10,1,1,17,4,6,1,15,22,3,0,3,7,0,2),
           time=c(15,2,10,7,5,7,1,10,18,3,1,3,7,10,2))

res <- kmeans(member,3)
res

# Ŭ�����͸� �ð�ȭ �� �Ӽ� 

install.packages('fpc')
library(fpc)
library(dplyr)
library(ggplot2)
library(readxl)

fpc::plotcluster(member, res$cluster)

res$centers

res$totss # 1028.667
# total sum of square : �� (Ŭ�����Ϳ� �����Ͱ� �Ÿ� ������ ��) �� ��ü ��

res$withinss # 88.22222   0.50000 147.00000
# withinss : ������ ������

res$tot.withinss # 235.7222
# �������� ���� : �������� ���� ��ġ

res$betweenss # 792.9444
# Ŭ�����Ͱ� ������ �ִ� �Ÿ� : Ŭ���� ���� ��ġġ

res$size # 9 2 4
# �� Ŭ�����Ϳ� �Ҽӵ� �������� ��

res$iter # 2
# Ŭ�����͸��� �־ ��� �ݺ��Ǿ���

#--------------------------------------------------------------

# �λ���Ʈ ������ ���ؼ��� Ŭ������ �� ���� �ʿ�

member$cluster <- res$cluster
member

aggregate(data=member,spent~cluster,max)

#---------------------------------------------------------------

install.packages('NbClust')
library(NbClust)

# 4���� �̻��� �����Ϳ� ���ؼ��� �Ϲ����� �ð�ȭ�� �Ұ����ϱ� ������ 
# NbClust ��Ű�� Ȱ��

nb <- NbClust(iris[,1:4],min.nc = 2,max.nc = 5,method = 'kmeans')

# ��� �׸��� �� ������

nb$Best.partition

iris_scale <- scale(iris[,-5])
k.max=10
wss <- rep(NA,k.max)
nClust <- list()

for(i in 1:k.max){
  iris_res <- kmeans(iris_scale,centers=i)
  wss[i] <- iris_res$tot.withinss
  nClust[[i]] <- iris_res$size
}

wss
nClust

# elbow - point Ȯ���� ���� plot

plot(1:k.max,wss,type='b')

fitk <- kmeans(iris_scale,3)
str(fitk)

plot(iris,col=fitk$cluster)

table(predicted=fitk$cluster,Actual=iris$Species)

#------------------------------------------------------------------

# h-clustering

a <- matrix(rnorm(100),nrow=5) # 5�� 2�� ǥ�����Ժ��� ������

# 5���� �����͸� h-clustering�� Ȱ���Ͽ� ����ȭ

#hclust(�Ÿ����,method=�Ÿ� ���ϴ� ���,members=)

dist(a)

h <-hclust(dist(a),method = 'single')
# single : Ŭ�����Ͱ� ���� ����� ������ ������ �Ÿ�
plot(h)


#------------------------------------------------------------------

# knn - ���� ����� �Ÿ��� �ִ� k���� �����͸� �����Ͽ� ���̺� 

wbcd <- read.csv("C:/�ӽ�/RData/wisc_bc_data.csv",stringsAsFactors = F)

# �������� ���ؼ��� chr ���ٴ� ī�װ���(R������ factor) �� �ҷ����°��� �Ǵ�.
# stringsAsFactors�� ��� �����÷��� ���� �����ϹǷ� �������� ���� as.Type() ���� ����ó�� ������Ѵ�.

wbcd$diagnosis <- factor(wbcd$diagnosis,levels=c('B','M'),
       labels = c('Benign', 'Malignant'))

str(wbcd)

round(proportions(table(wbcd$diagnosis))*100,1)

wbcd[c('radius_mean','area_mean','smoothness_mean')]

wbcd <- wbcd[-1]

# ����ȭ

normalize <- function(x){
  return ((x-min(x))/(max(x)-min(x)))
}

normalize(c(1,2,3,4,5))

wbcd_n <- as.data.frame(lapply(wbcd[2:31],normalize))

wbcd_train <- wbcd_n[1:469,]
wbcd_test <- wbcd_n[470:569,]

wbcd_train_labels <- wbcd[1:469,1]
wbcd_test_labels <- wbcd[470:569,1]

library(class)

wbcd_test_pred <- knn(train=wbcd_train ,
                      test=wbcd_test ,
                      cl=wbcd_train_labels , k=21)

wbcd_test_pred

install.packages('gmodels')
library(gmodels)

CrossTable(x=wbcd_test_labels,y=wbcd_test_pred)


# ǥ��ȭ

wbcd_z <- as.data.frame(scale(wbcd[-1]))
wbcd_train <- wbcd_z[1:469,]
wbcd_test <- wbcd_z[470:569,]
wbcd_test_pred <- knn(train=wbcd_train ,
                      test=wbcd_test ,
                      cl=wbcd_train_labels , k=21)
CrossTable(x=wbcd_test_labels,y=wbcd_test_pred)

for(i in c(5,11,15,27)){
  cur_pred <- knn(train=wbcd_train ,
                        test=wbcd_test ,
                        cl=wbcd_train_labels , k=i)
  CrossTable(x=wbcd_test_labels,y=cur_pred)
}



predict.kmeans <- function(x, newdata){
  
}
data(iris)
mydata <- iris
m <- mydata[1:4]
train <- head(m,100)
xNew<- head(m,10)
xNew

norm_eucl <- function(train){
  print(train/apply(train,1,function(x)sum(x^2)^.5))

}

m_norm <- norm_eucl(train)













