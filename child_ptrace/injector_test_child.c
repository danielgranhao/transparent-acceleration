#include <stdio.h>
#include "injector.h"
#include <sys/ptrace.h>

int main(int argc, char *argv[]){

    if(argc != 2) {
        printf("Usage: %s <libraryToInject.so>\n", argv[0]);
        return;
    }
    
    pid_t child;
    child = fork();
    if(child == 0) {
        //ptrace(PTRACE_TRACEME, 0, NULL, NULL);
	extern char** environ;
        execve("dummy2", NULL, environ);
    }
    else {
        injector_t *injector;

        int traced_process = child;
        usleep(10000);
 
        // attach to a process whose process id is traced_process.
        if (injector_attach(&injector, traced_process) != 0) {
            printf("ATTACH ERROR: %s\n", injector_error());
            return;
        }
        // inject a shared library into the process. 
        if (injector_inject(injector, argv[1]) != 0) {
            printf("INJECT ERROR: %s\n", injector_error());
        }
        // cleanup
        injector_detach(injector);
        printf("child = %d\n", traced_process);        

	waitpid(child, NULL, 0);
    }
}
