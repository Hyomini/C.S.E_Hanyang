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

unsigned char rcv_msg[518];
width crcTable[256];
frame_t *rcvf;
THREAD *p;
int nr;
int sendack; //1: send ack frame
int sendua;

void crcInit(void)
{
    width remainder;
    width dividend;
    int bit;

    for(dividend = 0; dividend<256;dividend++){
        remainder = dividend << (WIDTH - 8);
        for(bit = 0; bit<8;bit++){
            if(remainder & TOPBIT)
                remainder = (remainder << 1 )^POLYNOMIAL;
            else
                remainder = remainder << 1;
        }
        crcTable[dividend] = remainder;
    }
}

width crcCompute(char *message, unsigned int nBytes)
{
    unsigned int offset;
    unsigned char byte;
    width remainder = INITIAL_REMAINDER;

    for(offset = 0;offset < nBytes;offset++){
        byte = (remainder >> (WIDTH-8)) ^ message[offset];
        remainder = crcTable[byte] ^ (remainder << 8);
    }
    return (remainder ^ FINAL_XOR_VALUE);
}
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
    unsigned char message[518];
    int length = 0;
    width ret_val;

    frame = (frame_t*)malloc(sizeof(frame_t));
    getmac(p->sock, frame);

    while(1){
        memset(frame, 0, sizeof(frame_t));
        memset(message,0,sizeof(message));
        if(sendack == 1){
            memcpy(message, &rcv_msg[6],6);//destination address 
            memcpy(&message[6], frame->src_mac,6);
            message[16] = S_RR;
            message[17] = nr;
            length = 22;// address 12byte, pdulength 2byte, data and padding 4byte, crc 4byte
            message[12] = length/256;
            message[13] = length%256;
            //crc
            ret_val = crcCompute(message, length-4);
            memcpy(&message[18], &ret_val, sizeof(ret_val));
            //
            if(sendto(p->sock, message,length, 0, (struct sockaddr *)&p->client, sizeof(struct sockaddr))<0)
            {
                perror("sendto");
                exit(0);
            }
            sendack = 0;
            printf("ack sent\n");
        }
        else if(sendua == 1){
            memcpy(message, &rcv_msg[6],6);//destination address
            memcpy(&message[6], frame->src_mac,6);
            message[16] = U_UA;
            length = 21;// same as SABME in client
            message[12] = length/256;
            message[13] = length%256;
            //crc
            ret_val = crcCompute(message, length-4);
            memcpy(&message[17], &ret_val, sizeof(ret_val));
            //
            if(sendto(p->sock,message,length, 0, (struct sockaddr *)&p->client, sizeof(struct sockaddr))<0)
            {
                perror("sendto");
                exit(0);
            }
            sendua = 0;
            printf("uA sent\n");
        
    }
    }
    pthread_exit((void**)status);
}
void *rcvThread(void *data)
{
    int msg_size,len;
    int status;
    width crc, rcvcrc;// crc는 받아온 패킷으로 다시 계산한 것, rcvcrc는 받아온 것
    unsigned char forcrc[518];// 받아온 패킷의 crc부분을 제외한 나머지 부분

    len = sizeof(struct sockaddr);
    
    while(1){      
        memset(rcv_msg,0,sizeof(rcv_msg));
        if((msg_size = recvfrom(p->sock, rcv_msg,518, 0, (struct sockaddr *)&p->client, &len)) == -1)
        {
            perror("recvfrom");
            exit(0);
        }
        //
        memcpy(&rcvcrc, &rcv_msg[msg_size-4],4);
        memcpy(forcrc, rcv_msg, msg_size-4);
        crc = crcCompute(forcrc, msg_size-4);
        if(crc!=rcvcrc){
            printf("packet abandoned\n");
            break;
        }
        //crc confirm
        printf("some message received\n");
        if(rcv_msg[16] == U_SABME){
            sendua = 1;
            printf("client demanded the connection\n");
        }
        else if(rcv_msg[16]<128){
            printf("Received : %s", &rcv_msg[18]);
            sendack = 1;
            nr++;
        }
        else{
            printf("Received : %s", &rcv_msg[18]);
            sendack = 1;
            nr++;
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
    char *ip_addr;
    sendack = 0, sendua = 0;
    
    crcInit();
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
