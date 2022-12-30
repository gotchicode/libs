#include <stdlib.h>
#include <math.h>


void my_hbf( int data_in[2048], int taps[33], int data_out[2048], int init)
{
    int k;
    int j;
    int shift_register[33];
    int tmp;

    // Init the shift register
    if (init==1){
        for(j=0;j<33;j++){
            shift_register[j] = 0;
        }
    }

    // Filter
    for (k=0;k<2048;k++){


        // shift registers
        for(j=0;j<33-1;j++){
            shift_register[j+1] = shift_register[j];
        }

        // muliply and accumulate shift registers and taps
        tmp = 0;
        for(j=0;j<33;j++){
            tmp = tmp + shift_register[j] * taps[j];
            printf("j=%d tmp=%d shift_register=%d taps=%d\n", j, tmp, shift_register[j], taps[j]);
        }

        system('PAUSE');

        //load data
        shift_register[0] = data_in[k];

        data_out[k] = tmp;


    }

}
