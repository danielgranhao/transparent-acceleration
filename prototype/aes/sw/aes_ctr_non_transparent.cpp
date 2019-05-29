#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <inttypes.h>
#include <iostream>
#include <string>
#include <bits/stdc++.h> 
#include <time.h>


#include "tiny-AES-c/aes.hpp"

#include "libaesni/iaesni.h"
#include <memory.h>
#include <malloc.h>

extern "C"{
#include "to_inject/aes_ctr_acc.h"
}
using namespace std;

#define DATA_LENGTH 32*4096//1048576 //4096

timespec diff(timespec start, timespec end)
{
    timespec temp;
    if ((end.tv_nsec-start.tv_nsec)<0) {
        temp.tv_sec = end.tv_sec-start.tv_sec-1;
        temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
    } else {
        temp.tv_sec = end.tv_sec-start.tv_sec;
        temp.tv_nsec = end.tv_nsec-start.tv_nsec;
    }
    return temp;
}

void aes_ctr_soft(uint8_t key[], uint8_t iv[], uint8_t data[], uint32_t length){
	struct AES_ctx ctx;
	AES_init_ctx_iv(&ctx, key, iv);
	AES_CTR_xcrypt_buffer(&ctx, data, length);
}

void aes_ctr_soft_intel_ni(uint8_t key[], uint8_t iv[], uint8_t data[], uint32_t length){
	enc_256_CTR(data, data, key, iv, length / 16);
}

int main(int argc, char *argv[])
{

	long x = 0;
        while(x< 1000000000) x++;

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
	
	uint8_t key[32] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	  		    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
	uint8_t iv[16]  = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
	//
	// Allocation in the heap does not work below 32*4096 bytes..
	//
	//uint8_t in_control[(DATA_LENGTH)] = {0};
	//uint8_t in[(DATA_LENGTH)] __attribute__((aligned (64))) = {0};
	uint8_t* in_control = (uint8_t*)aligned_alloc(64, (DATA_LENGTH));
	uint8_t* in_acc = (uint8_t*)aligned_alloc(getpagesize(), (DATA_LENGTH));
	uint8_t* in_ni = (uint8_t*)aligned_alloc(64, (DATA_LENGTH));
	// All bytes equal so that problems related to byte order don't show up
	memset(in_control, 0, (DATA_LENGTH));
	memset(in_acc, 0, (DATA_LENGTH));
	memset(in_ni, 0, (DATA_LENGTH));

	// in_control is the standard
	aes_ctr_soft(key, iv, in_control, (DATA_LENGTH));

	// To measure execution time
	timespec start, end;

	printf("Press enter to start!\n");
	scanf("\n");

	clock_gettime(CLOCK_MONOTONIC, &start);
	aes_ctr_acc(in_acc, (uint64_t)(DATA_LENGTH), (uint64_t*)iv, (uint64_t*)key);
	clock_gettime(CLOCK_MONOTONIC, &end);


	if (0 == memcmp((char *) in_control, (char *) in_acc, (DATA_LENGTH))) {
                printf("FPGA SUCCESS!\n");
        } else {
                printf("FPGA FAILURE!\n");
        }

	cout<<"Execution time FPGA (sec:nanosecs): "<<diff(start,end).tv_sec<<":"<<diff(start,end).tv_nsec<<endl;	

	//clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
	clock_gettime(CLOCK_MONOTONIC, &start);
	aes_ctr_soft(key, iv, in_ni, (DATA_LENGTH));
	//clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
	clock_gettime(CLOCK_MONOTONIC, &end);


	if (0 == memcmp((char *) in_ni, (char *) in_control, (DATA_LENGTH))) {
                printf("SOFT SUCCESS!\n");
        } else {
                printf("SOFT FAILURE!\n");
        }

	cout<<"Execution time SOFTWARE (sec:nanosecs): "<<diff(start,end).tv_sec<<":"<<diff(start,end).tv_nsec<<endl;	
	
	/*for(int i = 0; i < DATA_LENGTH; i++){
		if(in[i] != in_control[i])
			printf("ERROR on pos %d - must be %d and is %d\n", i, in_control[i], in[i]);
		//else
		//	printf("OK!!  on pos %d - %f^2 != %f\n", i, *(buf_src+i), *(buf_dest+i));

	}
	
	printf("Tests finished!\n");*/

	//cout<<"Execution time (sec:nanosecs): "<<diff(start,end).tv_sec<<":"<<diff(start,end).tv_nsec<<endl;

	return 0;
}
