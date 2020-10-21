library(readxl)
insurance <- read.csv('D:/R/rwork/R���������ͼ�/insurance.csv',stringsAsFactors=T)
str(insurance)

# ȸ�͸��� �������� ���Լ��� ���� Ȯ�κ���

# ���Ӻ��� ������ Ȯ��
summary(insurance$expenses)
hist(insurance$expenses)

# ���������� ���� ������ ����м�

cor(insurance[c('age','bmi','children','expenses')])

pairs(insurance[c('age','bmi','children','expenses')])

install.packages('psych')
library(psych)
pairs.panels(insurance[c('age','bmi','children','expenses')])

# lm �𵨿��� formula �ۼ� ��� => '���Ӻ��� ~ ��������'
# lm(expenses~����1+����2+����3+...,data=insurance)

ins_model <- lm(expenses~age+children+bmi+sex+smoker+region,data=insurance)
ins_model

summary(ins_model)

# Resuduals (���� : ������ ������ ���� ���)

# Coefficients
# Pr(>|t|) : ������ ����� ���� 0�� Ȯ�� ����ġ.
# p ���� ���� ��� �ش� Ư¡������ ���Ӻ����� ���谡 ���� ���ɼ��� ���� ���ٴ� �ǹ�.
# �����ʿ� *** ���� ǥ�õǴ� ������� ���� ������ �ǹ�

# Multiple R-squared (���� r ������) : ���� ���Ӻ��� ���� �󸶸�ŭ �� �����ϴ��� (1�� ����� ���� ���� �� �����ϰ� ������ ��Ÿ��)

str(ins_model)

temp <- data.frame(age=25,children=2,bmi=30,sex='female',smoker='yes',region='northeast')

predict(ins_model,newdata=temp)

insurance[1:10,-7]
write(insurance[1:10,-7],file='insmodeltest.csv',sep=',')
class(insurance[1:10,-7])

predict(ins_model,newdata=insurance[1:10,-7])
insurance[1:10,7]
