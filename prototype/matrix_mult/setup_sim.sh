#!/bin/bash


python /usr/local/share/opae/ase/scripts/ipc_clean.py
afu_sim_setup -f -s hw/rtl/sources.txt -p intg_xeon -t VCS build_sim
cd build_sim
sed -i '237s/UNKNOWN/arria10/' Makefile
make
make sim
