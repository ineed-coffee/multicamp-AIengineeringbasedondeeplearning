# __Naive Bayes' Law__ 

- 베이지안 분류기를 만드는데 활용되는 알고리즘으로 결과에 대한 전체확률(ex.스팸확률)을 알기 위해 동시에 여러가지 속성에 대한 정보를 고려해야하는 문제에 사용 적절
- 베이지안 확률(Likelihood)? : 여러번의 시행(trials,사건이 발생할 수 있도록 하는 시도)에서 사용할 수 있는 증거를 기반으로 추정한다.

|     시행      |       사건       |
| :-----------: | :--------------: |
|  동전 던지기  |    앞면 결과     |
| 이메일을 받음 | 반은 메일이 스팸 |
|   로또 구매   |    로또 당청     |

 

__확률?__ 

- `사전 확률(prior prob)`  : 받은 메세지의 내용을 모르는 상태에서 , 메세지의 스팸 상태를 가장 잘 예측하는 방법은? -> 이전에 메시지가 스팸일 확률이 20% 였던것을 활용하는것

- `사건 확률(prob)` : 관측 데이터에서 사건이 발생한 시행 횟수를 전체 시행 횟수로 나눔
  - ex.) P(비) = 0.3 , P(로또 당첨) = 0.000000001
- `우도(likelihood)` : '나이트'라는 단어가 나타났던 빈도를  관측하려면 이전에 받았던 이메일 정보를 살펴보면 알 수 있음. 이전 스펨 메세지에서 '나이트' 단어가 사용된 확룰 : P(나이트|스펨) - 우도
- '나이트' 라는 단어가 어떤 메일 제목에도 나타날 확률 : P(나이트) -주변 우도
- `사후 확률 (posterior prob)` : 메세지가 스팸이 될 확률을 측정
  - 사후확률 = 우도 * 사전확률 / 주변우도
  - ex.) P(스팸|나이트) = P(나이트|스펨)*P(스팸) / P(나이트)



__라플라스 추정치__ 

- 우도 계산에 있어 특정 사건의 조건부 확률 항목이 0 이라 전체가 0으로 추정되는 오류를 없애기 위한 방법
- 각 조건부 계산에 있어 분자 부분에 +α 의 바이어스 추가해서 계산
- 

