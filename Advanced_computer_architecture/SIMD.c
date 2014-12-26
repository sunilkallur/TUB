/*
   ============================================================================
Name        : simd.c
Author      : biaowang
Version     :
Copyright   : Your copyright notice
Description : Hello World in C, Ansi-style
============================================================================
 */

#include <immintrin.h>
#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include <math.h>
//#include "emmintrin.h"

#define IDCT_SIZE         16
#define ITERATIONS        1000000  //6 zeros
#define MAX_NEG_CROP      1024

#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))
#define MAX(X,Y) ((X) > (Y) ? (X) : (Y))

//static void partialButterflyInverse16(short *src, short *dst, int shift);
//static void partialButterflyInverse16_SIMD(short *scalar_input, short *dst, int shift);


static const short g_aiT16[16][16] =
{
	{ 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64},
	{ 90, 87, 80, 70, 57, 43, 25,  9, -9,-25,-43,-57,-70,-80,-87,-90},
	{ 89, 75, 50, 18,-18,-50,-75,-89,-89,-75,-50,-18, 18, 50, 75, 89},
	{ 87, 57,  9,-43,-80,-90,-70,-25, 25, 70, 90, 80, 43, -9,-57,-87},
	{ 83, 36,-36,-83,-83,-36, 36, 83, 83, 36,-36,-83,-83,-36, 36, 83},
	{ 80,  9,-70,-87,-25, 57, 90, 43,-43,-90,-57, 25, 87, 70, -9,-80},
	{ 75,-18,-89,-50, 50, 89, 18,-75,-75, 18, 89, 50,-50,-89,-18, 75},
	{ 70,-43,-87,  9, 90, 25,-80,-57, 57, 80,-25,-90, -9, 87, 43,-70},
	{ 64,-64,-64, 64, 64,-64,-64, 64, 64,-64,-64, 64, 64,-64,-64, 64},
	{ 57,-80,-25, 90, -9,-87, 43, 70,-70,-43, 87,  9,-90, 25, 80,-57},
	{ 50,-89, 18, 75,-75,-18, 89,-50,-50, 89,-18,-75, 75, 18,-89, 50},
	{ 43,-90, 57, 25,-87, 70,  9,-80, 80, -9,-70, 87,-25,-57, 90,-43},
	{ 36,-83, 83,-36,-36, 83,-83, 36, 36,-83, 83,-36,-36, 83,-83, 36},
	{ 25,-70, 90,-80, 43,  9,-57, 87,-87, 57, -9,-43, 80,-90, 70,-25},
	{ 18,-50, 75,-89, 89,-75, 50,-18,-18, 50,-75, 89,-89, 75,-50, 18},
	{  9,-25, 43,-57, 70,-80, 87,-90, 90,-87, 80,-70, 57,-43, 25, -9}
};

static int64_t diff(struct timespec start, struct timespec end)
{
	struct timespec temp;
	int64_t d;
	if ((end.tv_nsec-start.tv_nsec)<0) {
		temp.tv_sec = end.tv_sec-start.tv_sec-1;
		temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
	} else {
		temp.tv_sec = end.tv_sec-start.tv_sec;
		temp.tv_nsec = end.tv_nsec-start.tv_nsec;
	}
	d = temp.tv_sec*1000000000+temp.tv_nsec;
	return d;
}

static void compare_results(short *ref, short *res, const char *msg)
{
	int correct =1;

	printf("Comparing %s\n",msg);
	for(int j=0; j<IDCT_SIZE; j++)  {
		for(int i=0; i<IDCT_SIZE; i++){
			if(ref[j*IDCT_SIZE+i] != res[j*IDCT_SIZE+i]){
				correct=0;
				printf("failed at %d,%d\t ref=%d, res=%d\n ", i, j, ref[j*IDCT_SIZE+i],res[j*IDCT_SIZE+i]);
			}
		}
	}
	if (correct){
		printf("correct\n\n");
	}
}

// this function is for timing, do not change anything here
static void benchmark( void (*idct16)(short *, short *), short *input, short *output, const char *version )
{
	struct timespec start, end;
	clock_gettime(CLOCK_REALTIME,&start);

	for(int i=0;i<ITERATIONS;i++)
		idct16(input, output);

	clock_gettime(CLOCK_REALTIME,&end);
	double avg = (double) diff(start,end)/ITERATIONS;
	printf("%10s:\t %.3f ns\n", version, avg);
}

