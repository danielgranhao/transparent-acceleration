//
// Copyright (c) 2017, Intel Corporation
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// Neither the name of the Intel Corporation nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>

#include <inttypes.h>
#include <uuid/uuid.h>

#include <iostream>
#include <string>
#include <bits/stdc++.h> 

using namespace std;

#include "opae_svc_wrapper.h"
#include "csr_mgr.h"

// State from the AFU's JSON file, extracted using OPAE's afu_json_mgr script
#include "afu_json_info.h"

#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC
#endif

EXTERNC void aes_ctr_acc(uint8_t key[], uint8_t iv[], uint8_t volatile data[], uint32_t length) {

	// Find and connect to the accelerator
	OPAE_SVC_WRAPPER fpga(AFU_ACCEL_UUID);
	assert(fpga.isOk());

	// Connect the CSR manager
	CSR_MGR csrs(fpga);

	//printf("Page size is %d\n", getpagesize());

	
	// Allocate 8 pages memory buffer
	auto data_handle = fpga.allocBuffer(getpagesize() * (length/4096));
	auto *data_fpga = reinterpret_cast<volatile uint8_t*>(data_handle->c_type());
	//uint64_t buf_src_pa = buf_src_handle->io_address();
	assert(NULL != data_fpga);

	for(int i = 0; i<length; i++){
		data_fpga[i] = data[i]; 
	}
	
	// Allocate 8 pages memory buffer
	auto data_handle_2 = fpga.allocBuffer(getpagesize() * (length/4096));
	auto *data_fpga_2 = reinterpret_cast<volatile uint8_t*>(data_handle_2->c_type());
	//uint64_t buf_src_pa = buf_src_handle->io_address();
	assert(NULL != data_fpga_2);


	/*
	//printf("Buf src virtual address is %p\n", buf_src);

	// Allocate 8 pages  memory buffer
	auto buf_dest_handle = fpga.allocBuffer(getpagesize() * ((DATA_LENGTH)/4096));
	auto *buf_dest = reinterpret_cast<volatile uint8_t*>(buf_dest_handle->c_type());
	uint64_t buf_dest_pa = buf_dest_handle->io_address();
	assert(NULL != buf_dest);
	 *(buf_dest+(DATA_LENGTH)-1) = 0;

	 printf("Buf dest virtual address is %p\n", buf_dest);
	 */

	csrs.writeCSR(0, (uint64_t)data_fpga); // Address of src
	csrs.writeCSR(1, (uint64_t)data_fpga_2); // Address of dest
	csrs.writeCSR(2, (uint64_t)(length/64)); // How many cache lines?
	//csrs.writeCSR(2, (uint64_t)1); // How many cache lines?
	// Need to check how to convert from uint8_t array to uint64_t
	csrs.writeCSR(4, (uint64_t)*(uint64_t*)iv); // IV 0
	csrs.writeCSR(5, (uint64_t)*(uint64_t*)(iv+8)); // IV 1
	csrs.writeCSR(6, (uint64_t)*(uint64_t*)key); // key 0
	csrs.writeCSR(7, (uint64_t)*(uint64_t*)(key+8)); // key 1
	csrs.writeCSR(8, (uint64_t)*(uint64_t*)(key+16)); // key 2
	csrs.writeCSR(9, (uint64_t)*(uint64_t*)(key+24)); // key 3
	csrs.writeCSR(3, (uint64_t)1); // Run signal

	// Spin, waiting for the value in memory to change to something non-zero.
	while (0 == csrs.readCSR(0))_mm_pause();

	for(int i = 0; i<length; i++){
		data[i] = data_fpga_2[i]; 
	}

	//printf("Data received!\n");

	return; 

}
