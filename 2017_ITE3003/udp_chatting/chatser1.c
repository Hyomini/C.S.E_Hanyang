#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<string.h>
#include<pthread.h>
#include<unistd.h>
#include<time.h>

typedef struct tTHREAD
{
    struct sockaddr_in server;
    struct sockaddr_in client;
    int sock;
    char buf[100];
    int msg_size;
    int ack;
    int frame_kind;
}THREAD;

int mode; //0:receive, 1:send
int ack; //0:ack not received, 1: ack received
int datarcv; //0:send data, 1: send ack
time_t startTime, endTime;
int resend;
THREAD *p;

void *sendThread(void *data)
{
    THREAD* pq = (THREAD*)data;
    int status;
    time_t startTime = 0, endTime = 0;
    int gap;
    int len = sizeof(struct sockaddr);
    int result;
    //p->ack = 1;

    while(1){
        if(ack == 1 && datarcv == 0 && mode == 1){
            printf("Send: ");
            if(!resend){
                if(fgets(p->buf,sizeof(p->buf),stdin))
                {
                    p->buf[99] = '\0';
                }
                else
                {
                    perror("fgets");
                    exit(0);
                }
            }
            p->ack = 0;
            p->frame_kind = 0;

            if(sendto(p->sock, p,sizeof(THREAD), 0, (struct sockaddr *)&p->client, sizeof(struct sockaddr))<0)
            {
                perror("sendto");
                exit(0);
            }
            startTime = clock();
            ack = 0;
            mode = 0;
        }
        else if(ack == 1 && datarcv == 1 && mode == 1){
            p->ack = 1;
            p->frame_kind = 1;
            if(sendto(p->sock, p, sizeof(THREAD), 0, (struct sockaddr *)&p->client, len)<0)
            {
                perror("ACKsendto");
                exit(0);
            }
            datarcv = 0;
        }
    }
    pthread_exit((void**)status);
}
void *recvThread(void *data)
{
    int msg_size,len;
    int status;
    int gap;
    
    len = sizeof(struct sockaddr);
   while(1){ 
    /* 패킷을 받고 송신한 클라이언트 확인*/
    if(ack == 0 && mode == 0){
        while(1){
            if(p->msg_size = recvfrom(p->sock,p, sizeof(THREAD), 0, (struct sockaddr *)&p->client, &len) == -1)
            {
                perror("recvfrom");
                exit(0);
            }
            else if(p->msg_size >= 0 && p->ack == 1 && p->frame_kind == 1){
                ack = p->ack;
                resend = 0;
                break;
            }
            endTime = clock();
            gap = (int)(endTime-startTime)/(CLOCKS_PER_SEC);
            if(gap >= 2){
                ack = 1;
                mode = 1;
                resend = 1;
            }
        }
    }
     else if(ack == 1 && mode == 0){
         if(p->msg_size = recvfrom(p->sock,p, sizeof(THREAD), 0, (struct sockaddr *)&p->client, &len) == -1)
         {
            perror("recvfrom");
            exit(0);
         }
         if(p->frame_kind == 0){
            printf("Received : %s",p->buf);
            datarcv = 1;
            mode = 1;
        }
     }
   }
    pthread_exit((void**)status);
}

int main()
{
    int sock;
    struct sockaddr_in server, client;
    int len;
    pthread_t th1,th2;
    int thr_id1, thr_id2;
    THREAD st;
    int status;
    int buf_size;
    char buf[100];
    int msg_size;
    char *ip_addr;
    ack = 1;
    datarcv = 0;
    mode = 0;
    resend = 0;

    p = (THREAD*)malloc(sizeof(THREAD));
    bzero((char *)&p->client, sizeof(p->client));
    if((sock = socket(PF_INET, SOCK_DGRAM, 0))<0)
    {
        perror("stream server");
        exit(0);
    }

    p->sock = sock;

    server.sin_family = AF_INET;
    server.sin_addr.s_addr = htonl(INADDR_ANY);
    server.sin_port = htons(7788);
    bzero(&server.sin_zero,0);
    bzero((char*)&client, sizeof(client));
    len = sizeof(struct sockaddr);
    p->server = server;

    if(bind(sock, (struct sockaddr*)&server, sizeof(server))<0)
    {
        perror("bind local address");
        exit(1);
    }
        thr_id1 = pthread_create(&th1, NULL,recvThread,(void*)&st);
        
        if(thr_id1 !=0)
        {
            perror("Thread Create");
            return 1;
        }

        thr_id2 = pthread_create(&th2, NULL, sendThread, (void*)&st);
        if(thr_id2 != 0)
        {
            perror("thread create");
            exit(0);
        }

        pthread_join(th1, (void*)&status);
        pthread_join(th2, (void*)&status);
       
    close(sock);

    return 0;
}
