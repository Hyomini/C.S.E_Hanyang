#include "types.h"
#include "stat.h"
#include "user.h"
#define NUM_THREAD 10
void*
threadmain(void *data)
{
    int n = *((int*)data);
    printf(1," %d thread created completely",n);
}

int
main(void)
{
  thread_t threads[NUM_THREAD];
  int i;
  int pid[10];
  void *retval;
  printf(1,"start"); 
  for (i = 0; i < 3; i++){
    if (thread_create(&threads[i], threadmain, (void*)i) != 0){
      return -1;
    }
    else
        printf(1,"created %d \n",threads[i]);
  }
  return 0;
}
