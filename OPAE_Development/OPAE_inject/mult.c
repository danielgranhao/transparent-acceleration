#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <inttypes.h>

int main(int argc, char **argv) {
	if(argc != 3){
		printf("Usage: mult <operand_a> <operand_b>\n");
		return 1;
	}

	uint64_t a = atoi(argv[1]);
	uint64_t b = atoi(argv[2]);

	uint64_t res = a * b;	

	printf("%" PRIu64 " * %" PRIu64 " = %" PRIu64 "\n", a, b, res);
	return 0;
}
