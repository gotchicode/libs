int get_fft_init_table(float *data_in_re, float *data_in_im,float *data_out_re, float *data_out_im, int size, int select_size, int debug)

int my_float_fft_opt1_init_get_size(int size);

int my_float_fft_opt1_init(int size, float *data_out_re, float *data_out_im);

int my_float_dft_opt1_init(int size, float *data_out_re, float *data_out_im);

int my_float_fft_opt1(float *data_in_re, float *data_in_im, float *data_out_re, float *data_out_im, float *fft_init_data_in_re, float *fft_init_data_in_im, float *dft_init_data_in_re, float *dft_init_data_in_im, int size, int max_size)

int my_float_dft_opt1(float *data_in_re, float *data_in_im, float *data_out_re, float *data_out_im, float *dft_init_data_in_re, float *dft_init_data_in_im, int size);


int my_float_complex_multiply(float *data_in_A_re,
                                float *data_in_A_im,
                                float *data_in_B_re,
                                float *data_in_B_im,
                                float *data_out_re,
                                float *data_out_im,
                                int size);
