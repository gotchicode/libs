#include <stdio.h>
#include <stdlib.h>

//File write
FILE * fp;

int main()
{
int k;

 //Init variables
 int fft_init_size;


 //fft variables
 int size=256;
 float *data_in_re   = malloc(size*sizeof(float));
 float *data_in_im   = malloc(size*sizeof(float));
 float *data_out_re  = malloc(size*sizeof(float));
 float *data_out_im  = malloc(size*sizeof(float));

 float *tie_to_zero  = malloc(size*sizeof(float));
 float *tie_to_one   = malloc(size*sizeof(float));

 printf("Start the app!\n");

 //test initialization
 fft_init_size= my_float_fft_init_get_size(size);
 //printf (fft_init_size="%d\n",fft_init_size);

 float *data_from_my_float_fft_init_re   = malloc(fft_init_size*sizeof(float));
 float *data_from_my_float_fft_init_im   = malloc(fft_init_size*sizeof(float));

 my_float_fft_init(size, data_from_my_float_fft_init_re, data_from_my_float_fft_init_im);

// Debug write in file
fp = fopen ("data_from_my_float_fft_init_re.txt","w");
for(k = 0; k < fft_init_size;k++){
    fprintf (fp, "%f\n",*(data_from_my_float_fft_init_re+k));
}
fclose(fp);

// Debug write in file
fp = fopen ("data_from_my_float_fft_init_im.txt","w");
for(k = 0; k < fft_init_size;k++){
     fprintf (fp, "%f\n",*(data_from_my_float_fft_init_im+k));
}
fclose(fp);

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
