##
## Common sw build rules
##

COPT     ?= -g -O2
CPPFLAGS ?= -std=c++11
CXX      ?= g++
LDFLAGS  ?=

ifeq (,$(CFLAGS))
CFLAGS = $(COPT)
endif

ifneq (,$(ndebug))
else
CPPFLAGS += -DENABLE_DEBUG=1
endif
ifneq (,$(nassert))
else
CPPFLAGS += -DENABLE_ASSERT=1
endif

# stack execution protection
LDFLAGS +=-z noexecstack

# data relocation and projection
LDFLAGS +=-z relro -z now

# stack buffer overrun detection
# Note that CentOS 7 has gcc 4.8 by default.  When we switch
# to a system with gcc 4.9 or newer this should be changed to
# CFLAGS="-fstack-protector-strong"
CFLAGS +=-fstack-protector

# Position independent execution
CFLAGS +=-fPIE -fPIC
LDFLAGS +=-pie

# fortify source
CFLAGS +=-D_FORTIFY_SOURCE=2

# format string vulnerabilities
CFLAGS +=-Wformat -Wformat-security

ifeq (,$(DESTDIR))
ifneq (,$(prefix))
CPPFLAGS += -I$(prefix)/include
LDFLAGS  += -L$(prefix)/lib -Wl,-rpath-link -Wl,$(prefix)/lib -Wl,-rpath -Wl,$(prefix)/lib \
            -L$(prefix)/lib64 -Wl,-rpath-link -Wl,$(prefix)/lib64 -Wl,-rpath -Wl,$(prefix)/lib64
endif
else
ifeq (,$(prefix))
prefix = /usr/local
endif
CPPFLAGS += -I$(DESTDIR)$(prefix)/include
LDFLAGS  += -L$(DESTDIR)$(prefix)/lib -Wl,-rpath-link -Wl,$(prefix)/lib -Wl,-rpath -Wl,$(DESTDIR)$(prefix)/lib \
            -L$(DESTDIR)$(prefix)/lib64 -Wl,-rpath-link -Wl,$(prefix)/lib64 -Wl,-rpath -Wl,$(DESTDIR)$(prefix)/lib64
endif

LDFLAGS += -luuid

FPGA_LIBS = -lopae-c
ASE_LIBS = -lopae-c-ase

BASE_FILE_PATH = base/sw
BASE_FILE_SRC = opae_svc_wrapper.cpp
BASE_FILE_INC = $(BASE_FILE_PATH)/opae_svc_wrapper.h $(BASE_FILE_PATH)/csr_mgr.h

VPATH = .:$(BASE_FILE_PATH)

CPPFLAGS += -Ibase/sw
LDFLAGS += -lMPF-cxx -lMPF -lopae-cxx-core -shared

# Primary test name
TEST = mult

# Build directory
OBJDIR = obj
CFLAGS += -I./$(OBJDIR)
CPPFLAGS += -I./$(OBJDIR)

# Files and folders
SRCS = $(TEST).cpp $(BASE_FILE_SRC)
OBJS = $(addprefix $(OBJDIR)/,$(patsubst %.cpp,%.o,$(SRCS)))

# Targets
all: lib$(TEST).so lib$(TEST)_ase.so

# AFU info from JSON file, including AFU UUID
AFU_JSON_INFO = $(OBJDIR)/afu_json_info.h
$(AFU_JSON_INFO): $(TEST).json | objdir
	afu_json_mgr json-info --afu-json=$^ --c-hdr=$@
$(OBJS): $(AFU_JSON_INFO)

lib$(TEST).so: $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS) $(FPGA_LIBS)

lib$(TEST)_ase.so: $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS) $(ASE_LIBS)

$(OBJDIR)/%.o: %.cpp | objdir
	$(CXX) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

clean:
	rm -rf lib$(TEST).so lib$(TEST)_ase.so $(OBJDIR)

objdir:
	@mkdir -p $(OBJDIR)

.PHONY: all clean
