PIC_LD=ld

ARCHIVE_OBJS=
ARCHIVE_OBJS += _1252_archive_1.so
_1252_archive_1.so : archive.0/_1252_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_1252_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_1252_archive_1.so $@


ARCHIVE_OBJS += _1380_archive_1.so
_1380_archive_1.so : archive.0/_1380_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_1380_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_1380_archive_1.so $@


ARCHIVE_OBJS += _1381_archive_1.so
_1381_archive_1.so : archive.0/_1381_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_1381_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_1381_archive_1.so $@


ARCHIVE_OBJS += _1382_archive_1.so
_1382_archive_1.so : archive.0/_1382_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_1382_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_1382_archive_1.so $@






%.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

MAIN_OBJS = \
objs/amcQw_d.o 

CU_OBJS = $(MAIN_OBJS) $(ARCHIVE_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

