#include <stdio.h>
#include <stdlib.h>

//File write
FILE * fp;

int main()
{
int k;


 //fft variables
 int size=128;
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
 }

// Debug write in file
fp = fopen ("data_in_re.txt","w");
for(k = 0; k < size;k++){
    fprintf (fp, "%f\n",*(data_in_re+k));
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

    return 0;
}
