#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <inttypes.h>
//#include <dlfcn.h>

uint64_t dummy_mult(uint64_t a, uint64_t b){
	return a*b;
}

int main(int argc, char **argv) {
	
//	printf("dummy PID is %d\n", getpid());

	int a, b;

//	printf("My dlopen is at: %p\n", (void*)dlopen);

	long x = 0;
	while(x< 1000000000) x++;	

	while(1){
		printf("Insert operand A:\n");
		scanf("%d", &a);
		printf("Insert operand B:\n");
		scanf("%d", &b);
		printf("%d * %d = %d\n", a, b, dummy_mult(a,b));
//		break;
	}
}
