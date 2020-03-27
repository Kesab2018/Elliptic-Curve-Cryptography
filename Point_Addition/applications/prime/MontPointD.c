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

	MontPointD_params_t MontPointD_192_test = { 192,
	1,	
	0,
	{ 0xffffffff, 0xffffffff, 0xffffffff, 0xfffffffe, 
	  0xffffffff, 0xffffffff },
	{ 0xa5e3b27e, 0xdc202644, 0x92d34c9a, 0xbc9b2181,
	  0x98603cba, 0xa856d54c },
	{ 0x68ce352a, 0xaa3942bd, 0xd8642d82, 0x6cc8d225,
	  0x401b7b3c, 0x6dd0ae6e },
	{ 0xffffffff, 0xffffffff, 0xffffffff, 0xfffffffe, 
	  0xffffffff, 0xfffffffc },
	{ 0x64210519, 0xe59c80e7, 0x0fa7e9ab, 0x72243049,
      0xfeb8deec, 0xc146b9b1 },
	{ 0x00000000, 0x00000000, 0x00000000, 0x00000000,
	  0x00000000, 0x00000002},
	{ 0x00000000, 0x00000000, 0x00000000, 0x00000000,
	  0x00000000, 0x00000003 },
	{ 0x00000000, 0x00000000, 0x00000000, 0x00000000,
	  0x00000000, 0x00000004 },
	{ 0x00000000, 0x00000000, 0x00000000, 0x00000000,
	  0x00000000, 0x00000008 },
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
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		printf("%08x", MontPointD_192_test.xp[i]);
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
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		printf("%08x", MontPointD_192_test.yp[i]);
	}
	printf("\n\n");	

	printf("N: 0x");
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		printf("%08x", MontPointD_192_test.n[i]);
	}
	printf("\n\n");	
	
	clock_gettime(CLOCK_MONOTONIC, &tstart);
	ret_val = ioctl(dd, IOCTL_MWMAC_MONTPOINTD, &MontPointD_192_test);
	if(ret_val != 0) {
		printf("Error occured1\n");
	}
	clock_gettime(CLOCK_MONOTONIC, &tend);

	printf("xr = MontPointD(xp,yp,N): 0x");
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		printf("%08x", MontPointD_192_test.xr[i]);
	}
	printf("\n\n");
	printf("yr = MontPointD(xp,yp,N): 0x");
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		printf("%08x", MontPointD_192_test.yr[i]);
	}
	printf("\n\n");

	
	seconds = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
	if (seconds*1000000.0 > 1000.0)
		printf("MontPointD 192 took about %.5f ms\n\n", seconds*1000.0);
	else 
		printf("MontPointD 192 took about %.5f us\n\n", seconds*1000000.0);	

	// Clear xr and yr
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		MontPointD_192_test.xr[i] = 0;
	}
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		MontPointD_192_test.yr[i] = 0;
	}	
	
	MontPointD_192_test.sec_calc = 1;		

	clock_gettime(CLOCK_MONOTONIC, &tstart);
	ret_val = ioctl(dd, IOCTL_MWMAC_MONTPOINTD, &MontPointD_192_test);
	if(ret_val != 0) {
		printf("Error occured2\n");
	}
	clock_gettime(CLOCK_MONOTONIC, &tend);

	printf("xr = MontPointD(xp,yp,N): 0x");
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		printf("%08x", MontPointD_192_test.xr[i]);
	}
	printf("\n\n");
	
	printf("yr = MontPointD(xp,yp,N): 0x");
	for(i=0; i<MontPointD_192_test.prec/32; i++){
		printf("%08x", MontPointD_192_test.yr[i]);
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
