#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <inttypes.h>

uint64_t dummy_mult(uint64_t a, uint64_t b){
	return a*b;
}

int main(int argc, char **argv) {
	
	int a, b;
	
	while(1){
		printf("Insert operand A:\n");
		scanf("%d", &a);
		printf("Insert operand B:\n");
		scanf("%d", &b);
		printf("%d * %d = %d\n", a, b, dummy_mult(a,b));
	}
}
