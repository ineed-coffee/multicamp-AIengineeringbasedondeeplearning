iris
str(iris)

y = rnorm(100) # ���� ���� ���� ������
hist(y)

x <- matrix(rnorm(100),nrow = 5)
dist(x)
dist(x, method = 'manhattan')

data(iris) # data �Լ� : �����͸� �ε��ϴ� �Լ�

iris[,-5] # ������ 5�� ���� ������??
iris

kmeans.iris <-kmeans(iris[,-5],3)
kmeans.iris$centers
kmeans.iris$cluster

table(iris[,5],kmeans.iris$cluster)

kmeans.iris <-kmeans(iris[,-5],3,nstart = 100)

table(iris[,5],kmeans.iris$cluster)

kmeans.iris$withinss
round(sum(kmeans.iris$withinss),2)
library(ggplot2)
ggplot(data=iris,aes(x=Petal.Length , y = Petal.Width , colours=Species))+
  geom_point(shape=19,size=4)+
  ggtitle('iris data')

iris_plot <- ggplot(data=iris,aes(x=Petal.Length , y = Petal.Width , colour=Species))+
  geom_point(shape=19,size=4)+
  ggtitle('iris data')

iris_plot2 <- iris_plot+
  annotate('text',x=1.5,y=0.7,label='Setosa',size=5)+
  annotate('text',x=3.5,y=1.5,label='Veriscolor',size=5)+
  annotate('text',x=6,y=2.7,label='Virginica',size=5)

centers <- kmeans.iris$centers

centers[1,c(1,2,3)]

iris_plot2+
  annotate('point',x=)