void print128_num(__m128i var)
{
	short *val = (short *) &var;
	printf("Numerical: %d %d %d %d %d %d %d %d \n", 
			val[0], val[1], val[2], val[3], val[4], val[5], 
			val[6], val[7]);
}

void print128_num_int(__m128i var)
{
	int *val = (int *) &var;
	printf("Numerical: %d %d %d %d \n", 
			val[0], val[1], val[2], val[3]);
}

static void partialButterflyInverse16_SIMD(short *scalar_input, short *dst, int shift) 
{
	

	int add1 = 1<<(shift-1);	
	__m128i *input = (__m128i *) scalar_input;
	__m128i *output = (__m128i *) dst;
	__m128i in_src1,in_src,coeff_128;
	__m128i add2 = _mm_set1_epi32(add1);
        __m128i shift_bcd = _mm_set1_epi32(shift);
	__m128i coeff[16*8];
	__m128i *g_aiT16_1 = (__m128i *)g_aiT16;
	



	
	 __m128i temp0_high[128],temp0_low[128],temp1_high[64],temp1_low[64];
	 __m128i temp4_high[16],temp4_low[16];
	 __m128i O[8],H_O[8];
	 __m128i EO[4],H_EO[4];
	 __m128i EEO[2],H_EEO[2];
 	 __m128i EEE[2],H_EEE[2];
	 __m128i EE[4],H_EE[4];
	 __m128i E[8],H_E[8];
         __m128i xmmo[16],xmm[8],xmm1[16],result_low,result_high;

	
	
	
	for(int i=0,m=0;i<16;i++)
	  // for(int j=0;j<8;j++,m++)
 		{
   		coeff[m]=_mm_set1_epi16(g_aiT16[i][0]);
		coeff[m+1]=_mm_set1_epi16(g_aiT16[i][1]);
		coeff[m+2]=_mm_set1_epi16(g_aiT16[i][2]);
		coeff[m+3]=_mm_set1_epi16(g_aiT16[i][3]);
		coeff[m+4]=_mm_set1_epi16(g_aiT16[i][4]);
		coeff[m+5]=_mm_set1_epi16(g_aiT16[i][5]);
		coeff[m+6]=_mm_set1_epi16(g_aiT16[i][6]);
		coeff[m+7]=_mm_set1_epi16(g_aiT16[i][7]);
		m=m+8;
		}

	

	
		

// product term for O[]

for(int p=2,i=1,l=0,m=0; p<32;p+=4,i+=2)
    {

	in_src = _mm_stream_load_si128 (input+p);
	in_src1 = _mm_stream_load_si128 (input + p+1);
	l = i<<3;
 	//for(int j=0;j<8;j++,m+=2)
	{ 	
		result_high = _mm_mulhi_epi16(coeff[l], in_src);
		result_low = _mm_mullo_epi16(coeff[l], in_src);
		
		temp0_low[m] = _mm_unpacklo_epi16(result_low,result_high );
		temp0_high[m]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l], in_src1);
		result_low = _mm_mullo_epi16(coeff[l], in_src1);
	
		temp0_low[m+1] = _mm_unpacklo_epi16(result_low,result_high);
		temp0_high[m+1] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+1], in_src);
		result_low = _mm_mullo_epi16(coeff[l+1], in_src);
		
		temp0_low[m+2] = _mm_unpacklo_epi16(result_low,result_high );
		temp0_high[m+2]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+1], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+1], in_src1);
	
		temp0_low[m+3] = _mm_unpacklo_epi16(result_low,result_high);
		temp0_high[m+3] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+2], in_src);
		result_low = _mm_mullo_epi16(coeff[l+2], in_src);
		
		temp0_low[m+4] = _mm_unpacklo_epi16(result_low,result_high );
		temp0_high[m+4]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+2], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+2], in_src1);
	
		temp0_low[m+5] = _mm_unpacklo_epi16(result_low,result_high);
		temp0_high[m+5] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+3], in_src);
		result_low = _mm_mullo_epi16(coeff[l+3], in_src);
		
		temp0_low[m+6] = _mm_unpacklo_epi16(result_low,result_high );
		temp0_high[m+6]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+3], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+3], in_src1);
	
		temp0_low[m+7] = _mm_unpacklo_epi16(result_low,result_high);
		temp0_high[m+7] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+4], in_src);
		result_low = _mm_mullo_epi16(coeff[l+4], in_src);
		
		temp0_low[m+8] = _mm_unpacklo_epi16(result_low,result_high );
		temp0_high[m+8]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+4], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+4], in_src1);
	
		temp0_low[m+9] = _mm_unpacklo_epi16(result_low,result_high);
		temp0_high[m+9] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+5], in_src);
		result_low = _mm_mullo_epi16(coeff[l+5], in_src);
		
		temp0_low[m+10] = _mm_unpacklo_epi16(result_low,result_high );
		temp0_high[m+10]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+5], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+5], in_src1);
	
		temp0_low[m+11] = _mm_unpacklo_epi16(result_low,result_high);
		temp0_high[m+11] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+6], in_src);
		result_low = _mm_mullo_epi16(coeff[l+6], in_src);
		
		temp0_low[m+12] = _mm_unpacklo_epi16(result_low,result_high );
		temp0_high[m+12]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+6], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+6], in_src1);
	
		temp0_low[m+13] = _mm_unpacklo_epi16(result_low,result_high);
		temp0_high[m+13] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+7], in_src);
		result_low = _mm_mullo_epi16(coeff[l+7], in_src);
		
		temp0_low[m+14] = _mm_unpacklo_epi16(result_low,result_high );
		temp0_high[m+14]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+7], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+7], in_src1);
	
		temp0_low[m+15] = _mm_unpacklo_epi16(result_low,result_high);
		temp0_high[m+15] = _mm_unpackhi_epi16(result_low,result_high);

		m=m+16;

	}
     }


