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

    float *even_data_in_re = malloc(mid_index*sizeof(float));
    float *even_data_in_im = malloc(mid_index*sizeof(float));

    float *odd_data_in_re = malloc(mid_index*sizeof(float));
    float *odd_data_in_im = malloc(mid_index*sizeof(float));

    float *butterfly_factor_re = malloc(size*sizeof(float));
    float *butterfly_factor_im = malloc(size*sizeof(float));

    float *butterfly_factor_re_to_mid = malloc(size*sizeof(float));
    float *butterfly_factor_im_to_mid = malloc(size*sizeof(float));

    float *butterfly_factor_re_from_mid = malloc(size*sizeof(float));
    float *butterfly_factor_im_from_mid = malloc(size*sizeof(float));

    float *sign_table = malloc(size*sizeof(float));
    float *gain_table_re = malloc(size*sizeof(float));
    float *gain_table_im = malloc(size*sizeof(float));

    float *even_data_out_re = malloc(mid_index*sizeof(float));
    float *even_data_out_im = malloc(mid_index*sizeof(float));

    float *odd_data_out_re = malloc(mid_index*sizeof(float));
    float *odd_data_out_im = malloc(mid_index*sizeof(float));

    float *tmp_re = malloc(mid_index*sizeof(float));
    float *tmp_im = malloc(mid_index*sizeof(float));

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


    //Prepare butterfly factor
    for( k = 0; k < size/2; k++ ){
        *(gain_table_re+k) = cos(2*3.14159265359/(float)size*(float)k);
        *(gain_table_im+k) = -1*sin(2*3.14159265359/(float)size*(float)k);
        *(gain_table_re+size/2+k) = cos(2*3.14159265359/(float)size*(float)k);
        *(gain_table_im+size/2+k) = -1*sin(2*3.14159265359/(float)size*(float)k);
    }

    //Complete the butterfly factor
    for( k = 0; k < size/2; k++ ){
        *(butterfly_factor_re_to_mid+k) = *(gain_table_re+k) * *(sign_table+k);
        *(butterfly_factor_im_to_mid+k) = *(gain_table_im+k) * *(sign_table+k);
    }

    for( k = size/2; k < size; k++ ){
        *(butterfly_factor_re_from_mid+k-size/2) = *(gain_table_re+k) * *(sign_table+k);
        *(butterfly_factor_im_from_mid+k-size/2) = *(gain_table_im+k) * *(sign_table+k);
    }

    if (size>8)
    {

        //Recursive call of my_fft
        my_float_fft( even_data_in_re,
                      even_data_in_im,
                      even_data_out_re,
                      even_data_out_im,
                      mid_index);

        my_float_fft( odd_data_in_re,
                      odd_data_in_im,
                      odd_data_out_re,
                      odd_data_out_im,
                      mid_index);

    }
    if (size==8)
    {
        //Recursive call of my_dft
        my_float_dft( even_data_in_re,
                      even_data_in_im,
                      even_data_out_re,
                      even_data_out_im,
                      mid_index);


        my_float_dft( odd_data_in_re,
                      odd_data_in_im,
                      odd_data_out_re,
                      odd_data_out_im,
                      mid_index);
    }

    //first part
    my_float_complex_multiply(  odd_data_out_re,
                                odd_data_out_im,
                                butterfly_factor_re_to_mid,
                                butterfly_factor_im_to_mid,
                                tmp_re,
                                tmp_im,
                                mid_index);

    for( k = 0; k < mid_index; k++ ){

        *(data_out_re+k) = *(even_data_out_re+k) + *(tmp_re+k);
        *(data_out_im+k) = *(even_data_out_im+k) + *(tmp_im+k);
    }

    //second part
    my_float_complex_multiply(  odd_data_out_re,
                                odd_data_out_im,
                                butterfly_factor_re_from_mid,
                                butterfly_factor_im_from_mid,
                                tmp_re,
                                tmp_im,
                                mid_index);


    for( k = 0; k < mid_index; k++ ){

        *(data_out_re+mid_index+k) = *(even_data_out_re+k) + *(tmp_re+k);
        *(data_out_im+mid_index+k) = *(even_data_out_im+k) + *(tmp_im+k);
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
    free(butterfly_factor_re_to_mid);
    free(butterfly_factor_im_to_mid);
    free(butterfly_factor_re_from_mid);
    free(butterfly_factor_im_from_mid);

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


    for( k = 0; k < size; k++ ){
        accu_re=0;
        accu_im=0;

        for( n = 0; n < size; n++ ){

            *tmp_re = cos(2*3.14159265359/(float)size *(float)k*(float)n);
            *tmp_im = -1*sin(2*3.14159265359/(float)size *(float)k*(float)n);

            *data_in_re_tmp = *(data_in_re+n);
            *data_in_im_tmp = *(data_in_im+n);

            my_float_complex_multiply(tmp_re, tmp_im, data_in_re_tmp, data_in_im_tmp, accu_tmp_re, accu_tmp_im, 1);

            accu_re = accu_re + *accu_tmp_re;
            accu_im = accu_im + *accu_tmp_im;


        }

        *(data_out_re+k) =  accu_re;
        *(data_out_im+k) =  accu_im;
    }

	//free
    free(tmp_re);
    free(tmp_im);
    free(accu_tmp_re);
    free(accu_tmp_im);
    free(data_in_re_tmp);
    free(data_in_im_tmp);


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

        *(data_out_re+k)= (*(data_in_A_re+k)) * (*(data_in_B_re+k)) - (*(data_in_A_im+k))   * (*(data_in_B_im+k));
        *(data_out_im+k)= (*(data_in_A_re+k)) * (*(data_in_B_im+k)) + (*(data_in_A_im+k))   * (*(data_in_B_re+k));
    }

    return 0;


}
