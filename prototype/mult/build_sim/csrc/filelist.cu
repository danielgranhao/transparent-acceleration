PIC_LD=ld

ARCHIVE_OBJS=
ARCHIVE_OBJS += _9696_archive_1.so
_9696_archive_1.so : archive.0/_9696_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_9696_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_9696_archive_1.so $@


ARCHIVE_OBJS += _9994_archive_1.so
_9994_archive_1.so : archive.0/_9994_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_9994_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_9994_archive_1.so $@


ARCHIVE_OBJS += _9995_archive_1.so
_9995_archive_1.so : archive.0/_9995_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_9995_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_9995_archive_1.so $@


ARCHIVE_OBJS += _9996_archive_1.so
_9996_archive_1.so : archive.0/_9996_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_9996_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_9996_archive_1.so $@






%.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

MAIN_OBJS = \
objs/amcQw_d.o 

CU_OBJS = $(MAIN_OBJS) $(ARCHIVE_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

