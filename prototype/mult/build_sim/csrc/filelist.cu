PIC_LD=ld

ARCHIVE_OBJS=
ARCHIVE_OBJS += _10703_archive_1.so
_10703_archive_1.so : archive.0/_10703_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_10703_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_10703_archive_1.so $@


ARCHIVE_OBJS += _10980_archive_1.so
_10980_archive_1.so : archive.0/_10980_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_10980_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_10980_archive_1.so $@


ARCHIVE_OBJS += _10981_archive_1.so
_10981_archive_1.so : archive.0/_10981_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_10981_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_10981_archive_1.so $@


ARCHIVE_OBJS += _10982_archive_1.so
_10982_archive_1.so : archive.0/_10982_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../work/ase_simv.daidir//_10982_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../work/ase_simv.daidir//_10982_archive_1.so $@






%.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

MAIN_OBJS = \
objs/amcQw_d.o 

CU_OBJS = $(MAIN_OBJS) $(ARCHIVE_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

