import heapq

# output.txt 파일 생성
def output(size, path, start, goal, file, length, time):
    background = [[1 for cols in range(size)]for rows in range(size)] #1로 채운 파일생성
    for n in range(len(path)):
        x = path[n]//1000
        y = path[n]%1000
        background[x][y] = 5

    x = start//1000
    y = start%1000
    background[x][y] = 3

    x = goal//1000
    y = goal%1000
    background[x][y] = 4
    for x in range(size):
        file.write(' '.join(map(str, background[x])))
        file.write('\n')

    file.write("---\n")
    file.write("length=")
    file.write(str(length))
    file.write('\n')
    file.write("time=")
    file.write(str(time))
    file.write('\n')

# 입력된 노드의 이웃노드 검사
def findNeighbor(data, x, y, nodes, m):
    neighbor = list()
    if data[x][y] == '2' or data[x][y] == '3' or data[x][y] == '4' or data[x][y] == '6':
        hash = x*1000+y # 해당 노드의 해시
        # 검사한 노드의 상하좌우가 벽이 아닌지 검사한 후에 이웃노드로 설정
        if x + 1 <= m - 1 and (data[x + 1][y] == '2' or data[x + 1][y] == '3' or data[x + 1][y] == '4' or data[x + 1][y] == '6'):  # 아래
            down_node = (x+1)*1000+y
            neighbor.append(down_node)
        if x - 1 >= 0 and (data[x - 1][y] == '2' or data[x - 1][y] == '3' or data[x - 1][y] == '4' or data[x - 1][y] == '6'):  # 위
            up_node = (x-1)*1000+y
            neighbor.append(up_node)
        if y + 1 <= m - 1 and (data[x][y + 1] == '2' or data[x][y + 1] == '3' or data[x][y + 1] == '4' or data[x][y + 1] == '6'):  # 오른쪽
            right_node = x*1000+y+1
            neighbor.append(right_node)
        if y - 1 >= 0 and (data[x][y - 1] == '2' or data[x][y - 1] == '3' or data[x][y - 1] == '4' or data[x][y - 1] == '6'):  # 왼쪽
            left_node = x*1000+y-1
            neighbor.append(left_node)

        nodes[hash] = set(neighbor)


def bfs(start, goal, nodes):
    queue = [(start, [start])]
    k = 0

    while queue:
        n, path = queue.pop(0)
        k+=1
        if n == goal:
            print("time:",k)
            return path
        else:
            for m in nodes[n] - set(path):
                queue.append((m,path+[m]))



