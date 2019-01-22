간단한 사용법입니다.

먼저 주어진 파일들 "chatcli", "chatser"을 서로 다른 터미널에서 실행시킵니다.
그리고 "chatcli"실행파일에서 서버의 아이피주소와 포트넘버를 입력하면 두 프로그램간에 클라이언트 프로그램에서 입력한 메시지가 서버 프로그램에서 풀력됩니다

다음과 같은 명령어들을 통해 컴파일을 할 수 있습니다.
gcc -o "name1" chatcli.c -pthread 
gcc -o "name2" chatser.c -pthread