// product term for E[]



for(int p=4,i=2,l=0,m=0; p<32;p+=8,i+=4)
	{

	
	in_src = _mm_stream_load_si128 (input + p);
	in_src1 = _mm_stream_load_si128 (input + p + 1);

 	//for(int j=0;j<8;j++,m+=2)
	{	 l=i<<3;

		result_high = _mm_mulhi_epi16(coeff[l], in_src);
		result_low = _mm_mullo_epi16(coeff[l], in_src);
		
		temp1_low[m] = _mm_unpacklo_epi16(result_low,result_high );
		temp1_high[m]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l], in_src1);
		result_low = _mm_mullo_epi16(coeff[l], in_src1);
	
		temp1_low[m+1] = _mm_unpacklo_epi16(result_low,result_high);
		temp1_high[m+1] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+1], in_src);
		result_low = _mm_mullo_epi16(coeff[l+1], in_src);
		
		temp1_low[m+2] = _mm_unpacklo_epi16(result_low,result_high );
		temp1_high[m+2]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+1], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+1], in_src1);
	
		temp1_low[m+3] = _mm_unpacklo_epi16(result_low,result_high);
		temp1_high[m+3] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+2], in_src);
		result_low = _mm_mullo_epi16(coeff[l+2], in_src);
		
		temp1_low[m+4] = _mm_unpacklo_epi16(result_low,result_high );
		temp1_high[m+4]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+2], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+2], in_src1);
	
		temp1_low[m+5] = _mm_unpacklo_epi16(result_low,result_high);
		temp1_high[m+5] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+3], in_src);
		result_low = _mm_mullo_epi16(coeff[l+3], in_src);
		
		temp1_low[m+6] = _mm_unpacklo_epi16(result_low,result_high );
		temp1_high[m+6]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+3], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+3], in_src1);
	
		temp1_low[m+7] = _mm_unpacklo_epi16(result_low,result_high);
		temp1_high[m+7] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+4], in_src);
		result_low = _mm_mullo_epi16(coeff[l+4], in_src);
		
		temp1_low[m+8] = _mm_unpacklo_epi16(result_low,result_high );
		temp1_high[m+8]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+4], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+4], in_src1);
	
		temp1_low[m+9] = _mm_unpacklo_epi16(result_low,result_high);
		temp1_high[m+9] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+5], in_src);
		result_low = _mm_mullo_epi16(coeff[l+5], in_src);
		

		temp1_low[m+10] = _mm_unpacklo_epi16(result_low,result_high );
		temp1_high[m+10]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+5], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+5], in_src1);
	
		temp1_low[m+11] = _mm_unpacklo_epi16(result_low,result_high);
		temp1_high[m+11] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+6], in_src);
		result_low = _mm_mullo_epi16(coeff[l+6], in_src);
		

		temp1_low[m+12] = _mm_unpacklo_epi16(result_low,result_high );
		temp1_high[m+12]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+6], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+6], in_src1);
	
		temp1_low[m+13] = _mm_unpacklo_epi16(result_low,result_high);
		temp1_high[m+13] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+7], in_src);
		result_low = _mm_mullo_epi16(coeff[l+7], in_src);
		

		temp1_low[m+14] = _mm_unpacklo_epi16(result_low,result_high );
		temp1_high[m+14]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+7], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+7], in_src1);
	
		temp1_low[m+15] = _mm_unpacklo_epi16(result_low,result_high);
		temp1_high[m+15] = _mm_unpackhi_epi16(result_low,result_high);
		m=m+16;

		

	}
     }

