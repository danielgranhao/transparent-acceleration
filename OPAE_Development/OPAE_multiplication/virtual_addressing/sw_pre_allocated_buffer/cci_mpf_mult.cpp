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

using namespace opae::fpga::types;
using namespace opae::fpga::bbb::mpf::types;


int main(int argc, char *argv[])
{
    // Find and connect to the accelerator
    OPAE_SVC_WRAPPER fpga(AFU_ACCEL_UUID);
    assert(fpga.isOk());

    // Connect the CSR manager
    CSR_MGR csrs(fpga);



    volatile uint64_t buf = 0;
    printf("buf addr is %p\n", &buf);
    printf("buf addr is %" PRIu64 "\n", (uint64_t)&buf);
    
    printf("pagesize = %d\n", getpagesize());

   // if(fpgaPrepareBuffer(*fpga.accel, sizeof(uint64_t), (void**)&buf, NULL, FPGA_BUF_PREALLOCATED) != FPGA_OK){
//	    cout << "Error preparing buffer" << endl;
//	    return 0;
  //  }

   if (!mpfVtpIsAvailable(*fpga.mpf)) {
       cout << "Error MPF VTP not available" << endl;
   }
   
    const size_t p_mask = mpfPageSizeEnumToBytes(MPF_VTP_PAGE_4KB) - 1; 
    volatile uint64_t *buf_ptr = &buf;
    //uint64_t *buf_ptr2 =(uint64_t*)( (uint64_t)buf_ptr & p_mask);

//   fpga_result res = mpfVtpPrepareBuffer(*fpga.mpf, sizeof(uint64_t), (void**)&buf_ptr, FPGA_BUF_PREALLOCATED);
//   fpga_result res = mpfVtpPrepareBuffer(*fpga.mpf, sizeof(uint64_t), (void**)&buf_ptr, FPGA_BUF_PREALLOCATED);
//   ASSERT_FPGA_OK(res);

   shared_buffer::ptr_t xpto;
//   xpto = mpf_shared_buffer::attach(fpga.mpf, (uint8_t*)buf_ptr, sizeof(uint64_t));
   xpto = mpf_shared_buffer::attach(fpga.mpf, (uint8_t*)buf_ptr, getpagesize());


    // Allocate a single page memory buffer
    //auto buf_handle = fpga.allocBuffer(getpagesize());
    //auto *buf = reinterpret_cast<volatile uint64_t*>(buf_handle->c_type());
    //uint64_t buf_pa = buf_handle->io_address();
    //assert(NULL != buf);

    // Set the low byte of the shared buffer to 0.  The FPGA will write
    // a non-zero value to it.
    buf = 0;

    // Tell the accelerator the address of the buffer using cache line
    // addresses by writing to application CSR 0.  The CSR manager maps
    // its registers to MMIO space.  The accelerator will respond by
    // writing to the buffer.
    csrs.writeCSR(0, (uint64_t)(&buf) / CL(1));
    csrs.writeCSR(1, 5);
    csrs.writeCSR(2, 10);

    // Spin, waiting for the value in memory to change to something non-zero.
    while (0 == buf)
    {
        // A well-behaved program would use _mm_pause(), nanosleep() or
        // equivalent to save power here.
    };

    // Print the string written by the FPGA
    printf("%" PRIu64 "\n", buf);
    //cout << buf << endl;

    // Ask the FPGA-side CSR manager the AFU's frequency
    cout << endl
         << "# AFU frequency: " << csrs.getAFUMHz() << " MHz"
         << (fpga.hwIsSimulated() ? " [simulated]" : "")
         << endl;

    // All shared buffers are automatically released and the FPGA connection
    // is closed when their destructors are invoked here.
    return 0;
}
