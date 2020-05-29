int my_float_fft(float *data_in_re, float *data_in_im, float *data_out_re, float *data_out_im, int size);

int my_float_dft(float *data_in_re, float *data_in_im, float *data_out_re, float *data_out_im, int size);


int my_float_complex_multiply(float *data_in_A_re,
                                float *data_in_A_im,
                                float *data_in_B_re,
                                float *data_in_B_im,
                                float *data_out_re,
                                float *data_out_im,
                                int size);