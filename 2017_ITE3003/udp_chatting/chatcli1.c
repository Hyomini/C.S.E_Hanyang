#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<errno.h>
#include<pthread.h>
#include<time.h>

int mode; // 0:receive, 1: send
int ack;//0: ack not recieved 1: ack received
int datarcv; //0: send data, 1: send ack
time_t startTime, endTime;
int resend; //0: don't resend, 1: resend

typedef struct tTHREAD
{
    struct sockaddr_in server;
    struct sockaddr_in client;
    int sock;
    char buf[100];
    int buf_size;
    int ack;
    int frame_kind;
}THREAD;

void *sendThread(void *data)
{
    THREAD *pp = (THREAD*)data;
    int status;
    int gap;
    int len = sizeof(struct sockaddr);
    int result;// receive ack successfully

    while(1){ 
        if(ack == 1 && datarcv == 0 && mode == 1){
            printf("Send : ");
            /*if resend is 1, don't implement fgets*/
            /*resend 1 means timeout*/
            if(!resend){
                if(fgets(pp->buf,sizeof(pp->buf), stdin))
                {
                    pp->buf[99] = '\0';
                    pp->buf_size = strlen(pp->buf);
                }
                else{
                    perror("fgets");
                    exit(0);
                }
            }
            pp->ack = 0;
            pp->frame_kind = 0;
            if(sendto(pp->sock, pp, sizeof(THREAD), 0, (struct sockaddr *)&pp->server, len)<0)
            {
                perror("sendto");
                exit(0);
            }
            startTime = clock();
            ack = 0;//wait for ACK
            mode = 0;//wait for receiving message
        }
        /*send ACK packet*/
        else if(ack == 1 && datarcv == 1 && mode == 1){
            pp->ack = 1;
            pp->frame_kind = 1;
            if(sendto(pp->sock, pp, sizeof(THREAD), 0, (struct sockaddr *)&pp->server, len)<0)
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
    THREAD *pq = (THREAD*)data;
    int len;
    int msg_size;
    int status;
    int gap; //for calculating time

    len = sizeof(struct sockaddr);
    while(1){
        /*receive ACK packet*/
        if(ack == 0 && mode == 0){
            while(1){
                if(msg_size = recvfrom(pq->sock,pq, sizeof(THREAD), 0, (struct sockaddr *)&pq->server, &len)== -1)
                {
                    perror("recvfrom");
                    exit(0);
                }
                else if(msg_size >= 0 && pq->ack == 1 && pq->frame_kind == 1){
                    ack = pq->ack;
                    resend = 0;
                    break;
                }
                endTime = clock();
                gap = (int)(endTime-startTime)/(CLOCKS_PER_SEC);
                //time out is 2s
                if(gap >= 2){
                    ack = 1;
                    mode = 1;
                    resend = 1;
                }
            }
        }
        /*receive message*/
        else if(ack == 1 && mode ==0){

            if(msg_size = recvfrom(pq->sock,pq, sizeof(THREAD), 0, (struct sockaddr *)&pq->server, &len)== -1)
            {
                perror("recvfrom");
                exit(0);
            }
            if(pq->frame_kind == 0){
                printf("Received : %s",pq->buf);
                datarcv = 1;
                mode = 1;
            }
        }
    }
    pthread_exit((void**)status);
}   

int main(int argc, char *argv[])
{
    int sock;
    int status;
    struct sockaddr_in server;
    char server_ip[20];
    int port;
    int thr_id1, thr_id2;
    THREAD st;
    pthread_t th1, th2;
    char buf[100]; 
    int buf_size;
    /*set global value*/
    resend = 0;
    ack = 1; //처음에 ack를 1로 설정해둬야 메세지를 보낼 수 있다
    datarcv = 0;
    mode = 1; //client is send mode at first

    if((sock = socket(PF_INET, SOCK_DGRAM, 0))<0)
    {
        perror("socket");
        exit(0);
    }

    st.sock = sock;

    printf("please enter server IP address: ");
    fgets(server_ip,sizeof(server_ip),stdin);
    server_ip[strlen(server_ip)-1] = '\0';
    printf("please enter server portnumber: ");
    scanf("%d", &port);
     
    bzero((char *)&server,sizeof(server));
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = inet_addr(server_ip);
    server.sin_port = htons(port);
    st.server = server;
    while(getchar()!='\n');
        thr_id1 = pthread_create(&th1, NULL, sendThread, (void*)&st);
    if(thr_id1 != 0)
    {
        perror("sendThread create");
        exit(0);
    }
    thr_id2 = pthread_create(&th2, NULL, recvThread, (void*)&st);
    if(thr_id2 != 0)
    {
        perror("recvThread create");
        exit(0);
    }

    pthread_join(th1, (void*)&status);
    pthread_join(th2, (void*)&status);
    close(sock);

    return 0;
}
