PIC_LD=ld

ARCHIVE_OBJS=
ARCHIVE_OBJS += _21632_archive_1.so
_21632_archive_1.so : archive.0/_21632_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_21632_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_21632_archive_1.so $@


ARCHIVE_OBJS += _21910_archive_1.so
_21910_archive_1.so : archive.0/_21910_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_21910_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_21910_archive_1.so $@


ARCHIVE_OBJS += _21912_archive_1.so
_21912_archive_1.so : archive.0/_21912_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_21912_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_21912_archive_1.so $@


ARCHIVE_OBJS += _21913_archive_1.so
_21913_archive_1.so : archive.0/_21913_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_21913_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_21913_archive_1.so $@






%.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

MAIN_OBJS = \
objs/amcQw_d.o 

CU_OBJS = $(MAIN_OBJS) $(ARCHIVE_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

