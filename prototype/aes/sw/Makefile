CC      = gcc
CFLAGS  = -ggdb
RM      = rm -f
CFLAGS_SOFT = $(CFLAGS) #-O2 #-march=core-avx2 -ftree-vectorize
CFLAGS_NT = $(CFLAGS) -O2 -march=core-avx2 -ftree-vectorize

default: all

all: inject_test manager aes_ctr_software aes_ctr_non_transparent

inject_test: inject_test.c
	$(CC) -I. -Linjector -Lto_inject -fPIC $(CFLAGS) -o inject_test inject_test.c -ldl -linjector -laes_ctr_acc

#manager: manager.c
#	$(CC) -I. -Linjector -Lto_inject -fPIC $(CFLAGS) -o manager manager.c -linjector -laes_ctr_acc

manager: manager.c
	$(CC) -I. -Linjector -Lto_inject -fPIC $(CFLAGS) -o manager manager.c -linjector -laes_ctr_acc_ase
       	
aes_ctr_software: aes_ctr_software.cpp 
	$(CXX) $(CFLAGS_SOFT) -o aes_ctr_software aes_ctr_software.cpp tiny-AES-c/aes.o

aes_ctr_non_transparent: aes_ctr_non_transparent.cpp 
	$(CXX) $(CFLAGS_NT) -Llibaesni -Lto_inject -fPIC  -o aes_ctr_non_transparent aes_ctr_non_transparent.cpp tiny-AES-c/aes.o -laes_lin64 -laes_ctr_acc_ase

clean veryclean:
	$(RM) inject_test manager aes_ctr_software aes_ctr_non_transparent
