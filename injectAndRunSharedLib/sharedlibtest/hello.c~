void hello()
{
__asm__(
         "jmp forward\n\t"
"backward:\n\t"
         "pop   %rsi\n\t"
         "mov   $1, %rax\n\t"
         "mov   $1, %rdi\n\t"
         "mov   %rsi, %rcx\n\t"
         "mov   $12, %rdx\n\t"
         "syscall\n\t"
         "int3\n\t"
"forward:\n\t"
         "call backward\n\t"
         ".string \"Hello World\\n\"\n\t"
       );
}


