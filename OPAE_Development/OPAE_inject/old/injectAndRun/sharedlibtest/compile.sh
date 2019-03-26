gcc -c -Wall -Werror -fpic -ggdb hello.c
gcc -shared -ggdb -o libhello.so hello.o
gcc -L. -o main_test main_test.c -lhello
