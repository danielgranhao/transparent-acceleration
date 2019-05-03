#!/bin/bash

export OPAE_PLATFORM_ROOT=/home/daniel/intel-fpga/SR-5.0.3-Release/
afu_synth_setup -s hw/rtl/sources.txt build_synth
cd build_synth
sh /home/daniel/intel-fpga/SR-5.0.3-Release/bin/run.sh
