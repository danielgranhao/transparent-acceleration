CC      = gcc
CFLAGS  = -g
RM      = rm -f


default: all

all: manager dummy_mult 

manager: manager.c
	$(CC) -Linjector -Lto_inject $(CFLAGS) -o manager manager.c -linjector -lmult_ase
       	
dummy_mult: dummy_mult.c
	$(CC) $(CFLAGS) -o dummy_mult dummy_mult.c

clean veryclean:
	$(RM) manager dummy_mult
