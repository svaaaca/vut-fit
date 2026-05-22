#pragma once
#include "stdlib.h"
#include "stdio.h"

volatile int canrun = 1;
int alarm_secs = 0;

#ifdef WIN32
  #include <windows.h>
  BOOL WINAPI catcher(DWORD CEvent)
  {
    canrun = 0;
    return TRUE;
 }

 #ifdef WIN32_MM
  #include <MMsystem.h>
  static UINT timer_id;
  static void CALLBACK catcher2(UINT, UINT, DWORD_PTR, DWORD_PTR, DWORD_PTR)
  {
    canrun = 0;
  }
 #endif

#else
  #include <unistd.h>
  #include <signal.h>
  void catcher(int sig) {
    canrun = 0;
  }
#endif


void canrun_init() 
{
    #ifdef WIN32

     #ifdef WIN32_MM
      if (alarm_secs > 0) {
  	    	/* call verbose_stats_dump() each 1000 +/-100msec */
		   timer_id = timeSetEvent(alarm_secs*1000, 1000, catcher2, 0, TIME_ONESHOT);
         if (!timer_id) {
           fprintf(stderr,";Error during initialization of alarm catcher\n"); abort();
         }
         printf(" + Alarm:%d\n", alarm_secs);
      }
     #endif

    #else
      struct sigaction sigact;
      sigact.sa_handler = catcher;
      sigemptyset(&sigact.sa_mask);
      sigact.sa_flags = 0;
      if (alarm_secs > 0) {
        alarm(alarm_secs);
        if (sigaction(SIGALRM, &sigact, NULL) == -1)
          fprintf(stderr,";Error during initialization of alarm catcher\n");
        printf(" + Alarm:%d\n", alarm_secs);
        //fprintf(stderr,";Alarm initialized to %d seconds\n", alarm_secs);
      }
    #endif

    #ifdef WIN32
      if (SetConsoleCtrlHandler( (PHANDLER_ROUTINE)catcher, TRUE)==FALSE)
      {
        // unable to install handler... 
        // display message to the user
        printf("Unable to install handler!\n");
        return;
      }   
    #else
      signal(SIGINT, catcher); //Ctrl-C handler
    #endif
}

#if defined (_MSC_VER) || defined (_WIN32)

#include <ctime>

static inline double cpuTime(void) {
    return (double)clock() / CLOCKS_PER_SEC; }

#else

#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>

static inline double cpuTime(void) {
    struct rusage ru;
    getrusage(RUSAGE_SELF, &ru);
    return (double)ru.ru_utime.tv_sec + (double)ru.ru_utime.tv_usec / 1000000; }
#endif
