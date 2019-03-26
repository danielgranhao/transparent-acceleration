#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <dlfcn.h>
//#include "mult.h"

int main(){
	void *handle;
	uint64_t (*mult)(uint64_t, uint64_t);
	char *error;

	handle = dlopen("libmult_ase.so", RTLD_LAZY);
	if(!handle){
		printf("%s\n", dlerror());
		exit(1);
	}

	mult = dlsym(handle, "mult");
	if((error = dlerror()) != NULL){
		printf("%s\n", error);
		exit(1);
	}

	printf("5*10 = %" PRIu64 "\n", (*mult)(5,10));
	dlclose(handle);
}
