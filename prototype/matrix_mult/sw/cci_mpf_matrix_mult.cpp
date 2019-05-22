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

#include "cblas/cblas.h"


#define DATA_LENGTH 	1024

// SIZE(A) = SIZE(B) = 32 * 32
#define M_CL 		2
#define N_CL		2
#define K_CL		2

#define FLOAT_PER_CL	16

int main(int argc, char *argv[])
{
	printf("Page size is %d\n", getpagesize());


	volatile float *A, *B, *C;
	float *A_t, *B_t, *C_t;
	int m, n, k, i, j;

	m = M_CL*FLOAT_PER_CL;
	n = N_CL*FLOAT_PER_CL;
	k = K_CL*FLOAT_PER_CL;

	printf (" Initializing data for matrix multiplication C=A*B for matrix \n"
	    " A(%ix%i) and matrix B(%ix%i)\n\n", m, k, k, n);


	// Test in software

	enum CBLAS_ORDER order;
   	enum CBLAS_TRANSPOSE transa;
	enum CBLAS_TRANSPOSE transb;

	order = CblasColMajor;
	transa = CblasNoTrans;
	transb = CblasTrans;
	
	float alpha = 1.0;
	int lda = k;
	int ldb = n;
	float beta = 0.0;
	int ldc = n;

	A_t = (float *)aligned_alloc( 64, m*k*sizeof( float ) );
	B_t = (float *)aligned_alloc( 64, k*n*sizeof( float ) );
	C_t = (float *)aligned_alloc( 64, m*n*sizeof( float ) );
	if (A_t == NULL || B_t == NULL || C_t == NULL) {
		printf( "\n ERROR: Can't allocate memory for test matrices. Aborting... \n\n");
		free(A_t);
		free(B_t);
		free(C_t);
		return 1;
	}

	printf (" Intializing test matrix data \n\n");
	for (i = 0; i < (m*k); i++) {
		A_t[i] = (float)(i+1);
	}

	for (i = 0; i < (k*n); i++) {
		B_t[i] = (float)(-i-1);
	}

	for (i = 0; i < (m*n); i++) {
		C_t[i] = 0.0;
	}

	cblas_sgemm(order, transa,
                 transb, m, n,
                 k, alpha, A_t,
                 lda, B_t, ldb,
                 beta, C_t, ldc);
	
	printf (" Test multiplication done! \n\n");

	// Find and connect to the accelerator
	OPAE_SVC_WRAPPER fpga(AFU_ACCEL_UUID);
	assert(fpga.isOk());

	// Connect the CSR manager
	CSR_MGR csrs(fpga);

	auto A_handle = fpga.allocBuffer(getpagesize() * 1);
	A = reinterpret_cast<volatile float*>(A_handle->c_type());
	uint64_t A_pa = A_handle->io_address();
	assert(NULL != A);
	
	auto B_handle = fpga.allocBuffer(getpagesize() * 1);
	B = reinterpret_cast<volatile float*>(B_handle->c_type());
	uint64_t B_pa = B_handle->io_address();
	assert(NULL != B);

	auto C_handle = fpga.allocBuffer(getpagesize() * 1);
	C = reinterpret_cast<volatile float*>(C_handle->c_type());
	uint64_t C_pa = C_handle->io_address();
	assert(NULL != C);
	

	printf (" Intializing matrix data \n\n");
	for (i = 0; i < (m*k); i++) {
		A[i] = (float)(i+1);
	}

	for (i = 0; i < (k*n); i++) {
		B[i] = (float)(-i-1);
	}

	for (i = 0; i < (m*n); i++) {
		C[i] = 0.0;
	}

	
	/*// Allocate 8 pages memory buffer
	auto buf_src_handle = fpga.allocBuffer(getpagesize() * 1);
	auto *buf_src = reinterpret_cast<volatile float*>(buf_src_handle->c_type());
	uint64_t buf_src_pa = buf_src_handle->io_address();
	assert(NULL != buf_src);*/

	/*float buf_src[(DATA_LENGTH)] __attribute__((aligned(64))) = {0};*/
	/*auto buf_src_handle = fpga.attachBuffer((uint8_t*)buf_src, getpagesize() * 1);*/


	printf("Matrix A virtual address is %p\n", A);
	printf("Matrix B virtual address is %p\n", B);



	/*// Allocate 8 pages  memory buffer
	auto buf_dest_handle = fpga.allocBuffer(getpagesize() * 1);
	auto *buf_dest = reinterpret_cast<volatile float*>(buf_dest_handle->c_type());
	uint64_t buf_dest_pa = buf_dest_handle->io_address();
	assert(NULL != buf_dest);*/

	/*volatile float buf_dest[(DATA_LENGTH)] __attribute__((aligned(64)));*/
	/*auto buf_dest_handle = fpga.attachBuffer((uint8_t*)buf_dest, getpagesize() * 1);*/

	printf("Matrix C (dest) virtual address is %p\n", C);



	csrs.writeCSR(0, (uint64_t)A); // Address of A
	csrs.writeCSR(1, (uint64_t)B); // Address of B
	csrs.writeCSR(2, (uint64_t)C); // Address of C

	csrs.writeCSR(4, (uint64_t)m); // How many cache lines?
	csrs.writeCSR(5, (uint64_t)n); // How many cache lines?
	csrs.writeCSR(6, (uint64_t)k); // How many cache lines?

	csrs.writeCSR(3, (uint64_t)1); // Run signal


	//sleep(3);

	// Spin, waiting for the value in memory to change to something non-zero.
	while (0 == csrs.readCSR(0))_mm_pause();

	printf("Data received!\n");

	printf("Testing...\n");

	for (i = 0; i < (m*n); i++) {
		C_t[i] = 0.0;
		if(C_t[i] != C[i])
			printf("ERROR on pos %d || Should be %f and is %f\n", i+1, C_t[i], C[i]);
		//else
		//	printf("OK!!  on pos %d - %f^2 != %f\n", i, *(buf_src+i), *(buf_dest+i));
	}

	printf("Tests finished!\n");

	//
	//
	// Perform tests



	/*for(int i = 0; i < DATA_LENGTH; i++){
		if(*(buf_dest+i) != (*(buf_src+i)) * (*(buf_src+i)))
			printf("ERROR on pos %d - %f^2 != %f\n", i, *(buf_src+i), *(buf_dest+i));
		//else
		//	printf("OK!!  on pos %d - %f^2 != %f\n", i, *(buf_src+i), *(buf_dest+i));

	}
	
	printf("Tests finished!\n");*/

	// Ask the FPGA-side CSR manager the AFU's frequency
	/*cout << endl
		<< "# AFU frequency: " << csrs.getAFUMHz() << " MHz"
		<< (fpga.hwIsSimulated() ? " [simulated]" : "")
		<< endl;
	*/
	// All shared buffers are automatically released and the FPGA connection
	// is closed when their destructors are invoked here.
	return 0;
	
}