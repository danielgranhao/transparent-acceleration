gcc -c -Wall -Werror -fpic hello.c
gcc -shared -o libhello.so hello.o
gcc -L. -o main_test main_test.c -lhello