// EEO and EEE product terms

for(int p=0,i=0,m=0,l=0; p<32;p+=8,i+=4)
	{
	
        in_src = _mm_stream_load_si128 (input + p);
	in_src1 = _mm_stream_load_si128 (input + p+1);

	//for(int j=0;j<2;j++,m+=2)
	{ 	l=i<<3;

		result_high = _mm_mulhi_epi16(coeff[l], in_src);
		result_low = _mm_mullo_epi16(coeff[l], in_src);
		
		temp4_low[m] = _mm_unpacklo_epi16(result_low,result_high );
		temp4_high[m]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l], in_src1);
		result_low = _mm_mullo_epi16(coeff[l], in_src1);
	
		temp4_low[m+1] = _mm_unpacklo_epi16(result_low,result_high);
		temp4_high[m+1] = _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+1], in_src);
		result_low = _mm_mullo_epi16(coeff[l+1], in_src);
		
		temp4_low[m+2] = _mm_unpacklo_epi16(result_low,result_high );
		temp4_high[m+2]= _mm_unpackhi_epi16(result_low,result_high);

		result_high = _mm_mulhi_epi16(coeff[l+1], in_src1);
		result_low = _mm_mullo_epi16(coeff[l+1], in_src1);
	
		temp4_low[m+3] = _mm_unpacklo_epi16(result_low,result_high);
		temp4_high[m+3] = _mm_unpackhi_epi16(result_low,result_high);
		m=m+4;
		
		

	}
     }





