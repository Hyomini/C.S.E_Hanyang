#include "types.h"
#include "stat.h"
#include "user.h"

int main()
{
   int pid;
    int count = 0;

    pid = fork();

    while(count++ < 100){
        if( pid == 0){
            write(1,"Child\n",6);
            yield();

        }
        else if(pid > 0){
            write(1,"Parent\n",7);
            yield();
        }
        else
            write(1,"fork error\n",11);
    }
    wait();
    exit();
    return 0;
}
