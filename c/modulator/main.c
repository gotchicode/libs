#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define DEBUG 0
#define PAUSE system("pause");
#define PI 3.141592653589793238462643383279502884

 int my_xor(
            int a, 
            int b)
{
   int out;
   if (a==0 && b ==0) out=0;
   if (a==0 && b ==1) out=1;
   if (a==1 && b ==0) out=1;
   if (a==1 && b ==1) out=0;
   return out;
}

void pn_23_enc_1b(int *data_in, int data_in_size, int *shift_reg_in, int *data_out, int debug)
{
    int k;
    int tmp=0;
    int out_tmp=0;
    int out=0;
    int shift_reg = *shift_reg_in;
    if (debug) printf("%d\n", shift_reg);
    for (k=1;k<data_in_size+1;k++)
    {
        tmp = *(data_in+k-1);
        out_tmp = my_xor(((shift_reg>>22)&0x01) , ((shift_reg>>17)&0x01));
        out = my_xor(tmp, out_tmp);
        *(data_out+k-1) = out;
        shift_reg = ((shift_reg <<1 ) & 0x7FFFFF) + out;
        if (debug) printf("k=%d tmp=%d out_tmp=%d out=%d shift_reg=%08x\n",k, tmp, out_tmp, out, shift_reg);
    }
    *shift_reg_in = shift_reg;
}
void generate_rrc_filter_taps(
                              float roll_off_in,
                              int oversamp_in,
                              float *taps_out,
                              int *taps_out_size,
                              int debug)
                              {
                                 int k;
                                 float t=-5.5;
                                 float Ts=1;
                                 float Tsamp=1/(float)oversamp_in;
                                 float h_zero;
                                 float h_Ts_4_roll_off;
                                 float sum=0;

                                 // Init the number of tap at zero
                                 k=0;

                                 // Work out h
                                 while (t<5.5 || t==5.5)
                                 {
                                    h_zero = 1/Ts*(1+roll_off_in*(4/PI-1));
                                    h_Ts_4_roll_off = roll_off_in/Ts/sqrt(2) * ((1+2/PI) * sin(PI/4/roll_off_in) + (1-2/PI) * cos(PI/4/roll_off_in));
                                    *(taps_out+k) = 1/Ts * (sin(PI*t/Ts*(1-roll_off_in)) + 4*roll_off_in*t/Ts*cos(PI*t/Ts*(1+roll_off_in))) / (PI * t/Ts * (1-(4*roll_off_in*t/Ts)*(4*roll_off_in*t/Ts)));

                                    //Replace h when t=0
                                    if (t==0) *(taps_out+k)=h_zero;

                                    //Replace h_Ts_4_roll_off
                                    if (t==Ts/4/roll_off_in) *(taps_out+k)=h_Ts_4_roll_off;
                                    if (t==-Ts/4/roll_off_in) *(taps_out+k)=h_Ts_4_roll_off;

                                    if (debug) printf("taps(%d)=%f t=%f\n",k ,*(taps_out+k),t);

                                    t=t+Tsamp;
                                    k=k+1;
                                 }
                                 // Return the number of taps
                                 *taps_out_size = k;

                                 //Normalize the filter to have a gain 1
                                 for(k=0;k<*taps_out_size;k++) sum=sum+*(taps_out+k);
                                 for(k=0;k<*taps_out_size;k++) *(taps_out+k)=*(taps_out+k)/sum;

                              }

int main() {

   int debug = DEBUG;
   FILE * fp;
   int data_stream_size = 256*256;
   int *data_stream_in   = malloc(data_stream_size*sizeof(int));
   int *data_stream_out   = malloc(data_stream_size*sizeof(int));
   int *shift_reg_in  = malloc(1*sizeof(int)); 
   int *modulated_data_I = malloc(data_stream_size*sizeof(int)); 
   float roll_off_in = 0.5;
   int oversamp_in = 4;
   float *taps_out = malloc(2048*sizeof(float));  
   int *taps_out_size = malloc(1*sizeof(int));  
   int k;

   printf("Started modulator\n");

   // -------------------------------------------------
   // -- Generate data stream
   // -------------------------------------------------

   // Init the stream
   for (k=0;k<data_stream_size;k++) *(data_stream_in+k)=1;

   //Init the seed
   *shift_reg_in=0x0;

   // Generate a random stream
   pn_23_enc_1b(data_stream_in, data_stream_size, shift_reg_in, data_stream_out, debug);

   // Debug write in file
   fp = fopen ("pn_23_enc_1b_out.txt","w");
   for(k = 0; k < data_stream_size;k++){
         fprintf (fp, "%d\n",*(data_stream_out+k));
   }
   fclose(fp);


   // -------------------------------------------------
   // -- Modulation scheme
   // -------------------------------------------------
   
   // BPSK modulation
   for(k = 0; k < data_stream_size;k++){
      if(*(data_stream_out+k)==1) *(modulated_data_I+k) = 1;
      if(*(data_stream_out+k)==0) *(modulated_data_I+k) = -1;
   }

   // Debug write in file
   fp = fopen ("modulated_data_I.txt","w");
   for(k = 0; k < data_stream_size;k++){
         fprintf (fp, "%d\n",*(modulated_data_I+k));
   }
   fclose(fp);

   // -------------------------------------------------
   // -- RRC filtering
   // -------------------------------------------------

   //Generete filter taps
   generate_rrc_filter_taps( roll_off_in, oversamp_in, taps_out, taps_out_size, 0);

   // Debug write in file
   fp = fopen ("rrc_taps.txt","w");
   for(k = 0; k < *taps_out_size;k++){
         fprintf (fp, "%f\n",*(taps_out+k));
   }
   fclose(fp);


   printf("End modulator\n");




   return 0;
}