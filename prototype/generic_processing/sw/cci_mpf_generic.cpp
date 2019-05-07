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

int main(int argc, char *argv[])
{
	// Find and connect to the accelerator
	OPAE_SVC_WRAPPER fpga(AFU_ACCEL_UUID);
	assert(fpga.isOk());

	// Connect the CSR manager
	CSR_MGR csrs(fpga);

	//uint8_t buf[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};

	// Allocate a single page memory buffer
	auto buf_handle = fpga.allocBuffer(getpagesize());
	auto *buf = reinterpret_cast<volatile uint64_t*>(buf_handle->c_type());
	uint64_t buf_pa = buf_handle->io_address();
	assert(NULL != buf);

	printf("Buf virtual address is %p\n", buf);

	// Set the low byte of the shared buffer to 0.  The FPGA will write
	// a non-zero value to it.
	//*buf = 1;
	//*(buf+1) = 2;

	*buf = 1;
	*(buf + 1) = 2;
	*(buf + 2) = 3;
	*(buf + 3) = 4;
	*(buf + 4) = 5;
	*(buf + 5) = 6;
	*(buf + 6) = 7;
	*(buf + 7) = 8;
	*(buf + 8) = 9;
	*(buf + 9) = 10;
	*(buf + 10) = 11;
	*(buf + 11) = 12;
	*(buf + 12) = 13;
	*(buf + 13) = 14;
	*(buf + 14) = 15;
	*(buf + 15) = 16;


	// Allocate a single page memory buffer
	auto buf_dest_handle = fpga.allocBuffer(getpagesize());
	auto *buf_dest = reinterpret_cast<volatile uint64_t*>(buf_dest_handle->c_type());
	uint64_t buf_dest_pa = buf_dest_handle->io_address();
	assert(NULL != buf_dest);

	printf("Buf dest virtual address is %p\n", buf_dest);
	


	// Tell the accelerator the address of the buffer using cache line
	// addresses by writing to application CSR 0.  The CSR manager maps
	// its registers to MMIO space.  The accelerator will respond by
	// writing to the buffer.
	//csrs.writeCSR(0, (uint64_t)buf / CL(1));
	//csrs.writeCSR(1, 5);
	//csrs.writeCSR(2, 10);
	csrs.writeCSR(0, (uint64_t)buf);
	csrs.writeCSR(1, (uint64_t)buf_dest);
	csrs.writeCSR(2, (uint64_t)2);
	csrs.writeCSR(3, (uint64_t)1);

	// Spin, waiting for the value in memory to change to something non-zero.
	//while (0 == *buf)
	while (0 == *(buf_dest+15))
	{
		// A well-behaved program would use _mm_pause(), nanosleep() or
		// equivalent to save power here.
	};

	// Print the string written by the FPGA
	//printf("%" PRIu64 "\n", *buf);
	//cout << buf << endl;

	printf("Data received!\n");
	printf("%" PRIu64 "\n", *buf_dest);
	printf("%" PRIu64 "\n", *(buf_dest+1));
	printf("%" PRIu64 "\n", *(buf_dest+2));
	printf("%" PRIu64 "\n", *(buf_dest+3));
	printf("%" PRIu64 "\n", *(buf_dest+4));
	printf("%" PRIu64 "\n", *(buf_dest+5));
	printf("%" PRIu64 "\n", *(buf_dest+6));
	printf("%" PRIu64 "\n", *(buf_dest+7));
	printf("%" PRIu64 "\n", *(buf_dest+8));
	printf("%" PRIu64 "\n", *(buf_dest+9));
	printf("%" PRIu64 "\n", *(buf_dest+10));
	printf("%" PRIu64 "\n", *(buf_dest+11));
	printf("%" PRIu64 "\n", *(buf_dest+12));
	printf("%" PRIu64 "\n", *(buf_dest+13));
	printf("%" PRIu64 "\n", *(buf_dest+14));
	printf("%" PRIu64 "\n", *(buf_dest+15));


	// Ask the FPGA-side CSR manager the AFU's frequency
	cout << endl
		<< "# AFU frequency: " << csrs.getAFUMHz() << " MHz"
		<< (fpga.hwIsSimulated() ? " [simulated]" : "")
		<< endl;

	// All shared buffers are automatically released and the FPGA connection
	// is closed when their destructors are invoked here.
	return 0;
}
