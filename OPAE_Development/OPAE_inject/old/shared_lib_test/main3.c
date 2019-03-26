#include <stdio.h>
#include <unistd.h>
#include <inttypes.h>
#include "mult.h"

int main(){
	while(1){
		printf("%d\n", getpid());
		sleep(1); 
	}
	printf("5*10 = %" PRIu64 "\n", mult(5,10));
}
