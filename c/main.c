#include <stdio.h>
#include <stdlib.h>

//int my_float_fft(float *data_in_re, float *data_in_im, float *data_out_re, float *data_out_im, int size)


void pn_23_enc_1b(uint *data_in, int data_in_size, uint *shift_reg_in, uint *shift_reg_out, uint *data_out, int debug)
{
    int k;
    uint shift_reg = 0;
    uint tmp=0;
    uint out_tmp=0;
    uint out=0;
    shift_reg = *shift_reg_in;
    if (debug) printf("%d\n", shift_reg);
    for (k=1;k<data_in_size+1;k++)
    {
        tmp = *(data_in+k-1);
        out_tmp = ((shift_reg>>22)&0x01) ^ ((shift_reg>>17)&0x01);
        out = tmp ^ out_tmp;
        *(data_out+k-1) = out;
        shift_reg = ((shift_reg <<1 ) & 0x7FFFFF) + out;
        if (debug) printf("%d %d\n",k, out_tmp);
    }
    *shift_reg_out = shift_reg;
}

int main()
{

    //File write
    FILE * fp;
    int k;

    // UUT function
    int data_in_size = 256;
    uint *data_in = malloc(data_in_size*sizeof(uint));
    uint *shift_reg_in = malloc(1*sizeof(uint));
    uint *shift_reg_out = malloc(1*sizeof(uint));
    uint *data_out = malloc(data_in_size*sizeof(uint));

    //Init
    *(shift_reg_in) = 0x0;
    for (k=0;k<data_in_size;k++) {
        *(data_in+k)=1;
    }

    printf("pause\n");
    int c = getchar();

    //Call
    pn_23_enc_1b(data_in, data_in_size, shift_reg_in, shift_reg_out, data_out, 0);

    printf("pause\n");
    c = getchar();

    //Debug
    fp = fopen ("data_out.txt","w");
    for(k = 0; k < data_in_size;k++){
        fprintf (fp, "%d\n",*(data_out+k));
    }
    fclose(fp);


    free(data_in);
    free(shift_reg_in);
    free(shift_reg_out);
    free(data_out);

    printf("end of program\n");

    return 0;
}