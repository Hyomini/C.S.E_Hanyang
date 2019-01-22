#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<string.h>
#include<pthread.h>
#include<unistd.h>
#include<sys/ioctl.h>
#include<net/if.h>
#include<math.h>
#include"udp.h"

typedef struct tTHREAD
{
    struct sockaddr_in server;
    struct sockaddr_in client;
    int sock;
    char buf[100];
    int msg_size;
}THREAD;

frame_t *rcvf;
THREAD *p;
int nr;
int sendack; //1: send ack frame
int sendua;

int getmac(int sock, frame_t* frame)
{
    struct ifreq ifr;
    int i = 0;

    memset(&ifr,0x00,sizeof(ifr));
    strncpy(ifr.ifr_name, "eth0", IFNAMSIZ);
    if(ioctl(sock, SIOCGIFHWADDR, &ifr)<0){
        perror("ioctl");
        return 1;
    }
    for(i=0;i<6;i++)
        frame->src_mac[i] = ifr.ifr_hwaddr.sa_data[i];
    return 0;
}
void *sendThread(void *data)
{
    THREAD* pq = (THREAD*)data;
    int status;
    frame_t *frame;

    frame = (frame_t*)malloc(sizeof(frame_t));
    getmac(p->sock, frame);

    int i = 0;
    for(i=0;i<6;i++)
        frame->dst_mac[i] = rcvf->src_mac[i];
    
    while(1){
        memset(frame, 0, sizeof(frame_t));

        if(sendack == 1){
            frame->dapa.control = S_RR;
            frame->pduleng = (int)sizeof(frame);
            if(sendto(p->sock, frame,sizeof(frame_t), 0, (struct sockaddr *)&p->client, sizeof(struct sockaddr))<0)
            {
                perror("sendto");
                exit(0);
            }
            sendack = 0;
            printf("ack sent\n");
        }
        else if(sendua == 1){
            frame->dapa.control = U_UA;
            frame->pduleng = (int)sizeof(frame);
            if(sendto(p->sock, frame,sizeof(frame_t), 0, (struct sockaddr *)&p->client, sizeof(struct sockaddr))<0)
            {
                perror("sendto");
                exit(0);
            }
            sendua = 0;
            printf("uA sented\n");
        }
    }
    pthread_exit((void**)status);
}
void *rcvThread(void *data)
{
    int msg_size,len;
    char buf[100];
    char *ip_addr;
    int status;

    
    len = sizeof(struct sockaddr);
    
    
    while(1){      
        memset(rcvf, 0, sizeof(frame_t));
        if(p->msg_size = recvfrom(p->sock, rcvf, sizeof(frame_t), 0, (struct sockaddr *)&p->client, &len) == -1)
        {
            perror("recvfrom");
            exit(0);
        }
        printf("some message received\n");
        nr++;
        if(rcvf->dapa.control  == U_SABME){
            sendua = 1;
            printf("client demanded the connection\n");
        }
        else if((rcvf->dapa.control & 0x0001) == 0){
            printf("Received : %s", rcvf->dapa.info);
            sendack = 1;
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
    sendack = 0, sendua = 0;

    rcvf = (frame_t*)malloc(sizeof(frame_t));
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
        thr_id1 = pthread_create(&th1, NULL,rcvThread,(void*)&st);
        
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
