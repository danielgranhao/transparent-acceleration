#include <unistd.h>
#include <stdio.h>

//int main()
//{   
//    int i;
//    for(i = 0;i < 100; ++i) {
//        printf("My counter: %d\n", i);
//        sleep(1);
//    }
//	
//    return 0;
//}
#include <sys/types.h>

int main(int argc, char **arv) {
  for (;;) {
    printf("%d\n", getpid());
    sleep(1);
  }
  return 0;
}
