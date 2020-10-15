# credits.csv - ���� ���� ����?

library(readxl)
library(dplyr)

credit <- read.csv('C:/�ӽ�/RData/credit.csv')
str(credit)

table(credit$checking_balance) # ���� �ܰ�
#< 0 DM   > 200 DM 1 - 200 DM    unknown 
# 274         63        269        394 

table(credit$savings_balance) # ���� �ܰ�
#< 100 DM     > 1000 DM  100 - 500 DM 500 - 1000 DM       unknown 
# 603            48           103            63           183

summary(credit$months_loan_duration) # ����Ⱓ 4���� ~ 72����
summary(credit$amount) # ����� 250 ~ 18424 , �߾Ӱ�2320 , Mean3271

table(credit$default) # no 700 , yes 300

# �Ʒ�:���� = 9:1
set.seed(123) # ���� ���ø�
sample(10,5)

trainSample <- sample(1000,900)
str(trainSample)

str(credit)

creditTrain <- credit[trainSample,]
creditTest <- credit[-trainSample,]

table(creditTrain$default)
table(creditTest$default)

install.packages('C50')
library(C50)

