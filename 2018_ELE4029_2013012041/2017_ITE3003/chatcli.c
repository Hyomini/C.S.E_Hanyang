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

time_t startTime, endTime;
frame_t *rcvf;//frame which server sended, for destination address
int connected;//0: not connected, send U-frame, 1: connected, send message
int nr,ns;
int ack;
int resend; //0: don't resend, 1: resend

typedef struct tTHREAD
{
    int sock;
    char buf[100];
    int buf_size;
    struct sockaddr_in server;
}THREAD;

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
    char buf[100];
    int i = 0;

    frame = (frame_t*)malloc(sizeof(frame_t));
    getmac(pp->sock, frame);
    printf("size is %d\n",sizeof(frame_t));
    printf("%02x:%02x:%02x:%02x:%02x:%02x\n", frame->src_mac[0], frame->src_mac[1], frame->src_mac[2], frame->src_mac[3], frame->src_mac[4], frame->src_mac[5]);
    while(1){
        memset(frame, 0, sizeof(frame_t));
        /*U-frame SABME*/
        if(connected == 0 && ack == 1){
            frame->dapa.control = U_SABME; //for connecting
            frame->pduleng = (int)sizeof(frame);
            if(sendto(pp->sock, frame, sizeof(frame_t), 0, (struct sockaddr *)&pp->server, sizeof(struct sockaddr))<0)
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
                if(fgets(buf,sizeof(buf), stdin))
                {
                    strcpy(frame->dapa.info, buf);
                }
                else{
                    printf("fgets error\n");
                    exit(0);
                }  

                ns++;
                frame->dapa.control += (ns)*2;//N(S)
                frame->dapa.control += nr*(int)pow(2,9);//N(R)
                for(i=0;i<6;i++)
                    frame->dst_mac[i] = rcvf->src_mac[i];
                frame->pduleng = sizeof(frame);
            }

            if(sendto(pp->sock, frame, sizeof(frame_t), 0, (struct sockaddr *)&pp->server, sizeof(struct sockaddr))<0)
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

    //rcvf->dst_mac = (char*)malloc(6*sizeof(char));
    //rcvf->src_mac = (char*)malloc(6*sizeof(char));
    len = sizeof(struct sockaddr);
    while(1){
        memset(rcvf, 0, sizeof(frame_t));
        while(1){
            if(msg_size = recvfrom(pq->sock,rcvf, sizeof(frame_t), 0, (struct sockaddr *)&pq->server, &len)== -1)
            {
                perror("recvfrom");
                exit(0);
            }
            printf("Received from server\n");
            if(rcvf->dapa.control == U_UA){
                connected = 1;
                ack = 1;
                break;
            }
            else if(rcvf->dapa.control == S_RR){
                ack = 1;
                resend = 0;
                break;
            }
            endTime = clock();
            gap = (int)(endTime - startTime)/(CLOCKS_PER_SEC);
            if(gap >= 2){
                resend = 1;
                ack = 1;
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

    rcvf = (frame_t*)malloc(sizeof(frame_t));

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
