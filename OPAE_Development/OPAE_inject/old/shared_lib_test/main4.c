#include <stdio.h>
#include <unistd.h>
#include <inttypes.h>
#include "mult.h"

int main(){
	int i = 0;
	while(i<3){
		printf("%d\n", getpid());
		sleep(1); 
		i++;
	}
	printf("5*10 = %" PRIu64 "\n", mult(5,10));
}
