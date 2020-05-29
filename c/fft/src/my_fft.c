#include <stdlib.h>
#include <math.h>

int my_float_fft(float *data_in_re, float *data_in_im, float *data_out_re, float *data_out_im, int size)
{
    //Variable
    int k;
    int m;
    int mid_index;
    int max_index;

    //Init
    mid_index = size/2;
    max_index = size;

    printf("even_data_in_re* pointers creation\n");
    //float *even_data_in_re = malloc(mid_index*sizeof(float));
    //float *even_data_in_im = malloc(mid_index*sizeof(float));
    float *even_data_in_re = malloc(100000);
    float *even_data_in_im = malloc(100000);


    printf("odd_data_in_re* pointers creation\n");
    printf("IMPORTANT, FIND WHAT HAPPENED\n");
    float *odd_data_in_re = malloc(100000);
    float *odd_data_in_im = malloc(100000);
    //float *odd_data_in_re = malloc(mid_index*sizeof(float));
    //float *odd_data_in_im = malloc(mid_index*sizeof(float));

    float *butterfly_factor_re = malloc(size*sizeof(float));
    float *butterfly_factor_im = malloc(size*sizeof(float));

    float *sign_table = malloc(size*sizeof(float));
    float *gain_table_re = malloc(size*sizeof(float));
    float *gain_table_im = malloc(size*sizeof(float));

    float *even_data_out_re = malloc(mid_index*sizeof(float));
    float *even_data_out_im = malloc(mid_index*sizeof(float));

    float *odd_data_out_re = malloc(mid_index*sizeof(float));
    float *odd_data_out_im = malloc(mid_index*sizeof(float));

    float *tmp_re = malloc(mid_index*sizeof(float));
    float *tmp_im = malloc(mid_index*sizeof(float));


    printf("mid_index=%d\n",mid_index);
    printf("max_index=%d\n",max_index);
    printf("even_data_in_re prepare begin\n");

    //Prepare even_data_in_re and even_data_in_im
    m=0;
    for( k = 0; k < size; k=k+2 ){
        *(even_data_in_re+m) = *(data_in_re+k);
        *(even_data_in_im+m) = *(data_in_im+k);
        m=m+1;
    }

    //Prepare odd_data_in_re and odd_data_in_im
    m=0;
    for( k = 1; k < size; k=k+2 ){
        *(odd_data_in_re+m) = *(data_in_re+k);
        *(odd_data_in_im+m) = *(data_in_im+k);
        m=m+1;
    }

    //Prepare signs of butterfly
    for( k = 0; k < size/2; k++ ){
        *(sign_table+k) = 1;
        *(sign_table+size/2+k) = -1;
    }

    //mid_index
    printf("Gain table sign start begin\n");

    //Prepare butterfly factor
    for( k = 0; k < size/2; k++ ){
        *(gain_table_re+k) = cos(2*3.14159265359/(float)size*(float)k);
        *(gain_table_im+k) = -1*sin(2*3.14159265359/(float)size*(float)k);
        *(gain_table_re+size/2+k) = cos(2*3.14159265359/(float)size*(float)k);
        *(gain_table_im+size/2+k) = -1*sin(2*3.14159265359/(float)size*(float)k);
    }

    //Complete the butterfly factor
    printf("butterfly_factor_re start begin\n");
    for( k = 0; k < size; k++ ){
        *(butterfly_factor_re+k) = *(gain_table_re+k) * *(sign_table+k);
        *(butterfly_factor_im+k) = *(gain_table_im+k) * *(sign_table+k);
    }

    if (size>8)
    {

        ////printf dtf inputs for debug
        //for( k = 0; k < size; k++ ){
        //    printf("*(even_data_in_re+%d)=%.16f\n",k,*(even_data_in_re+k));
        //    printf("*(even_data_in_im+%d)=%.16f\n",k,*(even_data_in_im+k));
        //}
        //system("pause");


        //Recursive call of my_fft
        //printf("call my_float_fft\n");
        my_float_fft( even_data_in_re,
                      even_data_in_im,
                      even_data_out_re,
                      even_data_out_im,
                      mid_index);

        //printf("call my_float_fft\n");
        my_float_fft( odd_data_in_re,
                      odd_data_in_im,
                      odd_data_out_re,
                      odd_data_out_im,
                      mid_index);
    }
    if (size==8)
    {

        ////printf dtf inputs for debug
        //for( k = 0; k < size; k++ ){
        //    printf("*(even_data_in_re+%d)=%.16f\n",k,*(even_data_in_re+k));
        //    printf("*(even_data_in_im+%d)=%.16f\n",k,*(even_data_in_im+k));
        //}
        //system("pause");


        //Recursive call of my_dft
        //printf("call my_float_dft\n");
        my_float_dft( even_data_in_re,
                      even_data_in_im,
                      even_data_out_re,
                      even_data_out_im,
                      mid_index);


        //printf("call my_float_dft\n");
        my_float_dft( odd_data_in_re,
                      odd_data_in_im,
                      odd_data_out_re,
                      odd_data_out_im,
                      mid_index);
    }

    //Data out
    //printf("call my_float_complex_multiplmid_indexy\n");
    my_float_complex_multiply(  odd_data_out_re,
                                odd_data_out_re,
                                butterfly_factor_re,
                                butterfly_factor_im,
                                tmp_re,
                                tmp_im,
                                mid_index);

    for( k = 0; k < mid_index; k++ ){

        //tmp_re = *(odd_data_out_re+k) * *(
        //tmp_im = *(odd_data_out_im+k) * *(


        *(data_out_re+k) = *(even_data_out_re+k) + *(tmp_re+k);
        *(data_out_im+k) = *(even_data_out_im+k) + *(tmp_im+k);
    }

    //Free
    free(even_data_in_re);
    free(even_data_in_im);
    free(odd_data_in_re);
    free(odd_data_in_im);
    free(sign_table);
    free(gain_table_re);
    free(gain_table_im);
    free(even_data_out_re);
    free(even_data_out_im);
    free(butterfly_factor_re);
    free(butterfly_factor_im);

    return 0;


}

