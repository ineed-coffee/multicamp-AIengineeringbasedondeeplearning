library(ggplot2)
library(dplyr)

df <- data.frame(gender=c('m','f',NA,'m','f'),
                 score=c(5,4,3,4,NA))
df
is.na(df)
table(is.na(df))
mean(df$score) # R������ �������� ������ ����� �ȵʵ�

# R���� ������ ó��
df_new <-df %>% 
  filter(!is.na(score))
mean(df_new$score)

# R���� drop (�����)
na.omit(df)
mean(df$score,na.rm=T)


# R���� indexing : �Ǵٽ��� �ٸ��� ��-�� ������ ����
exam = read.csv('./R���������ͼ�/csv_exam.csv')
exam[c(3,8,15),'math'] <- NA # ���� ������ �迭�� ����

exam %>% 
  summarise(meanm=mean(math,na.rm=T))

exam$math
#����1 : math �������� ��հ����� ��ü

exam$math[is.na(exam$math)] <- mean(exam$math,na.rm=T)

# R���� outlier ����
ol<-data.frame(gen=c(1,2,1,2,3),
           score=c(5,4,1,3,4))
ol
table(ol)

# ������ �̻�ġ - ������ ���� - ����
ol$gen <- ifelse(ol$gen==3,NA,ol$gen)

# ������ �̻�ġ - ������� ���� �� ���� ���� - ����
ol$score <- ifelse(ol$score>4,NA,ol$score)

ol

# R �м�
ol %>% 
  filter(!is.na(gen) & !is.na(score)) %>% 
  group_by(gen) %>% 
  summarise(ms=mean(score))

# ��������ó�� -> �ӽŷ���/������

# ������� : ����(�����) �Ǵ� �ٰ�
# ����? : ���� �����Դ� 40~150kg
# �����? : ������ ������ 0.3% �ش�ġ (IQR*1.5)
mpg = ggplot2::mpg
boxplot(mpg$hwy)
boxplot(mpg$hwy)$stats

# �ѱ��� ���� �� �м� : koweps ������
install.packages('foreign')
library(foreign)
library(readxl)

raw_welfare <- read.spss(file='./R���������ͼ�/Koweps_hpc10_2015_beta1.sav',to.data.frame=TRUE)
welfare <- raw_welfare # ���纻
head(welfare,1)
View(welfare)
dim(welfare)

# ������ �м��� �ʿ��� �÷��� 
welfare<-rename(welfare, 
                sex=h10_g3,
                birth=h10_g4,
                marriage=h10_g10,
                religion=h10_g11,
                income=p1002_8aq1,
                code_job=h10_eco9,
                code_region=h10_reg7
)
welfare

table(welfare$sex)
welfare$sex <- ifelse(welfare$sex==1,'male','female')
qplot(welfare$income)

# ��������
qplot(welfare$income)+xlim(0,1000)

welfare$income <- ifelse(welfare$income %in% c(0,5000),NA,welfare$income)
table(is.na(welfare$income))

# na �� �ƴ� �����Ϳ� ���� ������ ���� �޿� ��� ����

sex_income <- welfare %>% filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income = mean(income))

sex_income

ggplot(data=sex_income , aes(x=sex,y=mean_income))+geom_col()

summary(welfare$birth)

table(is.na(welfare$birth))

welfare <- welfare %>% mutate(age=2015-birth+1)
summary(welfare$age)
qplot(welfare$age)

# ���̿� ���� �޿� ���
age_income <- welfare %>% filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(meanincome = mean(income))

ggplot(data=age_income , aes(x=age,y=meanincome))+geom_col()
ggplot(data=age_income , aes(x=age,y=meanincome))+geom_line()

# ���ɴ�� ����� young(<30) , middle(<60) , old(>=60)

welfare <- welfare %>% mutate(ageg=ifelse(age<30,'young',ifelse(age<60,'middle','old')))

# ���� ���к� ���� ��� 
ageg_income <- welfare %>% group_by(ageg) %>% 
  summarise(mean_ageg_income = mean(income,na.rm=T))

# plot + ����
ggplot(data=ageg_income , aes(x=ageg,y=mean_ageg_income))+geom_col()+
  scale_x_discrete(limits=c('young','middle','old'))

sex_income_ageg = welfare %>% group_by(ageg,sex) %>% 
  summarise(mean=mean(income,na.rm = T))

sex_income_age = welfare %>% group_by(age,sex) %>% 
  summarise(mean=mean(income,na.rm = T))

ggplot(data=sex_income_ageg , aes(x=ageg,y=mean,fill=sex))+geom_col(position = 'dodge')+
  scale_x_discrete(limits=c('young','middle','old'))

# �������� ���� �޿� ��

list_job <- read_excel('./R���������ͼ�/Koweps_Codebook.xlsx',col_names=T,sheet=2)
welfare <- left_join(welfare,list_job,id="code_job")

welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job,job)

# ���� 4 : ������ ���� ��� ���

job_income <- welfare %>% filter(!is.na(job)) %>% 
  group_by(job) %>% 
  summarise(mean=mean(income,na.rm = T))

top20 <- job_income %>% 
  arrange(desc(mean)) %>% 
  head(20)

ggplot(data=top20,aes(x=job,y=mean))+geom_col()+coord_flip()

bottom10 <- job_income %>% 
  arrange(mean) %>% 
  head(10)

ggplot(data=bottom10,aes(x=job,y=mean))+geom_col()+coord_flip()


# ���� 5 ���� ���� �� ���� 10�� ���

job_male <- welfare %>% filter(sex=='male' & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(cnt=n()) %>% 
  arrange(desc(cnt)) %>% 
  head(10)

job_female <- welfare %>% filter(sex=='female' & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(cnt=n()) %>% 
  arrange(desc(cnt)) %>% 
  head(10)

# ������ �ִ� �縲�� ��ȥ�� ��/���ұ�

table(welfare$religion)
welfare$religion <- ifelse(welfare$religion==1,'Yes','No')
qplot(welfare$religion)

# ��ȥ ���� ���� ����

welfare$group_marriage <- ifelse(welfare$marriage==1,'marriage',
                                 ifelse(welfare$marriage==3,'divorce',NA))
table(welfare$group_marriage)
qplot(welfare$group_marriage)

religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion,group_marriage) %>% 
  summarise(cnt=n()) %>% 
  mutate(tot_group=sum(cnt)) %>%
  mutate(pct = round(cnt/tot_group*100,1))

divorce <- religion_marriage %>% 
  filter(group_marriage=='divorce') %>% 
  select(religion,pct)

divorce