def greedy(start, goal, nodes, keys):
    distance = {} # 목표지점과의 거리를 저장한 딕셔너리
    for n in range(len(keys)):
        x = keys[n]//1000
        y = keys[n]%1000
        distance[keys[n]] = pow(goal//1000 - x,2) + pow(goal%1000 - y,2)


    queue = [(distance[start], start, [start])]
    k = 0
    w = 0 # weight를 받는 변수
    while queue:
        w, n, path = heapq.heappop(queue)
        k += 1
        if n == goal:
            return path, k  # 경로와 탐색노드수 즉 time을 반환
        else:
            for m in nodes[n] - set(path):
                heapq.heappush(queue,(distance[m], m, path + [m]))


def first_floor():
    # 딕셔너리 형태로 노드간 관계 표현
    nodes = {}

    # 텍스트 파일 데이터 2차원 리스트 data에 삽입
    with open("first_floor.txt", 'r') as file:
        temp = list()
        line = file.readline()
        i = 0
        while line != '':
            line = file.readline()
            temp.append(line)
            i += 1

    m = len(temp[1].split()) # m은 미로의 행 또는 열의 크기

    data = [[0 for i in range(m)] for j in range(m)] # 노드 임시저장소

    for x in range(m):
        data[x] = temp[x].split()

    for x in range(m):
        for y in range(m):
            findNeighbor(data, x, y, nodes, m)
    for x in range(m):
        for y in range(m):
            if (data[x][y] == '6'):
                key = x*1000+y
            if (data[x][y] == '4'):
                goal = x*1000+y
            if (data[x][y] == '3'):
                start = x*1000+y
    # 해시값 모음
    keys = list(nodes.keys())

    print("first_floor")
    result1, time1 = greedy(start, key, nodes, keys)
    result2, time2 = greedy(key, goal, nodes, keys)
    length = len(result1) + len(result2) - 2 # 시작노드를 길이에서 제거, 키를 두번 탐색하기 때문에 한 번 제거 총 2개제거
    print("length =", length)
    result3 = set(result1) | set(result2)
    time3 = time1 + time2
    print("time =", time3, '\n')

    f = open("first_floor_output.txt", 'w')

    output(m, list(result3), start, goal, f, length, time3)


def second_floor():
    # 딕셔너리 형태로 노드간 관계 표현
    nodes = {}

    # 텍스트 파일 데이터 2차원 리스트 data에 삽입
    with open("second_floor.txt", 'r') as file:
        temp = list()
        line = file.readline()
        i = 0
        while line != '':
            line = file.readline()
            temp.append(line)
            i += 1

    m = len(temp[1].split())  # m은 미로의 행 또는 열의 크기

    data = [[0 for i in range(m)] for j in range(m)]  # 노드 임시저장소

    for x in range(m):
        data[x] = temp[x].split()

    for x in range(m):
        for y in range(m):
            findNeighbor(data, x, y, nodes, m)
    for x in range(m):
        for y in range(m):
            if (data[x][y] == '6'):
                key = x*1000+y
            if (data[x][y] == '4'):
                goal = x*1000+y
            if (data[x][y] == '3'):
                start = x*1000+y
    # 해시값 모음
    keys = list(nodes.keys())

    print("second_floor")
    result1, time1 = greedy(start, key, nodes, keys)
    result2, time2 = greedy(key, goal, nodes, keys)
    length = len(result1) + len(result2) - 2
    print("length =", length)
    result3 = set(result1) | set(result2)
    time3 = time1 + time2
    print("time =", time3, '\n')

    f = open("second_floor_output.txt", 'w')

    output(m, list(result3), start, goal, f, length, time3)

def third_floor():
    # 딕셔너리 형태로 노드간 관계 표현
    nodes = {}

    # 텍스트 파일 데이터 2차원 리스트 data에 삽입
    with open("third_floor.txt", 'r') as file:
        temp = list()
        line = file.readline()
        i = 0
        while line != '':
            line = file.readline()
            temp.append(line)
            i += 1

    m = len(temp[1].split())  # m은 미로의 행 또는 열의 크기

    data = [[0 for i in range(m)] for j in range(m)]  # 노드 임시저장소

    for x in range(m):
        data[x] = temp[x].split()

    for x in range(m):
        for y in range(m):
            findNeighbor(data, x, y, nodes, m)
    for x in range(m):
        for y in range(m):
            if (data[x][y] == '6'):
                key = x*1000+y
            if (data[x][y] == '4'):
                goal = x*1000+y
            if (data[x][y] == '3'):
                start = x*1000+y
    # 해시값 모음
    keys = list(nodes.keys())

    print("third_floor")
    result1, time1 = greedy(start, key, nodes, keys)
    result2, time2 = greedy(key, goal, nodes, keys)
    length = len(result1) + len(result2) - 2
    print("length =", length)
    result3 = set(result1) | set(result2)
    time3 = time1 + time2
    print("time =", time3, '\n')

    f = open("third_floor_output.txt", 'w')

    output(m, list(result3), start, goal, f, length, time3)

def fourth_floor():
    # 딕셔너리 형태로 노드간 관계 표현
    nodes = {}

    # 텍스트 파일 데이터 2차원 리스트 data에 삽입
    with open("fourth_floor.txt", 'r') as file:
        temp = list()
        line = file.readline()
        i = 0
        while line != '':
            line = file.readline()
            temp.append(line)
            i += 1

    m = len(temp[1].split())  # m은 미로의 행 또는 열의 크기

    data = [[0 for i in range(m)] for j in range(m)]  # 노드 임시저장소

    for x in range(m):
        data[x] = temp[x].split()

    for x in range(m):
        for y in range(m):
            findNeighbor(data, x, y, nodes, m)
    for x in range(m):
        for y in range(m):
            if (data[x][y] == '6'):
                key = x*1000+y
            if (data[x][y] == '4'):
                goal = x*1000+y
            if (data[x][y] == '3'):
                start = x*1000+y
    # 해시값 모음
    keys = list(nodes.keys())

    print("fourth_floor")
    result1, time1 = greedy(start, key, nodes, keys)
    result2, time2 = greedy(key, goal, nodes, keys)
    length = len(result1) + len(result2) - 2
    print("length =", length)
    result3 = set(result1) | set(result2)
    time3 = time1 + time2
    print("time =", time3, '\n')

    f = open("fourth_floor_output.txt", 'w')

    output(m, list(result3), start, goal, f, length, time3)

def fifth_floor():
    # 딕셔너리 형태로 노드간 관계 표현
    nodes = {}

    # 텍스트 파일 데이터 2차원 리스트 data에 삽입
    with open("fifth_floor.txt", 'r') as file:
        temp = list()
        line = file.readline()
        i = 0
        while line != '':
            line = file.readline()
            temp.append(line)
            i += 1

    m = len(temp[1].split())  # m은 미로의 행 또는 열의 크기

    data = [[0 for i in range(m)] for j in range(m)]  # 노드 임시저장소

    for x in range(m):
        data[x] = temp[x].split()

    for x in range(m):
        for y in range(m):
            findNeighbor(data, x, y, nodes, m)
    for x in range(m):
        for y in range(m):
            if (data[x][y] == '6'):
                key = x*1000+y
            if (data[x][y] == '4'):
                goal = x*1000+y
            if (data[x][y] == '3'):
                start = x*1000+y
    # 해시값 모음
    keys = list(nodes.keys())

    print("fifth_floor")
    result1, time1 = greedy(start, key, nodes, keys)
    result2, time2 = greedy(key, goal, nodes, keys)
    length = len(result1) + len(result2) - 2
    print("length =", length)
    result3 = set(result1) | set(result2)
    time3 = time1 + time2
    print("time =", time3)

    f = open("fifth_floor_output.txt", 'w')

    output(m, list(result3), start, goal, f, length, time3)


# 함수 실행 부분
first_floor()
second_floor()
third_floor()
fourth_floor()
fifth_floor()