#include <unistd.h>
#include <pthread.h>
#include <sched.h>
#include <sys/syscall.h>
#include <errno.h>
#include <stdint.h>
#include <stdio.h>

//define the number here with the core assigned to you
#define CPUID_SMT0 0
#define CPUID_SMT1 (CPUID_SMT0+4)

//enable and disable your SMT thread
#define SMT1_ON 1

static int fibonacci(int n){
  if(n==0){
    return 0;
  }
  else{
    if(n==1)
      return 1;
    else
      return (fibonacci(n-1)+fibonacci(n-2));
  }
}

static void *tf_smt0(void *targ){
  cpu_set_t mask;
  CPU_ZERO(&mask);
  CPU_SET(CPUID_SMT0, &mask);
  pid_t tid = syscall(SYS_gettid); //glibc does not provide a wrapper for gettid
  sched_setaffinity(tid, sizeof(cpu_set_t), &mask);

  printf("Fibonacci number 40 = %d\n", fibonacci(40));

  pthread_exit(NULL);
}

static void *tf_smt1(void *targ){
  cpu_set_t mask;
  CPU_ZERO(&mask);
  CPU_SET(CPUID_SMT1, &mask);
  pid_t tid = syscall(SYS_gettid); //glibc does not provide a wrapper for gettid
  sched_setaffinity(tid, sizeof(cpu_set_t), &mask);
  
  float m=4.5,l; 
  long long *array;
  long long *array2;
  long long *array3;
  long long *array4;
  array= (long long*)malloc (8*65536);
  array2= (long long*)malloc (8*65536);
  array3= (long long*)malloc (8*65536);
  array4= (long long*)malloc (8*65536);
  
  while (1){
    // put your "background" code here
    // no sleeps are other code that schedules the thread out is allowed
    // inline assembly is not allowed

    /* Since the fibonacci code in tf_stm0 thread a recursive function
     * there were many branch instruction in the hex code when observed.
     * The branch address calculation together with integer ALU addition is the main task happening in thread0.
     * So in thread1 instructions related to floating point and memory access are included. 
     */	

	m=m + 5.6;
	memcpy(array2+8192, array+8192,65536);
	memcpy(array4+8192, array3+8192,65536);
	l=m+45.9;
							
}

  //To be sure that the previous loop is not optimized away by the compiler
  printf("This should not appear\n");
  pthread_exit(NULL);
}

static int64_t diff(struct timespec start, struct timespec end)
{
  struct timespec temp;
  int64_t d;
  if ((end.tv_nsec-start.tv_nsec)<0) {
      temp.tv_sec = end.tv_sec-start.tv_sec-1;
      temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
  } else {
      temp.tv_sec = end.tv_sec-start.tv_sec;
      temp.tv_nsec = end.tv_nsec-start.tv_nsec;
  }
  d = temp.tv_sec*1000000000+temp.tv_nsec;
  return d;
}

int main ()
{
  pthread_t smt0, smt1;
  struct timespec start, end;

  clock_gettime(CLOCK_REALTIME,&start);

  pthread_create(&smt0, NULL, tf_smt0, NULL);
#if SMT1_ON
  pthread_create(&smt1, NULL, tf_smt1, NULL);
#endif

  pthread_join(smt0, NULL);
  clock_gettime(CLOCK_REALTIME,&end);
#if SMT1_ON
  pthread_cancel(smt1);
#endif

  double time = (double) diff(start,end)/1000000;
  printf("\nExecution time thread SMT0 \t %.3f ms\n", time);

  return 0;
}
