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
#include "afu_json_info.h"

#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC
#endif

EXTERNC void aes_ctr_acc(

/*[[[cog
import cog
import json

with open(DESCRIPTION) as f:
	data = json.load(f)


for x in range(data["inoutStreamsNumber"]):
	if data["outStatic"]["n"] == 0 and data["inStatic"]["n"] == 0 and data["outStreamsNumber"] == 0 and data["inStreamsNumber"] == 0 and x == data["inoutStreamsNumber"] - 1:
		cog.outl("uint8_t* inout_stream_%d," % x)
		cog.outl("uint64_t inout_stream_%d_size" % x)
	else:
		cog.outl("uint8_t* inout_stream_%d," % x)
		cog.outl("uint64_t inout_stream_%d_size," % x)
for x in range(data["inStreamsNumber"]):
	if data["outStatic"]["n"] == 0 and data["inStatic"]["n"] == 0 and data["outStreamsNumber"] == 0 and x == data["inStreamsNumber"] - 1:
		cog.outl("uint8_t* in_stream_%d," % x)
		cog.outl("uint64_t in_stream_%d_size" % x)
	else:
		cog.outl("uint8_t* in_stream_%d," % x)
		cog.outl("uint64_t in_stream_%d_size," % x)
for x in range(data["outStreamsNumber"]):
	if data["outStatic"]["n"] == 0 and data["inStatic"]["n"] == 0 and x == data["outStreamsNumber"] - 1:
		cog.outl("uint8_t* out_stream_%d," % x)
		cog.outl("uint64_t out_stream_%d_size" % x)
	else:
		cog.outl("uint8_t* out_stream_%d," % x)
		cog.outl("uint64_t out_stream_%d_size," % x)
for x in range(data["inStatic"]["n"]):
	if data["outStatic"]["n"] == 0 and x == data["inStatic"]["n"] - 1:
		if data["inStatic"]["sizes"][x] == 1:
			cog.outl("uint64_t in_static_%d" % x)
		else:
			cog.outl("uint64_t* in_static_%d" % x)
	else:
		if data["inStatic"]["sizes"][x] == 1:
			cog.outl("uint64_t in_static_%d," % x)
		else:
			cog.outl("uint64_t* in_static_%d," % x)
for x in range(data["outStatic"]["n"]):
	if x < data["outStatic"]["n"] - 1:
		cog.outl("uint64_t* out_static_%d," % x)
	else:
		cog.outl("uint64_t* out_static_%d" % x)

]]]*/
uint8_t* inout_stream_0,
uint64_t inout_stream_0_size,
uint64_t* in_static_0,
uint64_t* in_static_1
//[[[end]]]
	) 
{

	// Find and connect to the accelerator
	OPAE_SVC_WRAPPER fpga(AFU_ACCEL_UUID);
	assert(fpga.isOk());

	// Connect the CSR manager
	CSR_MGR csrs(fpga);
	
/*[[[cog
import cog
import json

with open(DESCRIPTION) as f:
	data = json.load(f)

for x in range(data["inoutStreamsNumber"]):
	cog.outl("auto inout_stream_%d_handle = fpga.attachBuffer(inout_stream_%d, getpagesize() * ((inout_stream_%d_size/4096)+1));" % (x, x, x))
for x in range(data["inStreamsNumber"]):
	cog.outl("auto in_stream_%d_handle = fpga.attachBuffer(in_stream_%d, getpagesize() * ((in_stream_%d_size/4096)+1));" % (x, x, x))
for x in range(data["outStreamsNumber"]):
	cog.outl("auto out_stream_%d_handle = fpga.attachBuffer(out_stream_%d, getpagesize() * ((out_stream_%d_size/4096)+1));" % (x, x, x))

]]]*/
auto inout_stream_0_handle = fpga.attachBuffer(inout_stream_0, getpagesize() * ((inout_stream_0_size/4096)+1));
//[[[end]]]



/*[[[cog
import cog
import json

with open(DESCRIPTION) as f:
	data = json.load(f)

i = 1

for x in range(data["inoutStreamsNumber"]):
	cog.outl("csrs.writeCSR(%d, (uint64_t)inout_stream_%d);" % (i, x))
	i += 1
	cog.outl("csrs.writeCSR(%d, (uint64_t)inout_stream_%d_size);" % (i, x))
	i += 1

for x in range(data["inStreamsNumber"]):
	cog.outl("csrs.writeCSR(%d, (uint64_t)in_stream_%d);" % (i, x))
	i += 1
	cog.outl("csrs.writeCSR(%d, (uint64_t)in_stream_%d_size);" % (i, x))
	i += 1

for x in range(data["outStreamsNumber"]):
	cog.outl("csrs.writeCSR(%d, (uint64_t)out_stream_%d);" % (i, x))
	i += 1
	cog.outl("csrs.writeCSR(%d, (uint64_t)out_stream_%d_size);" % (i, x))
	i += 1

for x in range(data["inStatic"]["n"]):
	for y in range(data["inStatic"]["sizes"][x]):
		cog.outl("csrs.writeCSR(%d, (uint64_t)in_static_%d[%d]);" % (i, x, y))
		i += 1

]]]*/
csrs.writeCSR(1, (uint64_t)inout_stream_0);
csrs.writeCSR(2, (uint64_t)inout_stream_0_size);
csrs.writeCSR(3, (uint64_t)in_static_0[0]);
csrs.writeCSR(4, (uint64_t)in_static_0[1]);
csrs.writeCSR(5, (uint64_t)in_static_1[0]);
csrs.writeCSR(6, (uint64_t)in_static_1[1]);
csrs.writeCSR(7, (uint64_t)in_static_1[2]);
csrs.writeCSR(8, (uint64_t)in_static_1[3]);
//[[[end]]]

	csrs.writeCSR(0, (uint64_t)1); // Run signal

	// Spin, waiting FPGA to finish
	while (0 == csrs.readCSR(0))_mm_pause();


/*[[[cog
import cog
import json

with open(DESCRIPTION) as f:
	data = json.load(f)

for x in range(data["outStatic"]["n"]):
	cog.outl("*out_static_%d = csrs.readCSR(%d);" % (x, x+1))

]]]*/
//[[[end]]]

	return; 
}
