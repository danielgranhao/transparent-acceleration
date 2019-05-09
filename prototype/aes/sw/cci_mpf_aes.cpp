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

using namespace std;

#include "opae_svc_wrapper.h"
#include "csr_mgr.h"

// State from the AFU's JSON file, extracted using OPAE's afu_json_mgr script
#include "afu_json_info.h"

#include "aes.hpp"


#define DATA_LENGTH 4096

int main(int argc, char *argv[])
{


	/*uint8_t key[32] = { 0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81,
	  0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4 };
	  uint8_t in[64]  = { 0x60, 0x1e, 0xc3, 0x13, 0x77, 0x57, 0x89, 0xa5, 0xb7, 0xa7, 0xf5, 0x04, 0xbb, 0xf3, 0xd2, 0x28, 
	  0xf4, 0x43, 0xe3, 0xca, 0x4d, 0x62, 0xb5, 0x9a, 0xca, 0x84, 0xe9, 0x90, 0xca, 0xca, 0xf5, 0xc5, 
	  0x2b, 0x09, 0x30, 0xda, 0xa2, 0x3d, 0xe9, 0x4c, 0xe8, 0x70, 0x17, 0xba, 0x2d, 0x84, 0x98, 0x8d, 
	  0xdf, 0xc9, 0xc5, 0x8d, 0xb6, 0x7a, 0xad, 0xa6, 0x13, 0xc2, 0xdd, 0x08, 0x45, 0x79, 0x41, 0xa6 };
	  uint8_t iv[16]  = { 0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff };
	  uint8_t out[64] = { 0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a,
	  0xae, 0x2d, 0x8a, 0x57, 0x1e, 0x03, 0xac, 0x9c, 0x9e, 0xb7, 0x6f, 0xac, 0x45, 0xaf, 0x8e, 0x51,
	  0x30, 0xc8, 0x1c, 0x46, 0xa3, 0x5c, 0xe4, 0x11, 0xe5, 0xfb, 0xc1, 0x19, 0x1a, 0x0a, 0x52, 0xef,
	  0xf6, 0x9f, 0x24, 0x45, 0xdf, 0x4f, 0x9b, 0x17, 0xad, 0x2b, 0x41, 0x7b, 0xe6, 0x6c, 0x37, 0x10 };
	  */

	uint8_t key[32] = {0};
	uint8_t in[64] = {0};
	uint8_t iv[16] = {0};

	struct AES_ctx ctx;

	AES_init_ctx_iv(&ctx, key, iv);
	AES_CTR_xcrypt_buffer(&ctx, in, 64);

	//printf("CTR %s: ", xcrypt);
	/*
	   if (0 == memcmp((char *) out, (char *) in, 64)) {
	   printf("SUCCESS!\n");
	   return(0);
	   } else {
	   printf("FAILURE!\n");
	   return(1);
	   }*/




	uint8_t in_acc[64] = {0};

	// Find and connect to the accelerator
	OPAE_SVC_WRAPPER fpga(AFU_ACCEL_UUID);
	assert(fpga.isOk());

	// Connect the CSR manager
	CSR_MGR csrs(fpga);

	printf("Page size is %d\n", getpagesize());

	// Allocate 8 pages memory buffer
	auto buf_src_handle = fpga.allocBuffer(getpagesize() * 8);
	auto *buf_src = reinterpret_cast<volatile uint64_t*>(buf_src_handle->c_type());
	uint64_t buf_src_pa = buf_src_handle->io_address();
	assert(NULL != buf_src);

	printf("Buf src virtual address is %p\n", buf_src);

	// Allocate 8 pages  memory buffer
	auto buf_dest_handle = fpga.allocBuffer(getpagesize() * 8);
	auto *buf_dest = reinterpret_cast<volatile uint64_t*>(buf_dest_handle->c_type());
	uint64_t buf_dest_pa = buf_dest_handle->io_address();
	assert(NULL != buf_dest);
	*(buf_dest+DATA_LENGTH-1) = 0;

	printf("Buf dest virtual address is %p\n", buf_dest);

	csrs.writeCSR(0, (uint64_t)buf_src); // Address of src
	csrs.writeCSR(1, (uint64_t)buf_dest); // Address of dest
	//csrs.writeCSR(2, (uint64_t)(DATA_LENGTH/8)); // How many cache lines?
	csrs.writeCSR(2, (uint64_t)1); // How many cache lines?
	// Need to check how to converto from uint8_t array to uint64_t
	csrs.writeCSR(4, (uint64_t)*(uint64_t*)iv); // IV 0
	csrs.writeCSR(5, (uint64_t)*(uint64_t*)(iv+8)); // IV 1
	csrs.writeCSR(6, (uint64_t)*(uint64_t*)key); // key 0
	csrs.writeCSR(7, (uint64_t)*(uint64_t*)(key+8)); // key 1
	csrs.writeCSR(8, (uint64_t)*(uint64_t*)(key+16)); // key 2
	csrs.writeCSR(9, (uint64_t)*(uint64_t*)(key+24)); // key 3
	csrs.writeCSR(3, (uint64_t)1); // Run signal

	// Spin, waiting for the value in memory to change to something non-zero.
	while (0 == csrs.readCSR(0))
	{
		// A well-behaved program would use _mm_pause(), nanosleep() or
		// equivalent to save power here.
	};

	printf("Data received!\n");

	if (0 == memcmp((char *) buf_dest, (char *) in, 64)) {
		printf("SUCCESS!\n");
	} else {
		printf("FAILURE!\n");
	}


	printf("Tests finished!\n");

	// Ask the FPGA-side CSR manager the AFU's frequency
	cout << endl
		<< "# AFU frequency: " << csrs.getAFUMHz() << " MHz"
		<< (fpga.hwIsSimulated() ? " [simulated]" : "")
		<< endl;

	// All shared buffers are automatically released and the FPGA connection
	// is closed when their destructors are invoked here.
	return 0;

}
