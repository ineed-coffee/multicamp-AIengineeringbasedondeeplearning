library(readxl)

groceries <- read.csv('C:/�ӽ�/RData/groceries.csv')

str(groceries)

install.packages('arules')
library(arules)
groceries <- read.transactions('C:/�ӽ�/RData/groceries.csv',sep=",")
summary(groceries)

itemFrequency(groceries[,1:10])
# itemFrequency �Լ��� �ŷ� ������ Ȯ�� : Suppory(������)

itemFrequencyPlot(groceries,support=0.08)
itemFrequencyPlot(groceries,topN=20)

image(groceries[1:5])

groceryRules <- apriori(groceries,
                        parameter=list(support=0.005,
                                       confidence=0.25,
                                       minlen=2))
# minlen : x->y �� ������Ģ���� �������� minlen �̸��� �͵���
# ������� ������
summary(groceryRules)

inspect(groceryRules[1:5])

inspect(sort(groceryRules, by='lift',decreasing=FALSE)[1:5])


# ���������� berries ��ǰ�� �Բ� ��󵵰� ���� ��ǰ���� �����ϰ����Ѵ�.
berryRules <- subset(groceryRules,items %in% 'berries')

write(berryRules,file='berryRules.csv',sep=',',row.names=F)

install.packages('arules')
install.packages('C50')
install.packages('tm')
install.packages('SnoballC')
install.packages('wordcloud')
install.packages('RColorBrewer')
install.packages('e1071')
