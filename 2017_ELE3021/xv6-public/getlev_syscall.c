#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"

int getlev(void)
{
    //get MLFQ priority level
   int level=0;
   level = proc->level;
   cprintf("current process is %d\n",level);
   return 0;
}
//Wrapper
int sys_getlev(void)
{
    return getlev();
}
