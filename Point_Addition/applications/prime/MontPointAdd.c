#include <asm-generic/fcntl.h>
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <stdint.h>
#include <inttypes.h>

#include "../../include/cryptocore_ioctl_header.h"

/* Prototypes for functions used to access physical memory addresses */
int open_physical (int);
void close_physical (int);

int main(void)
{
	int dd = -1;
	int ret_val;

	__u32 trng_val = 0;
	__u32 i = 0;
	
	double seconds;
	struct timespec tstart={0,0}, tend={0,0};

	if ((dd = open_physical (dd)) == -1)
      return (-1);

// Stop TRNG and clear FIFO
	trng_val = 0x00000010;
	ret_val = ioctl(dd, IOCTL_SET_TRNG_CMD, &trng_val);
	if(ret_val != 0) {
		printf("Error occured3\n");
	}

	usleep(10);

// Configure Feedback Control Polynomial
	trng_val = 0x0003ffff;
	ret_val = ioctl(dd, IOCTL_SET_TRNG_CTR, &trng_val);
	if(ret_val != 0) {
		printf("Error occured4\n");
	}

// Configure Stabilisation Time
	trng_val = 0x00000050;
	ret_val = ioctl(dd, IOCTL_SET_TRNG_TSTAB, &trng_val);
	if(ret_val != 0) {
		printf("Error occured5\n");
	}

// Configure Sample Time
	trng_val = 0x00000006;
	ret_val = ioctl(dd, IOCTL_SET_TRNG_TSAMPLE, &trng_val);
	if(ret_val != 0) {
		printf("Error occured6\n");
	}

// Start TRNG
	trng_val = 0x00000001;
	ret_val = ioctl(dd, IOCTL_SET_TRNG_CMD, &trng_val);
	if(ret_val != 0) {
		printf("Error occured7\n");
	}

	usleep(10);

	MontPointAdd_params_t MontPointAdd_192_test = { 192,
	1,	
	0,
	{ 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 
	  0xffffffff, 0xffffffff },
	{ 0X8424355F,0X0E9D7146,0X290F4F32,0X94D6EF2E,
	  0X0A5B6469,0X6897FF13}, 
	{ 0X7F97E6C1,0X51758BBD,0X4AD62814,0XAE74DDF3,
      0XD828E447,0X39348640},
	{ 0XCC839AE1,0X32627452,0X8B8E1741,0X7A55501A,
      0X53B37577,0X15272C5F},
	{ 0XF35AFA14,0X3B715886,0XF91803F6,0X0FD2AFD6,
     0XEF8D8E27,0XB645DCCC},
	{ 0x00000000, 0x00000000, 0x00000000, 0x00000000,
	  0x00000000, 0x00000002 },
	{   },
	{   },
	};
	
	// Read random a from TRNG FIRO
	//i = 0;
	//while (i < MontPointD_192_test.prec/32) {
	//	ret_val = ioctl(dd, IOCTL_READ_TRNG_FIFO, &trng_val);
	//	if(ret_val == 0) {
	//		MontPointD_192_test.a[i] = trng_val;
	//		i++;
	//	} else if (ret_val == -EAGAIN) {
	//		printf("TRNG FIFO empty\n");
	//	} else {
	//		printf("Error occured\n");
	//	}
	//}
	
	printf("xp: 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.xp[i]);
	}
	printf("\n\n");
	
	// Read random b from TRNG FIRO
	//i = 0;
	//while (i < MontPointD_192_test.prec/32) {
	//	ret_val = ioctl(dd, IOCTL_READ_TRNG_FIFO, &trng_val);
	//	if(ret_val == 0) {
	//		MontPointD_192_test.b[i] = trng_val;
	//		i++;
	//	} else if (ret_val == -EAGAIN) {
	//		printf("TRNG FIFO empty\n");
	//	} else {
	//		printf("Error occured\n");
	//	}
	//}	
	printf("yp: 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.yp[i]);
	}
	printf("\n\n");	
	
	printf("xq: 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.xq[i]);
	}
	printf("\n\n");
	
	printf("yq: 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.yq[i]);
	}
	printf("\n\n");	

	printf("N: 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.n[i]);
	}
	printf("\n\n");	
	
	clock_gettime(CLOCK_MONOTONIC, &tstart);
	ret_val = ioctl(dd, IOCTL_MWMAC_MONTPOINTADD, &MontPointAdd_192_test);
	if(ret_val != 0) {
		printf("Error occured1\n");
	}
	clock_gettime(CLOCK_MONOTONIC, &tend);

	printf("xr = MontPointAdd(xp,yp,N): 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.xr[i]);
	}
	printf("\n\n");
	printf("yr = MontPointAdd(xp,yp,N): 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.yr[i]);
	}
	printf("\n\n");

	
	seconds = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
	if (seconds*1000000.0 > 1000.0)
		printf("MontPointAdd 192 took about %.5f ms\n\n", seconds*1000.0);
	else 
		printf("MontPointAdd 192 took about %.5f us\n\n", seconds*1000000.0);	

	// Clear xr and yr
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		MontPointAdd_192_test.xr[i] = 0;
	}
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		MontPointAdd_192_test.yr[i] = 0;
	}	
	
	MontPointAdd_192_test.sec_calc = 1;		

	clock_gettime(CLOCK_MONOTONIC, &tstart);
	ret_val = ioctl(dd, IOCTL_MWMAC_MONTPOINTADD, &MontPointAdd_192_test);
	if(ret_val != 0) {
		printf("Error occured2\n");
	}
	clock_gettime(CLOCK_MONOTONIC, &tend);

	printf("xr = MontPointAdd(xp,yp,N): 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.xr[i]);
	}
	printf("\n\n");
	
	printf("yr = MontPointAdd(xp,yp,N): 0x");
	for(i=0; i<MontPointAdd_192_test.prec/32; i++){
		printf("%08x", MontPointAdd_192_test.yr[i]);
	}
	printf("\n\n");

	seconds = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
	if (seconds*1000000.0 > 1000.0)
		printf("MontPointD 192 (sec calc) took about %.5f ms\n\n", seconds*1000.0);
	else 
		printf("MontPointD 192 (sec calc) took about %.5f us\n\n", seconds*1000000.0);	
	
	close_physical (dd);   // close /dev/cryptocore
	return 0;
}

// Open /dev/cryptocore, if not already done, to give access to physical addresses
int open_physical (int dd)
{
   if (dd == -1)
      if ((dd = open( "/dev/cryptocore", (O_RDWR | O_SYNC))) == -1)
      {
         printf ("ERROR: could not open \"/dev/cryptocore\"...\n");
         return (-1);
      }
   return dd;
}

// Close /dev/cryptocore to give access to physical addresses
void close_physical (int dd)
{
   close (dd);
}