//calculating O[] term

   for(int m=0; m<2;m++)
   {   

		


	for(int n=0;n<8;n++)
	{ 
               O[n] = temp0_low[2*n+m];
	       H_O[n]= temp0_high[2*n+m];

         	for(int k=1;k<8;k++)
         		{
     
         	                O[n]= _mm_add_epi32(O[n],temp0_low[k*16+2*n+m]); 
				H_O[n]= _mm_add_epi32(H_O[n],temp0_high[k*16+2*n+m]); 
				
			}
		
	
         }
   		
	

	

//For E[] terms

         for(int n=0;n<4;n++)
 	 
		{

			EO[n]= temp1_low[2*n+m];
			H_EO[n]=temp1_high[2*n+m];

			for(int k=1;k<4;k++)
			{
			
			EO[n]= _mm_add_epi32(EO[n],temp1_low[k*16+2*n+m]);
			H_EO[n]= _mm_add_epi32(H_EO[n],temp1_high[k*16+2*n+m]);
			
			}
		}


	


//EEO and EEE terms

	

	EEO[0] = _mm_add_epi32(temp4_low[4+m],temp4_low[12+m]);
	EEE[0] = _mm_add_epi32(temp4_low[0+m],temp4_low[8+m]);

	EEO[1] = _mm_add_epi32(temp4_low[6+m],temp4_low[14+m]);
	EEE[1] = _mm_add_epi32(temp4_low[2+m],temp4_low[10+m]);

	H_EEO[0] = _mm_add_epi32(temp4_high[4+m],temp4_high[12+m]);
	H_EEE[0] = _mm_add_epi32(temp4_high[0+m],temp4_high[8+m]);

	H_EEO[1] = _mm_add_epi32(temp4_high[6+m],temp4_high[14+m]);
	H_EEE[1] = _mm_add_epi32(temp4_high[2+m],temp4_high[10+m]);


	for(int k=0;k<2;k++)
 	{
           EE[k]=_mm_add_epi32(EEE[k],EEO[k]);
	   

           EE[k+2] = _mm_sub_epi32(EEE[1-k],EEO[1-k]);
		
	   H_EE[k]=_mm_add_epi32(H_EEE[k],H_EEO[k]);
           H_EE[k+2] = _mm_sub_epi32(H_EEE[1-k],H_EEO[1-k]);
	   
	}

  	
	

	for (int k=0; k<4; k++)
		{
			E[k] = _mm_add_epi32(EE[k],EO[k]);
			
			E[k+4] = _mm_sub_epi32(EE[3-k],EO[3-k]);

			H_E[k] = _mm_add_epi32(H_EE[k],H_EO[k]);
			H_E[k+4] = _mm_sub_epi32(H_EE[3-k],H_EO[3-k]);
			
		}

	for (int k=0; k<8; k++)
		{
			//dst[k]   = MAX( -32768, MIN( 32767, (E[k]   + O[k]   + add)>>shift ));
			//dst[k+8] = MAX( -32768, MIN( 32767, (E[7-k] - O[7-k] + add)>>shift ));
			
 			xmmo[k] = _mm_add_epi32(E[k],O[k]);
		 	xmmo[k] = _mm_add_epi32(xmmo[k],add2);			
 			xmmo[k] = _mm_sra_epi32(xmmo[k],shift_bcd);		
		        
		        	
			xmmo[k+8] = _mm_sub_epi32(E[7-k],O[7-k]);			
                        xmmo[k+8] = _mm_add_epi32(xmmo[8+k],add2);			
 			xmmo[k+8] = _mm_sra_epi32(xmmo[8+k],shift_bcd);		
		        

		
			xmm1[k] = _mm_add_epi32(H_E[k],H_O[k]);
                        xmm1[k] = _mm_add_epi32(xmm1[k],add2);
 			xmm1[k] = _mm_sra_epi32(xmm1[k],shift_bcd);	       
		        	

			xmm1[k+8] = _mm_sub_epi32(H_E[7-k],H_O[7-k]);
                        xmm1[k+8] = _mm_add_epi32(xmm1[k+8],add2);
 			xmm1[k+8] = _mm_sra_epi32(xmm1[k+8],shift_bcd);
		       

			
                             
                }



		//Transposing to store it into memory

		xmm[0] = _mm_unpacklo_epi32(xmmo[0],xmmo[1]);
		xmm[1] = _mm_unpacklo_epi32(xmmo[2],xmmo[3]);
		xmm[2] = _mm_unpackhi_epi32(xmmo[0],xmmo[1]);
		xmm[3] = _mm_unpackhi_epi32(xmmo[2],xmmo[3]);

		xmmo[0]= _mm_unpacklo_epi64(xmm[0],xmm[1]);
		xmmo[1]= _mm_unpackhi_epi64(xmm[0],xmm[1]);
		xmmo[2]= _mm_unpacklo_epi64(xmm[2],xmm[3]);
		xmmo[3]= _mm_unpackhi_epi64(xmm[2],xmm[3]);

		xmm[0] = _mm_unpacklo_epi32(xmmo[4],xmmo[5]);
		xmm[1] = _mm_unpacklo_epi32(xmmo[6],xmmo[7]);
		xmm[2] = _mm_unpackhi_epi32(xmmo[4],xmmo[5]);
		xmm[3] = _mm_unpackhi_epi32(xmmo[6],xmmo[7]);

		xmmo[4]= _mm_unpacklo_epi64(xmm[0],xmm[1]);
		xmmo[5]= _mm_unpackhi_epi64(xmm[0],xmm[1]);
		xmmo[6]= _mm_unpacklo_epi64(xmm[2],xmm[3]);
		xmmo[7]= _mm_unpackhi_epi64(xmm[2],xmm[3]);

		xmm[0] = _mm_unpacklo_epi32(xmmo[8],xmmo[9]);
		xmm[1] = _mm_unpacklo_epi32(xmmo[10],xmmo[11]);
		xmm[2] = _mm_unpackhi_epi32(xmmo[8],xmmo[9]);
		xmm[3] = _mm_unpackhi_epi32(xmmo[10],xmmo[11]);

		xmmo[8]= _mm_unpacklo_epi64(xmm[0],xmm[1]);
		xmmo[9]= _mm_unpackhi_epi64(xmm[0],xmm[1]);
		xmmo[10]= _mm_unpacklo_epi64(xmm[2],xmm[3]);
		xmmo[11]= _mm_unpackhi_epi64(xmm[2],xmm[3]);

		xmm[0] = _mm_unpacklo_epi32(xmmo[12],xmmo[13]);
		xmm[1] = _mm_unpacklo_epi32(xmmo[14],xmmo[15]);
		xmm[2] = _mm_unpackhi_epi32(xmmo[12],xmmo[13]);
		xmm[3] = _mm_unpackhi_epi32(xmmo[14],xmmo[15]);

		xmmo[12]= _mm_unpacklo_epi64(xmm[0],xmm[1]);
		xmmo[13]= _mm_unpackhi_epi64(xmm[0],xmm[1]);
		xmmo[14]= _mm_unpacklo_epi64(xmm[2],xmm[3]);
		xmmo[15]= _mm_unpackhi_epi64(xmm[2],xmm[3]);

		//converting to short int format to store into destination

		
		output[0]=_mm_packs_epi32(xmmo[0],xmmo[4]);
		output[1]=_mm_packs_epi32(xmmo[8],xmmo[12]);
		output[2]=_mm_packs_epi32(xmmo[1],xmmo[5]);
		output[3]=_mm_packs_epi32(xmmo[9],xmmo[13]);

		output[4]=_mm_packs_epi32(xmmo[2],xmmo[6]);
		output[5]=_mm_packs_epi32(xmmo[10],xmmo[14]);
		output[6]=_mm_packs_epi32(xmmo[3],xmmo[7]);
		output[7]=_mm_packs_epi32(xmmo[11],xmmo[15]);

		


	
		

            output=output + 8;



		xmm[0] = _mm_unpacklo_epi32(xmm1[0],xmm1[1]);
		xmm[1] = _mm_unpacklo_epi32(xmm1[2],xmm1[3]);
		xmm[2] = _mm_unpackhi_epi32(xmm1[0],xmm1[1]);
		xmm[3] = _mm_unpackhi_epi32(xmm1[2],xmm1[3]);

		xmm1[0]= _mm_unpacklo_epi64(xmm[0],xmm[1]);
		xmm1[1]= _mm_unpackhi_epi64(xmm[0],xmm[1]);
		xmm1[2]= _mm_unpacklo_epi64(xmm[2],xmm[3]);
		xmm1[3]= _mm_unpackhi_epi64(xmm[2],xmm[3]);

		xmm[0] = _mm_unpacklo_epi32(xmm1[4],xmm1[5]);
		xmm[1] = _mm_unpacklo_epi32(xmm1[6],xmm1[7]);
		xmm[2] = _mm_unpackhi_epi32(xmm1[4],xmm1[5]);
		xmm[3] = _mm_unpackhi_epi32(xmm1[6],xmm1[7]);

		xmm1[4]= _mm_unpacklo_epi64(xmm[0],xmm[1]);
		xmm1[5]= _mm_unpackhi_epi64(xmm[0],xmm[1]);
		xmm1[6]= _mm_unpacklo_epi64(xmm[2],xmm[3]);
		xmm1[7]= _mm_unpackhi_epi64(xmm[2],xmm[3]);

		xmm[0] = _mm_unpacklo_epi32(xmm1[8],xmm1[9]);
		xmm[1] = _mm_unpacklo_epi32(xmm1[10],xmm1[11]);
		xmm[2] = _mm_unpackhi_epi32(xmm1[8],xmm1[9]);
		xmm[3] = _mm_unpackhi_epi32(xmm1[10],xmm1[11]);

		xmm1[8]= _mm_unpacklo_epi64(xmm[0],xmm[1]);
		xmm1[9]= _mm_unpackhi_epi64(xmm[0],xmm[1]);
		xmm1[10]= _mm_unpacklo_epi64(xmm[2],xmm[3]);
		xmm1[11]= _mm_unpackhi_epi64(xmm[2],xmm[3]);

		xmm[0] = _mm_unpacklo_epi32(xmm1[12],xmm1[13]);
		xmm[1] = _mm_unpacklo_epi32(xmm1[14],xmm1[15]);
		xmm[2] = _mm_unpackhi_epi32(xmm1[12],xmm1[13]);
		xmm[3] = _mm_unpackhi_epi32(xmm1[14],xmm1[15]);

		xmm1[12]= _mm_unpacklo_epi64(xmm[0],xmm[1]);
		xmm1[13]= _mm_unpackhi_epi64(xmm[0],xmm[1]);
		xmm1[14]= _mm_unpacklo_epi64(xmm[2],xmm[3]);
		xmm1[15]= _mm_unpackhi_epi64(xmm[2],xmm[3]);


		//converting to short int format to store into destination

		
		output[0]=_mm_packs_epi32(xmm1[0],xmm1[4]);
		output[1]=_mm_packs_epi32(xmm1[8],xmm1[12]);
		output[2]=_mm_packs_epi32(xmm1[1],xmm1[5]);
		output[3]=_mm_packs_epi32(xmm1[9],xmm1[13]);

		output[4]=_mm_packs_epi32(xmm1[2],xmm1[6]);
		output[5]=_mm_packs_epi32(xmm1[10],xmm1[14]);
		output[6]=_mm_packs_epi32(xmm1[3],xmm1[7]);
		output[7]=_mm_packs_epi32(xmm1[11],xmm1[15]);

		
		

                output=output + 8;
	

			
      }
	
}


