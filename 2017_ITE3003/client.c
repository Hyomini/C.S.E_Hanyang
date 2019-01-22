#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<errno.h>
#include<pthread.h>

typedef struct tTHREAD
{
    int sock;
    char buf[100];
    int buf_size;
    struct sockaddr_in server;
}THREAD;

void *sendThread(void *data)
{
    THREAD *pp = (THREAD*)data;
   /* if(fgets(pp->buf, 100, stdin))
    {
        pp->buf[99] = '\0';
        pp->buf_size = strlen(pp->buf);
    }*/
    if(sendto(pp->sock, pp->buf, pp->buf_size, 0, (struct sockaddr *)&pp->server, sizeof(struct sockaddr))<0)
    {
        perror("sendto");
        exit(0);
    }
}

void *recvThread(void *data)
{
    THREAD *pq = (THREAD*)data;
    char buf[100]; 
    int len;
    int msg_size;

    len = sizeof(struct sockaddr);
    printf("echoed message : ");
    if(msg_size = recvfrom(pq->sock,buf, 100, 0, (struct sockaddr *)&pq->server, &len)== -1)
    {
        perror("recvfrom");
        exit(0);
    }
    printf("%s\n",buf);

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
    printf("input string : ");
    while(getchar()!='\n');  
    if(fgets(st.buf,sizeof(st.buf), stdin))
    {
        st.buf[99] = '\0';
        st.buf_size = strlen(st.buf);
        printf("send :%s\n",st.buf);
    }
    else{
        printf("fgets error\n");
        exit(0);
    }
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


