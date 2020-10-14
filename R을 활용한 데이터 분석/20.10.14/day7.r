library(readxl)

sms_raw <- read.csv('C:/�ӽ�/RData/sms_spam_ansi.txt')
str(sms_raw)

sms_raw$type <- factor(sms_raw$type)
str(sms_raw)

table(sms_raw$type) # 4812 hams 747 spams

# �쵵ǥ�� ������� -> �ܾ���� ��� �����ؾ��� 
#  -> tm��Ű�� -> Corpus ����

install.packages('tm')

library(tm)

tm::stopwords('en')

tm::removeWords('of so many people',stopwords('en'))

IMDB <- read.csv('C:/�ӽ�/RData/IMDB-Movie-Data.csv')

str(IMDB)

summary(IMDB)

sum(is.na(IMDB$Metascore))

colSums(is.na(IMDB))

IMDB2 <- na.omit(IMDB) # ��� ������ ���� ������ �ϳ��� ������ ����
colSums(is.na(IMDB2))

# Ư�� ������ �������� �ִ� ��츸 ���� �����ϰ��� �Ѵٸ�
IMDB3 <- IMDB[complete.cases(IMDB[,12]),]
colSums(is.na(IMDB3))

IMDB$Metascore[is.na(IMDB$Metascore)] <- 50

# �ش�ġ ���� : IQR RUle

# 1���� �� 
Q1 <- quantile(IMDB$Revenue..Millions.,probs=c(0.25),na.rm = T)
Q3 <- quantile(IMDB$Revenue..Millions.,probs=c(0.75),na.rm = T)
IQR <- Q3-Q1
LC <- Q1-(1.5*IQR)
UC <- Q3+(1.5*IQR)

# ������� ���� : subset
IMDB2 <-subset(IMDB, IMDB$Revenue..Millions.>LC&IMDB$Revenue..Millions.<UC)

# �κ� ���ڿ� ���� : substr
IMDB$Actors[1] # "Chris Pratt, Vin Diesel, Bradley Cooper, Zoe Saldana"
substr(IMDB$Actors[1],1,5) # �ε��� ? 

# ���ڿ� ���̱�
paste(IMDB$Actors[1],'_',"A")

# ���ڿ� ����
strsplit(IMDB$Actors[1],split=',')

# ���ڿ� ��ü
gsub(","," ",IMDB$Genre)
IMDB$Genre2 <-gsub(","," ",IMDB$Genre)


# ----------------------------
# ����Ʈ ���̴� 

CORPUS <- Corpus(VectorSource(IMDB$Genre2))

# Ư������ ���� , ���� , �ҹ��� ����
CORPUS_tm <- tm_map(CORPUS,removePunctuation) # Ư������ ����
tm_map(CORPUS_tm,removeNumbers) # ���� ����
tm_map(CORPUS_tm,tolower) # �ҹ��� ����

# DTM ����
DTM <- DocumentTermMatrix(CORPUS_tm)
DTM

inspect(DTM)

DTM <- as.data.frame(as.matrix(DTM))

IMDB_Genre <-cbind(IMDB,DTM)

IMDB$Description # �ܾ �ߺ��� ���� ����, ����, ��� �� ����

CORPUS <- Corpus(VectorSource(IMDB$Description))
CORPUS_tm <- tm_map(CORPUS,stripWhitespace) # ���鹮�� ����
CORPUS_tm <- tm_map(CORPUS_tm,removeNumbers) # �����ڹ��� ����
CORPUS_tm <- tm_map(CORPUS_tm,tolower) # �ҹ��� ����
CORPUS_tm <- tm_map(CORPUS_tm,removePunctuation) # ������ ����

DTM <- DocumentTermMatrix(CORPUS_tm)
inspect(DTM)

IMDB$Description[155]

CORPUS_tm <- tm_map(CORPUS_tm,removeWords,c(stopwords('en'),'my','custom','words'))

TDM <- TermDocumentMatrix(CORPUS_tm)
m <- as.matrix(TDM)

rowSums(m)

sort(rowSums(m),decreasing = T)
v <- sort(rowSums(m),decreasing = T)

names(v)
d <- data.frame(word=names(v),freq=v)