//scalar code for the inverse transform
static void partialButterflyInverse16(short *src, short *dst, int shift)
{
	int E[8],O[8];
	int EE[4],EO[4];
	int EEE[2],EEO[2];
	int add = 1<<(shift-1);

	
	//Measure the performance of each kernel

	for (int j=0; j<16; j++)
	{
		/* Utilizing symmetry properties to the maximum to minimize the number of multiplications */
		for (int k=0; k<8; k++)
		{
			O[k] = g_aiT16[ 1][k]*src[ 16] + g_aiT16[ 3][k]*src[ 3*16] + g_aiT16[ 5][k]*src[ 5*16] + g_aiT16[ 7][k]*src[ 7*16] +
				g_aiT16[ 9][k]*src[ 9*16] + g_aiT16[11][k]*src[11*16] + g_aiT16[13][k]*src[13*16] + g_aiT16[15][k]*src[15*16];
		}
		for (int k=0; k<4; k++)
		{
			EO[k] = g_aiT16[ 2][k]*src[ 2*16] + g_aiT16[ 6][k]*src[ 6*16] + g_aiT16[10][k]*src[10*16] + g_aiT16[14][k]*src[14*16];
		}
		EEO[0] = g_aiT16[4][0]*src[ 4*16 ] + g_aiT16[12][0]*src[ 12*16 ];
		EEE[0] = g_aiT16[0][0]*src[ 0    ] + g_aiT16[ 8][0]*src[  8*16 ];
		EEO[1] = g_aiT16[4][1]*src[ 4*16 ] + g_aiT16[12][1]*src[ 12*16 ];
		EEE[1] = g_aiT16[0][1]*src[ 0    ] + g_aiT16[ 8][1]*src[  8*16 ];

		/* Combining even and odd terms at each hierarchy levels to calculate the final spatial domain vector */
		for (int k=0; k<2; k++)
		{
			EE[k] = EEE[k] + EEO[k];
			EE[k+2] = EEE[1-k] - EEO[1-k];
		}
		for (int k=0; k<4; k++)
		{
			E[k] = EE[k] + EO[k];
			//if (j==0 && k==1) {printf("E,%d\t  %d\t",k,E[k]);printf ("O[1] %d\t",O[1]);}
			E[k+4] = EE[3-k] - EO[3-k];
			//if (j==0) printf("E,%d\t %d\t",k+4,E[k+4] );
		}
		for (int k=0; k<8; k++)
		{
			dst[k]   = MAX( -32768, MIN( 32767, (E[k]   + O[k]   + add)>>shift ));
			//if (j==8) printf("dst,%d\t  %d\t",k,dst[k]);
			dst[k+8] = MAX( -32768, MIN( 32767, (E[7-k] - O[7-k] + add)>>shift ));
			//if (j==0) printf("dst,%d\t  %d\t",k+8,dst[k+8]);
		}
		src ++;
		dst += 16;
	}//printf("dst value in scalar----> %d\n",dst);
}

