from konlpy.tag import Okt
import time
import math

start_time = time.time()
twitter = Okt()
list_tag = ['Punctuation', 'Foreign', 'KoreanParticle', 'Exclamation', 'Noun', 'Verb', 'Adjective']


def read_data(filename):
    with open(filename, 'r', encoding='UTF8') as f:
        data = [line.split('\t') for line in f.read().splitlines()]
    return data


def naivebayes_classifier(filename, tokenSet, count_pos, count_neg):
    pro_pos = 0
    pro_neg = 0
    test_data = read_data(filename)
    fp = open("ratings_result.txt", 'w', encoding='UTF8')
    fp.write(test_data[0][0]+'\t'+test_data[0][1]+'\t'+test_data[0][2]+'\n')
    for row in test_data[1:]:
        pro_neg = 0
        pro_pos = 0
        line = twitter.pos(row[1])
        for token in line:
            if token[0] in tokenSet:
                pro_pos += math.log(tokenSet[token[0]][1])  # 언더플로우 방지
                pro_neg += math.log(tokenSet[token[0]][0])
            elif token[0] not in tokenSet:
                tokenSet[token[0]] = [1/count_neg, 1/count_pos]
                pro_pos += math.log(tokenSet[token[0]][1])
                pro_neg += math.log(tokenSet[token[0]][0])
        if math.exp(pro_pos) >= math.exp(pro_neg):
            fp.write(row[0]+'\t'+row[1]+'\t'+"1\n")
        elif math.exp(pro_pos) < math.exp(pro_neg):
            fp.write(row[0]+'\t'+row[1]+'\t'+"0\n")


train_data = read_data("ratings_train.txt")
tokenSet = dict()
count_pos = 0
pos_token = list()
count_neg = 0
neg_token = list()
flag = 0

# 형태소 분류 및 형태소별 빈도계산과 긍정문 부정문 개수
for row in train_data[1:]:
    line = twitter.pos(row[1])
    for token in line:  # token의 형태는 ["name", "kind"]
        if token[1] in list_tag:  # token의 종류가 태깅목록에 있을 때
            if token[0] not in tokenSet:  # 딕셔너리 안에 토큰이 존재하지 않을 떄
                tokenSet[token[0]] = [0, 0]
                if row[2] == '0':  # 부정
                    tokenSet[token[0]][0] += 1
                    pos_token.append(token[0])
                elif row[2] == '1':  # 긍정
                    tokenSet[token[0]][1] += 1
                    neg_token.append(token[0])
                continue
            elif token[0] in tokenSet:  # 딕셔너리에 해당 토큰이 이미 존재할 때
                if row[2] == '0':
                    tokenSet[token[0]][0] += 1
                    pos_token.append(token[0])
                elif row[2] == '1':
                    tokenSet[token[0]][1] += 1
                    neg_token.append(token[0])

count_pos = len(pos_token) + len(tokenSet)  # 전체 긍정 토큰의 개수와 중복을 제외한 긍정토큰의 개수의 합
count_neg = len(neg_token) + len(tokenSet)
# 형태소별 확률계산
for x in tokenSet.keys():
    tokenSet[x][1] += 1
    tokenSet[x][0] += 1
    tokenSet[x][1] /= count_pos
    tokenSet[x][0] /= count_neg
print(tokenSet)
print("--- %s seconds ---" % (time.time() - start_time))
naivebayes_classifier("ratings_test.txt", tokenSet, count_pos, count_neg)