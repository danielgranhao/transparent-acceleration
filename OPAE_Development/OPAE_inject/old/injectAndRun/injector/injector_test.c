#include <stdio.h>
#include "injector.h"

int main(int argc, char *argv[]){

    if(argc != 3) {
        printf("Usage: %s <libraryToInject.so> <pid to be traced>\n", argv[0], argv[1]);
        return;
    }
    int traced_process = atoi(argv[2]);


    injector_t *injector;

    /* attach to a process whose process id is traced_process. */
    if (injector_attach(&injector, traced_process) != 0) {
        printf("ATTACH ERROR: %s\n", injector_error());
        return;
    }
    /* inject a shared library into the process. */
    if (injector_inject(injector, argv[1]) != 0) {
        printf("INJECT ERROR: %s\n", injector_error());
    }
    /* cleanup */
    injector_detach(injector);

}