install.packages('SnowballC') # ��� ���� ��Ű��
library(SnowballC)

install.packages('wordcloud')
library(wordcloud)

install.packages('RColorBrewer')
library(RColorBrewer)

wordcloud(words=d$word, freq=d$freq , min.freq=5,
          max.words=200,random.order=F,
          colors=brewer.pal(8,'Dark2'))

library(tm)
sms_corpus <- VCorpus(VectorSource(sms_raw$text))
sms_corpus
inspect(sms_corpus)

as.character(sms_corpus[[1]])
lapply(sms_corpus[1:3],as.character)

sms_corpus_clean <- tm_map(sms_corpus,removeNumbers)
sms_corpus_clean <- tm_map(sms_corpus_clean,content_transformer(tolower))
sms_corpus_clean <- tm_map(sms_corpus_clean,removePunctuation)
sms_corpus_clean <- tm_map(sms_corpus_clean,removeWords,stopwords())

removePunctuation('hello..., ; : hihihi')


myreplace <- function(x){
  gsub("[[:punct:]]+"," ",x)
}
myreplace('hello...,..world')

library(SnowballC)
wordStem(c('learned','learn','learning','learns')) #1

tm_map(c('learned','learn','learning','learns'),stemDocument)

sms_corpus_clean <- tm_map(sms_corpus_clean,stemDocument)
sms_corpus_clean <- tm_map(sms_corpus_clean,stripWhitespace)

lapply(sms_corpus_clean[1:3],as.character)
lapply(sms_corpus[1:3],as.character)

sms_dtm <- DocumentTermMatrix(sms_corpus_clean)
inspect(sms_dtm)

#-----------������� ��ó��----------------------------------

# 1. train/test split
# 2. wordcloud �ð�ȭ (optional)

sms_train_labels <- sms_raw[1:4169,]$type # �н� ����
sms_test_labels <- sms_raw[4170:5559,]$type # ���� ����

sms_dtm_train <- sms_dtm[1:4169,]
sms_dtm_test <- sms_dtm[4170:5559,]

table(sms_train_labels)
prop.table(table(sms_test_labels))

#--Ʈ���̴� ������->�������� ���ͱ�-> �׽�Ʈ ������->
# �з� ���� ��

wordcloud(sms_corpus_clean,min.freq = 50,random.order = F)

spam <- subset(sms_raw,type=='spam')
ham <- subset(sms_raw,type=='ham')

wordcloud(spam$text , max.words = 40)
wordcloud(ham$text, max.words = 50)

install.packages('e1071')
library(e1071)

sms_dtm_freq_train <- removeSparseTerms(sms_dtm_train,0.999)
sms_dtm_freq_train
sms_dtm_train

sms_freq_words <- findFreqTerms(sms_dtm_train,5)
str(sms_freq_words) # ���� ���� , 1151�� �ܾ� ���� 

sms_dtm_freq_train<- sms_dtm_train[,sms_freq_words]
sms_dtm_freq_test<- sms_dtm_test[,sms_freq_words]

# ���̺꺣���� �з���� ������ �����Ϳ� ���� �Ʒ��ϵ��� �Ǿ�����
# ���� ������(�ܾ�Ƚ��,����)-> ������ ��ȯ
# ���� ���� 1 �̻� -> YES , �ƴϸ� -> NO

inspect(sms_dtm_freq_train)

convertCounts <- function(x){
  x<-ifelse(x>0,'YES','NO')
}

sms_train <- apply(sms_dtm_freq_train, MARGIN = 2, convertCounts)
sms_train

sms_test <- apply(sms_dtm_freq_test, MARGIN = 2, convertCounts)

sms_train[,1]
str(sms_train)

sms_Classifier <- naiveBayes(sms_train,sms_train_labels,laplace = 1)

sms_test_pred <- predict(sms_Classifier,sms_test)

library(gmodels)

CrossTable(sms_test_pred,sms_test_labels,
           dnn=c('predicted','actual'))
print((1189+166)/1390)

#���� ��������
#���ο� �̸��� ���� -> 'free cash..club' -> ��/���� ? (smsClassifier)
#sms_Classifier <- naiveBayes(sms_train,sms_train_labels,laplace = 1)