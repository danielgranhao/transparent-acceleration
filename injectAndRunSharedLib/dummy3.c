#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>

int main(int argc, char **arv) {
  for (;;) {
    printf("%d\n", getpid());
  }
  return 0;
}