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

extern "C" uint64_t mult(uint64_t a, uint64_t b){
    // Find and connect to the accelerator
    OPAE_SVC_WRAPPER fpga(AFU_ACCEL_UUID);
    assert(fpga.isOk());

    // Connect the CSR manager
    CSR_MGR csrs(fpga);

    // Allocate a single page memory buffer
    auto buf_handle = fpga.allocBuffer(getpagesize());
    auto *buf = reinterpret_cast<volatile uint64_t*>(buf_handle->c_type());
    uint64_t buf_pa = buf_handle->io_address();
    assert(NULL != buf);

    // Set the low byte of the shared buffer to 0.  The FPGA will write
    // a non-zero value to it.
    *buf = 0;

    // Tell the accelerator the address of the buffer using cache line
    // addresses by writing to application CSR 0.  The CSR manager maps
    // its registers to MMIO space.  The accelerator will respond by
    // writing to the buffer.
    csrs.writeCSR(0, (uint64_t)buf / CL(1));
    csrs.writeCSR(1, a);
    csrs.writeCSR(2, b);

    // Spin, waiting for the value in memory to change to something non-zero.
    while (0 == *buf)
    {
        // A well-behaved program would use _mm_pause(), nanosleep() or
        // equivalent to save power here.
    };

    // Print the string written by the FPGA
    printf("%" PRIu64 "\n", *buf);
    //cout << buf << endl;

    // Ask the FPGA-side CSR manager the AFU's frequency
    cout << endl
         << "# AFU frequency: " << csrs.getAFUMHz() << " MHz"
         << (fpga.hwIsSimulated() ? " [simulated]" : "")
         << endl;

    // All shared buffers are automatically released and the FPGA connection
    // is closed when their destructors are invoked here.
    return *buf;
}
