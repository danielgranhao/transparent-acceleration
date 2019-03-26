#include <stdio.h>
#include <time.h>

void hello()
{
	struct timespec tim1;
	tim1.tv_sec = 1;
	tim1.tv_nsec = 0;
	struct timespec tim2;
	nanosleep(&tim1, &tim2);	
	puts("Hello World!!!");
}


