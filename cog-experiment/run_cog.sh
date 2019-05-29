#!/bin/bash

cog -D DESCRIPTION=aes.json -o cog_aes_ctr_acc.cpp to_inject_base.cpp
cog -D DESCRIPTION=aes.json -o cog_aes_manager.c manager_base.c
