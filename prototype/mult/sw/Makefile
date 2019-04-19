CC      = gcc
CFLAGS  = -ggdb
RM      = rm -f


default: all

all: inject_test manager dummy_mult 

inject_test: inject_test.c
	$(CC) -I. -Linjector -Lto_inject -fPIC $(CFLAGS) -o inject_test inject_test.c -ldl -linjector -lmult

manager: manager.c
	$(CC) -I. -Linjector -Lto_inject -fPIC $(CFLAGS) -o manager manager.c -linjector -lmult

#manager: manager.c
#	$(CC) -I. -Linjector -Lto_inject $(CFLAGS) -o manager manager.c -linjector -lmult_ase
       	
dummy_mult: dummy_mult.c
	$(CC) $(CFLAGS) -o dummy_mult dummy_mult.c 

clean veryclean:
	$(RM) inject_test manager dummy_mult
