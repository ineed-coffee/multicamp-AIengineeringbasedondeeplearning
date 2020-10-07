library(dplyr)
library(readxl)
library(ggplot2)
library(foreign)

raw_welfare <- read.spss(file='./R���������ͼ�/Koweps_hpc10_2015_beta1.sav',to.data.frame=TRUE)
welfare <- raw_welfare # ���纻

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

# ���ɴ�� ����� young(<30) , middle(<60) , old(>=60)
welfare <- welfare %>% mutate(age=2015-birth+1)
welfare <- welfare %>% mutate(ageg=ifelse(age<30,'young',ifelse(age<60,'middle','old')))

region_list <- data.frame(code_region=c(1,2,3,4,5,6,7),
                          region_name=c('����','��õ/���','�λ�/�泲/���',
                                        '�뱸/���','����/�泲','����/���',
                                        '����/����/����/���ֵ�'))
welfare <- left_join(welfare,region_list,id=code_region)
#-------------------------------------------------------------------------------

# 1. ������ ����(��) ������ ���� �� �ð�ȭ �м�
# ������  : young/middle/old ����

region_ageg_group <- welfare %>% group_by(region_name,ageg) %>% 
  summarise(cnt=n()) %>% 
  mutate(tot_cnt=sum(cnt)) %>% 
  mutate(pct=round(cnt/tot_cnt*100,1))

ggplot(data=region_ageg_group,aes(x=region_name,y=pct,fill=ageg))+
  geom_col(position = position_dodge2())+
  coord_flip()

#-------------------------------------------------------------------------------

# 2. mpg �����͸� �̿��ؼ� �м� ������ �ذ� 
# �Ʒ� �ڵ带 �����Ͽ� �ټ� ���� hwy ������ NA�� �Ҵ�
# mpg <- as.data.frame(ggplot2::mpg) # mpg ������ �ҷ����� 
# mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA # NA �Ҵ��ϱ�

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA

# Q1. drv(�������)���� hwy(��ӵ��� ����) ����� ��� �ٸ��� �˾ƺ����� �մϴ�. 
# �м��� �ϱ� ���� �켱 �� ������ ����ġ�� �ִ��� Ȯ���ؾ� �մϴ�. 
# drv ������ hwy ������ ����ġ�� �� �� �ִ��� �˾ƺ�����.

table(is.na(mpg$drv)) # ����ġ X
table(is.na(mpg$hwy)) # ����ġ 5

# Q2. filter()�� �̿��� hwy ������ ����ġ�� �����ϰ�, � ��������� hwy ����� ������ �˾ƺ�����. 
# �ϳ��� dplyr �������� ������ �մϴ�.

mpg %>% filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean=mean(hwy))
# 4:19.2 , f:28.2 , r:21

#-------------------------------------------------------------------------------

# 3. mpg �����͸� �ҷ��ͼ� �Ϻη� �̻�ġ�� ����ڽ��ϴ�. 
# drv(�������) ������ ���� 4(�������), f(��������), r(�ķ�����) �� ������ �Ǿ��ֽ��ϴ�. 
# �� ���� �࿡ ������ �� ���� �� k�� �Ҵ��ϰڽ��ϴ�. 
# cty(���� ����) ������ �� ���� �࿡ �ش������� ũ�ų� ���� ���� �Ҵ��ϰڽ��ϴ�.
# mpg <- as.data.frame(ggplot2::mpg) # mpg ������ �ҷ����� 
# mpg[c(10, 14, 58, 93), "drv"] <- "k" # drv �̻�ġ �Ҵ� 
# mpg[c(29, 43, 129, 203), "cty"] <- c(3, 4, 39, 42) # cty �̻�ġ �Ҵ�
# �̻�ġ�� ����ִ� mpg �����͸� Ȱ���ؼ� ������ �ذ��غ�����.
# ������ĺ��� ���� ���� �ٸ��� �˾ƺ����� �մϴ�. 
# �м��� �Ϸ��� �켱 �� ������ �̻�ġ�� �ִ��� Ȯ���Ϸ��� �մϴ�.

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(10, 14, 58, 93), "drv"] <- "k"
mpg[c(29, 43, 129, 203), "cty"] <- c(3, 4, 39, 42)

# Q1. drv�� �̻�ġ�� �ִ��� Ȯ���ϼ���. �̻�ġ�� ���� ó���� ���� �̻�ġ�� ��������� Ȯ���ϼ���. 
# ���� ó�� �� ���� %in% ��ȣ�� Ȱ���ϼ���. 

mpg$drv[!mpg$drv %in% c(4,'f','r')] = NA
table(mpg$drv) # 4:100, f:106 , r:24

# Q2. ���� �׸��� �̿��ؼ� cty�� �̻�ġ�� �ִ��� Ȯ���ϼ���. 
# ���� �׸��� ���ġ�� �̿��� ���� ������ ��� ���� ���� ó���� �� �ٽ� ���� �׸��� ����� �̻�ġ�� ��������� Ȯ���ϼ���.

boxplot(mpg$cty) # 8��
stats <- boxplot(mpg$cty)$stats
mpg$cty[mpg$cty>stats[5] | mpg$cty<stats[1]] <- NA
boxplot(mpg$cty) # 0��

# Q3. �� ������ �̻�ġ�� ����ó�� ������ ���� �м��� �����Դϴ�. 
# �̻�ġ�� ������ ���� drv���� cty ����� ��� �ٸ��� �˾ƺ�����. �ϳ��� dplyr �������� ������ �մϴ�.

mpg %>% filter(!is.na(cty) & !is.na(drv)) %>% 
  group_by(drv) %>% 
  summarise(mean=mean(cty))
# 4:14.2 , f:19.5 , r:14

#-------------------------------------------------------------------------------