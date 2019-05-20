 #include <stdlib.h>
    #include <stdio.h>
    #include <dlfcn.h>

void* __libc_dlopen_mode(const char*, int);
void* __libc_dlsym(void*, const char*);
int   __libc_dlclose(void*);

int main(int argc, char **argv) {
        void *handle;
        int (*mult)(int, int);

        handle = __libc_dlopen_mode ("to_inject/libmult.so", RTLD_NOW);

        mult = __libc_dlsym(handle, "mult");

        printf ("%d\n", (*mult)(20,10));
        __libc_dlclose(handle);
    }
