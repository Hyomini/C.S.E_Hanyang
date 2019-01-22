#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<string.h>
#include<pthread.h>
#include<unistd.h>
typedef struct tTHREAD
{
    struct sockaddr_in server;
    struct sockaddr_in client;
    int sock;
    char buf[100];
    int msg_size;
}THREAD;

void *sendThread(void *data)
{
    THREAD* pq = (THREAD*)data;
    printf("send message is :%s\n",pq->buf);
    if(sendto(pq->sock, pq->buf,100, 0, (struct sockaddr *)&pq->client, sizeof(struct sockaddr))<0)
    {
        perror("sendto");
        exit(0);
    }
    printf("sendto completed\n");
}
void *rcvThread(void *data)
{
    int msg_size,len;
    char buf[100];
    char *ip_addr;
    pthread_t th2;
    int thr_id2;
    int status;

    
    THREAD* pp = (THREAD*)data;
    bzero((char *)&pp->client, sizeof(pp->client));
    
    len = sizeof(struct sockaddr);
    
    bzero((char *)&pp->buf, sizeof(pp->buf));
    /* 패킷을 받고 송신한 클라이언트 확인*/
    if(pp->msg_size = recvfrom(pp->sock,pp->buf, 100, 0, (struct sockaddr *)&pp->client, &len) == -1)
    {
        perror("recvfrom");
        exit(0);
    }
    ip_addr = inet_ntoa(pp->client.sin_addr);
    printf("message : %s, byte: %d\n",pp->buf,pp->msg_size);
    printf ("server : %s client data received.\n", ip_addr); 
    
    thr_id2 = pthread_create(&th2, NULL, sendThread, (void*)pp);
    if(thr_id2 != 0)
    {
        perror("thread create");
        exit(0);
    }
    pthread_join(th2, (void*)&status);
}

int main()
{
    int sock;
    struct sockaddr_in server, client;
    int len;
    pthread_t th1;
    int thr_id1;
    THREAD st;
    int status;
    int buf_size;
    char buf[100];
    int msg_size;
    char *ip_addr;

    if((sock = socket(PF_INET, SOCK_DGRAM, 0))<0)
    {
        perror("stream server");
        exit(0);
    }

    st.sock = sock;

    server.sin_family = AF_INET;
    server.sin_addr.s_addr = htonl(INADDR_ANY);
    server.sin_port = htons(7788);
    bzero(&server.sin_zero,0);
    bzero((char*)&client, sizeof(client));
    len = sizeof(struct sockaddr);
    st.server = server;

    if(bind(sock, (struct sockaddr*)&server, sizeof(server))<0)
    {
        perror("bind local address");
        exit(1);
    }
    printf("server started\n");
    while(1)
    {
        thr_id1 = pthread_create(&th1, NULL,rcvThread,(void*)&st);
        
        if(thr_id1 !=0)
        {
            perror("Thread Create");
            return 1;
        }
        pthread_join(th1, (void*)&status);
       
    }

    return 0;
}

