CC      = gcc
CFLAGS  = -ggdb
RM      = rm -f
CFLAGS_SOFT = $(CFLAGS) -O2 #-march=native #-O3 -ftree-vectorize #-march=native

default: all

all: inject_test manager aes_ctr_software 

inject_test: inject_test.c
	$(CC) -I. -Linjector -Lto_inject -fPIC $(CFLAGS) -o inject_test inject_test.c -ldl -linjector -laes_ctr_acc

#manager: manager.c
#	$(CC) -I. -Linjector -Lto_inject -fPIC $(CFLAGS) -o manager manager.c -linjector -laes_ctr_acc

manager: manager.c
	$(CC) -I. -Linjector -Lto_inject -fPIC $(CFLAGS) -o manager manager.c -linjector -laes_ctr_acc_ase
       	
aes_ctr_software: aes_ctr_software.cpp 
	$(CXX) $(CFLAGS_SOFT) -o aes_ctr_software aes_ctr_software.cpp tiny-AES-c/aes.o

clean veryclean:
	$(RM) inject_test manager aes_ctr_software
