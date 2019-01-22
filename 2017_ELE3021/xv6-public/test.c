#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    int ret_val1;
    int ret_val2;
    
    ret_val1 = getpid();
    ret_val2 = getppid();

    printf(1,"My pid is %d\n", ret_val1);
    printf(1,"My ppid is %d\n", ret_val2);
    exit();
}