static void idct16_scalar(short* pCoeff, short* pDst)
{
	short tmp[ 16*16] __attribute__((aligned(16)));
	short tmp2[ 16*16] __attribute__((aligned(16)));
	partialButterflyInverse16(pCoeff, tmp, 7);
	//printf("\n Scalar array result1---->\n");
	//for(int i=0;i<256;i++)
	//printf("%d\t",tmp[i]);
	partialButterflyInverse16(tmp, pDst, 12);
	//printf("\n Scalar array result2---->\n");
	//for(int i=0;i<256;i++)
	//printf("%d\t",tmp2[i]);
	
	
}

/// SIMD Code !!
/// REPLACE HERE WITH SSE intrinsics
static void idct16_simd(short* pCoeff, short* pDst)
{
	short tmp[ 16*16] __attribute__((aligned(16)));
	short tmp2[ 16*16] __attribute__((aligned(16)));
	partialButterflyInverse16_SIMD(pCoeff, tmp, 7);
	//printf("\n SIMD array result1---->\t\n");
	//for(int i=0;i<256;i++)
	//printf("%d\t",tmp[i]);
	partialButterflyInverse16_SIMD(tmp,pDst, 12);
	//printf("\n SIMD array result2---->\t\n");
	//for(int i=0;i<256;i++)
	//printf("%d\t",tmp2[i]);
	
		
	
}

