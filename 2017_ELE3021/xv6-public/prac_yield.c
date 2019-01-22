#include "types.h"
#include "defs.h"

void my_yield(void){
    
    yield();
}
int sys_yield(void)
{
   my_yield();
   return 0;
}
