#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<errno.h>
#include<pthread.h>
#include<sys/ioctl.h>
#include<net/if.h>
#include<math.h>
#include<time.h>
#include"udp.h"

width crcTable[256];

unsigned char rcv_msg[518];// frame for receiving message
time_t startTime, endTime;
int connected;//0: not connected, send U-frame, 1: connected, send message
int nr,ns;
int ack;
int resend; //0: don't resend, 1: resend
int count; // if count 3 abandon

typedef struct tTHREAD
{
    int sock;
    char buf[100];
    int buf_size;
    struct sockaddr_in server;
}THREAD;


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
    THREAD *pp = (THREAD*)data;
    int status;
    frame_t *frame;
    char buf[100]; //buffer for keyboard input
    unsigned char message[518];// frame for send to server
    uint32_t msg_size;
    int length;
    int data_length;
    width ret_val;
    

    frame = (frame_t*)malloc(sizeof(frame_t));

    while(1){
        memset(frame, 0, sizeof(frame_t));
        getmac(pp->sock, frame);
        /*U-frame SABME*/
        if(connected == 0 && ack == 1){
            memset(message,0,sizeof(message));
            memcpy(message, frame->dst_mac,6); // dst_mac is 00:00:00:00:00:00 at first
            memcpy(&message[6], frame->src_mac,6);
            message[16] = U_SABME;
            data_length = 0; // U-frame has no message
            length = 21;// address 12byte, crc 4byte, pdulength 2byte, data and padding 3byte
            message[12] = length/256;// if length is bigger than 1byte(256)
            message[13] = length%256;
            //
            ret_val = crcCompute(message,length-4);
            memcpy(&message[17], &ret_val,sizeof(ret_val));
            //
            if(sendto(pp->sock, message, length, 0, (struct sockaddr *)&pp->server, sizeof(struct sockaddr))<0)
            {
                perror("sendto");
                exit(0);
            }
            printf("demanded the connection\n");
            ack = 0;
        }
        /*I-frame*/
        else if(connected == 1 && ack == 1){
            if(!resend){
            printf("Send : ");
                if(!fgets(buf,sizeof(buf), stdin)){
                    printf("fgets error\n");
                    exit(0);
                } 
                memset(message,0,sizeof(message));
                memcpy(message, &rcv_msg[6],6);
                data_length = strlen(buf) + 1;//+1 is for '\n'
                memcpy(&message[6], frame->src_mac,6);
                length = data_length + 21 + 1;
                message[12] = length/256;
                message[13] = length%256;
                ns++;
                message[16] = ns;
                message[17] = nr;
                memcpy(&message[18], buf, strlen(buf)+1);
                //
                ret_val = crcCompute(message,length-4);
                memcpy(&message[18+strlen(buf)+1], &ret_val,sizeof(ret_val));
                //
            }

            if(sendto(pp->sock,message, length, 0, (struct sockaddr *)&pp->server, sizeof(struct sockaddr))<0)
            {
                perror("sendto");
                exit(0);
            }
            startTime = clock();
            ack = 0;

        }   
    }
    pthread_exit((void**)status);
}

void *recvThread(void *data)
{
    THREAD *pq = (THREAD*)data;
    char buf[100]; 
    int len;
    int msg_size;
    int status;
    int gap;
    unsigned char forcrc[518];
    width crc, rcvcrc;


    len = sizeof(struct sockaddr);
    while(1){
        memset(rcv_msg, 0, sizeof(rcv_msg));
        while(1){
            if((msg_size = recvfrom(pq->sock,rcv_msg, 518, 0, (struct sockaddr *)&pq->server, &len))== -1)
            {
                perror("recvfrom");
                exit(0);
            }
            memcpy(&rcvcrc, &rcv_msg[msg_size-4],4);//received CRC
            memcpy(forcrc, rcv_msg, msg_size-4);
            crc = crcCompute(forcrc, msg_size-4);// compute CRC again
            if(crc!=rcvcrc){
                printf("abandon packet\n");
                 break;
            }
            printf("Received from server ");
            if(rcv_msg[16] == U_UA){
                printf("UA!\n");
                connected = 1;
                ack = 1;
                break;
            }
            else if(rcv_msg[16] == S_RR){
                printf("ACK!\n");
                nr++;
                ack = 1;
                resend = 0;
                break;
            }
            endTime = clock();
            gap = (int)(endTime - startTime)/(CLOCKS_PER_SEC);
            if(count >= 3)
                break;
            if(gap >= 2){
                resend = 1;
                ack = 1;
                count++;
            //resend message
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
    ns = 0;
    nr = 0;
    ack = 1;
    resend = 0;
    endTime = 0;

    crcInit();
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
