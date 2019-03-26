#include <stdio.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
//#include <linux/user.h>
#include <sys/user.h>
#include <sys/reg.h>
#include <sys/syscall.h>
int main(int argc, char *argv[])
{
    pid_t child;
    const int long_size = sizeof(long);
    child = fork();
    if(child == 0) {
        //ptrace(PTRACE_TRACEME, 0, NULL, NULL);
        execve("mult", argv, NULL);
    }
    else {
	wait(NULL);
	char str[20];
	scanf("%s", str);
    	waitpid(child, NULL, 0);
    }
    return 0;
}