int main(int argc, char **argv)
{
	//allocate memory 16-byte aligned
	short *scalar_input = (short*) memalign(16, IDCT_SIZE*IDCT_SIZE*sizeof(short));
	short *scalar_output = (short *) memalign(16, IDCT_SIZE*IDCT_SIZE*sizeof(short));

	short *simd_input = (short*) memalign(16, IDCT_SIZE*IDCT_SIZE*sizeof(short));
	short *simd_output = (short *) memalign(16, IDCT_SIZE*IDCT_SIZE*sizeof(short));


	//initialize input
	printf("input array:\n");
	//printf("%d\n",(int)sizeof(short));
	for(int j=0;j<IDCT_SIZE;j++){
		for(int i=0;i<IDCT_SIZE;i++){
			short value = rand()%2 ? (rand()%32768) : -(rand()%32768) ;
			scalar_input[j*IDCT_SIZE+i] = value;
			simd_input  [j*IDCT_SIZE+i] = value;
			printf("%d\t", value);
		}
		printf("\n");
	}

	idct16_scalar(scalar_input, scalar_output);
	idct16_simd(simd_input  , simd_output);

	//check for correctness
	compare_results (scalar_output, simd_output, "scalar and simd");

	printf("output array:\n");
	for(int j=0;j<IDCT_SIZE;j++){
		for(int i=0;i<IDCT_SIZE;i++){
			printf("%d\t", scalar_output[j*IDCT_SIZE+i]);
		}
		printf("\n");
	}

	printf("output array SIMD:\n");
	for(int j=0;j<IDCT_SIZE;j++){
		for(int i=0;i<IDCT_SIZE;i++){
			printf("%d\t", simd_output[j*IDCT_SIZE+i]);
		}
		printf("\n");
	}

	benchmark (idct16_scalar, scalar_input, scalar_output, "scalar");
	benchmark (idct16_simd, simd_input, simd_output, "simd");

	//cleanup
	free(scalar_input);    free(scalar_output);
	free(simd_input); free(simd_output);
	//print128_num(in_src);
}
