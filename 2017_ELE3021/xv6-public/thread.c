#include"types.h"
#include"mmu.h"
#include"user.h"
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
    void *stack = malloc(PGSIZE);
    if((uint)stack <=0)
    {
        printf(1,"malloc thread stack failed\n");
        return -1;
    }
    
    if((uint)stack%PGSIZE)
        stack += PGSIZE-((uint)stack%PGSIZE);
    printf(1,"1\n");
    if((*thread = clone(start_routine,arg,stack))<0)
        return -1;
    return 0;
}

int thread_join(thread_t thread, void **retval)
{
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
        return -1;

    free(stack);
    return 0;
}

void thread_exit(void *retval)
{
    proc->retval = retval;
    thexit();
}