int my_float_dft(float *data_in_re, float *data_in_im, float *data_out_re, float *data_out_im, int size)
{

    int k;
    int n;
    float *tmp_re=malloc(sizeof(float));
    float *tmp_im=malloc(sizeof(float));
    float *accu_tmp_re=malloc(sizeof(float));
    float *accu_tmp_im=malloc(sizeof(float));
    float *data_in_re_tmp=malloc(sizeof(float));
    float *data_in_im_tmp=malloc(sizeof(float));
    float accu_re;
    float accu_im;

    ////printf dtf inputs for debug
    //for( k = 0; k < size; k++ ){
    //    printf("*(data_in_re+%d)=%.16f\n",k,*(data_in_re+k));
    //    printf("*(data_in_im+%d)=%.16f\n",k,*(data_in_im+k));
    //}
    //system("pause");

    //printf("size=%d\n",size);
    //system("pause");

    for( k = 0; k < size; k++ ){
        accu_re=0;
        accu_im=0;
        //printf("First loop of dft\n");
        for( n = 0; n < size; n++ ){
             //printf("Do cos and sin k=%d and n=%d\n",k , n);
            *tmp_re = cos(2*3.14159265359/(float)size *(float)k*(float)n);
            *tmp_im = -1*sin(2*3.14159265359/(float)size *(float)k*(float)n);

            //printf("(*tmp_re)=%.16f  ",*tmp_re);
            //printf("(*tmp_im)=%.16f\n",*tmp_im);

            //printf("cos and sin done\n");
            *data_in_re_tmp = *(data_in_re+n);
            *data_in_im_tmp = *(data_in_im+n);

            //printf("Loop of dft and call my_float_complex_multiply\n");
            my_float_complex_multiply(tmp_re, tmp_im, data_in_re_tmp, data_in_im_tmp, accu_tmp_re, accu_tmp_im, 1);

            //printf("my_float_complex_multiply done\n");

            //system("pause");

            accu_re = accu_re + *accu_tmp_re;
            accu_im = accu_im + *accu_tmp_im;
            //printf("Accu done\n");


        }
        printf("(*accu_re)=%.16f  ",accu_re);
        printf("(*accu_im)=%.16f\n",accu_im);
        *(data_out_re+k) =  accu_re;
        *(data_out_im+k) =  accu_im;
    }

    //for( k = 0; k < size; k++ ){
    //    printf("*(data_out_re+%d)=%.16f\n",k,*(data_out_re+k));
    //    printf("*(data_out_im+%d)=%.16f\n",k,*(data_out_im+k));
    //}
    //system("pause");

    //system("pause");
    return 0;
}

int my_float_complex_multiply(float *data_in_A_re,
                                float *data_in_A_im,
                                float *data_in_B_re,
                                float *data_in_B_im,
                                float *data_out_re,
                                float *data_out_im,
                                int size)
{
    int k;

    for( k = 0; k < size; k++ ){

    //       data_out = (data_in_A_re+j*data_in_A_im) * (data_in_B_re+j*data_in_B_im)
    //       data_in_A_re*data_in_B_re + data_in_A_re*j*data_in_B_im + j*data_in_A_im*data_in_B_re - data_in_A_im*data_in_B_im
    //       data_out_re = data_in_A_re*data_in_B_re - data_in_A_im*data_in_B_im
    //       data_out_im = data_in_A_re*j*data_in_B_im + j*data_in_A_im*data_in_B_re

        //printf("(data_in_A_re+%d)=%.16f\n",k,*(data_in_A_re+k));
        //printf("(data_in_A_re+%d)=%.16f\n",k,*(data_in_A_im+k));
        //printf("(data_in_B_re+%d)=%.16f\n",k,*(data_in_B_re+k));
        //printf("(data_in_B_im+%d)=%.16f\n",k,*(data_in_B_im+k));

        *(data_out_re+k)= (*(data_in_A_re+k)) * (*(data_in_B_re+k)) - (*(data_in_A_im+k))   * (*(data_in_B_im+k));
        *(data_out_im+k)= (*(data_in_A_re+k)) * (*(data_in_B_im+k)) + (*(data_in_A_im+k))   * (*(data_in_B_re+k));

        //printf("(data_out_re+%d)=%f\n",k,*(data_out_re+k));
        //printf("(data_out_im+%d)=%f\n",k,*(data_out_im+k));

        //system("pause");

    }

    return 0;


}
