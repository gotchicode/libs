#include <stdio.h>
#include <stdlib.h>

//File write
FILE * fp;

int main()
{
    int k;


 //fft variables
 int size=32;
 float *data_in_re   = malloc(size*sizeof(float));
 float *data_in_im   = malloc(size*sizeof(float));
 float *data_out_re  = malloc(size*sizeof(float));
 float *data_out_im  = malloc(size*sizeof(float));

 float *tie_to_zero  = malloc(size*sizeof(float));
 float *tie_to_one   = malloc(size*sizeof(float));

 printf("Start the app!\n");

 //generate table of zeros
 for( k = 0; k < size; k++ ){
     *(tie_to_zero+k) = 0;
 }

 //generate table of ones
 for( k = 0; k < size; k++ ){
     *(tie_to_one+k) = 0;
 }

 //generate a random sequence
 for( k = 0; k < size; k++ ){
     *(data_in_re+k) = rand();
     *(data_in_im+k) = rand();
     //printf("data_in_re+%d=%f\n",k ,*(data_in_re+k));
     //printf("data_in_im+%d=%f\n",k ,*(data_in_im+k));
 }
 //system("pause");

// Debug write in file
fp = fopen ("data_in_re.txt","w");
for(k = 0; k < size;k++){
    fprintf (fp, "%f\n",*(data_in_re+k));
    //fprintf (fp, "%f\n",*(data_in_im+k));
}
fclose(fp);

// Debug write in file
fp = fopen ("data_in_im.txt","w");
for(k = 0; k < size;k++){
     fprintf (fp, "%f\n",*(data_in_im+k));
}
fclose(fp);



 //Launch the fft
 my_float_fft(data_in_re, data_in_im, data_out_re, data_out_im, size);

 //Test the complex multiplier
 //my_float_complex_multiply(data_in_re, data_in_im, data_in_re, data_in_im, data_out_re, data_out_im, size);

// Debug write in file
fp = fopen ("data_out_re.txt","w");
for(k = 0; k < size;k++){
    fprintf (fp, "%f\n",*(data_out_re+k));
    //fprintf (fp, "%f\n",*(data_in_im+k));
}
fclose(fp);

// Debug write in file
fp = fopen ("data_out_im.txt","w");
for(k = 0; k < size;k++){
     fprintf (fp, "%f\n",*(data_out_im+k));
}
fclose(fp);

//	//////////////////////////////////
//	// Test the complex multiplication
//	//////////////////////////////////
//
//
//		float *data_in_A_re	= malloc(1*sizeof(float));
//		float *data_in_A_im	= malloc(1*sizeof(float));
//		float *data_in_B_re	= malloc(1*sizeof(float));
//		float *data_in_B_im	= malloc(1*sizeof(float));
//		float *data_out_re	= malloc(1*sizeof(float));
//		float *data_out_im	= malloc(1*sizeof(float));
//		int size;
//
//
//
//
//
//
//		*data_in_A_re	= 0;
//		*data_in_A_im	= 1;
//		*data_in_B_re	= 0;
//		*data_in_B_im	= 1;
//		*data_out_re	= 1;
//		*data_out_im	= 1;
//		size =1;
//
//		my_float_complex_multiply(data_in_A_re, data_in_A_im, data_in_B_re, data_in_B_im, data_out_re, data_out_im, 1);
//
//		printf("data_in_A_re = %f\n", *data_in_A_re	);
//		printf("data_in_A_im = %f\n", *data_in_A_im	);
//		printf("data_in_B_re = %f\n", *data_in_B_re	);
//		printf("data_in_B_im = %f\n", *data_in_B_im	);
//		printf("data_out_re	 = %f\n", *data_out_re	);
//		printf("data_out_im	 = %f\n", *data_out_im	);

    return 0;
}
