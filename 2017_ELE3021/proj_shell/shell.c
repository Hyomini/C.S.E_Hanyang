#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>
#define MAX_STR_SIZE 100
#define num 10
#include <signal.h>

void execute(char* command);

int main(int argc, char* argv[]){
    char command[MAX_STR_SIZE];// 프롬프트창에서 받는 명령어
    int k=0;
    char *buf;//batch mode때 파일 이름을 저장할 버퍼
    char *ptr;
    char *real_buf[20];
    FILE *fp;
    long f_size;
    sigset_t blockset;
    sigemptyset(&blockset);
    sigaddset(&blockset, SIGINT);//ctrl+c로 종료하지 못하게 막음
    sigprocmask(SIG_BLOCK, &blockset, NULL);

if(argc == 1){//interactive mode
    while(1){
        printf("prompt>");

        fgets(command, MAX_STR_SIZE, stdin);
        command[strlen(command)-1] = '\0';
      
        if(feof(stdin)){
           printf("\n");
           exit(0);
        }//ctrl+d로 종료
        execute(command);
        fflush(stdin);
    }
return 0;
}
/*batch mode*/
else{
    fp = fopen(argv[1],"r");
    if(fp == NULL){
        fputs("File error",stderr);
    }
    fseek(fp, 0, SEEK_END); 
    f_size = ftell(fp);
    rewind(fp);
    
    buf = (char*)malloc(sizeof(char)*f_size);
    while(fgets(buf,f_size,fp)){
        buf[strlen(buf)-1] = '\0';
        printf("%s\n", buf);    
        execute(buf);
    } 
   
    return 0;
}
}
/*프롬프트에서 받은 명령어를 실행하는 함수*/
void execute(char* command)
{
    int status;
    int pidnum=0;
    pid_t pid[num];
    pid_t child_pid;
    char *ptr;
    int count=1;
    char *each[num];
    int i=0;
    int j=0;
    char *order[num];
    int index=0;

    ptr = strtok(command, ";");
    if(strcmp("quit", ptr) == 0)//quit이 입력되었을때 종료
        exit(0);
    else{
        each[i++] = ptr;
        while(ptr = strtok(NULL, ";")){
            each[i++] = ptr;
        }
         
        //토큰 잘라서 each에 저장
        
        index = i-1;
       
        for(index;index>=0;index--){
            ptr = strtok(each[index]," ");
            order[j++] = ptr;
            while(ptr=strtok(NULL," ")){
                order[j++] = ptr;
            }
            order[j] = (char*)0;
            j = 0;
            if((pid[pidnum] = fork())<0){
                perror("fork error");
                pidnum++;
            }
            else if(pid[pidnum] == 0){
          
            execvp(order[0],order);
            pidnum++;
            }
            else
                child_pid = wait(&status);
            
          
        }//make process
       
    }
}
