#include <stdio.h>
#include <stdlib.h>
#include "my_hbf.h"


int main()


{

 //File pointer
 FILE * fp;
 
 int data_in[2048];
 int taps[33]; 
 int data_out[2048];
 int val;
 int ind;
 int k;
 
 //Load taps
 printf("load taps\n");
 k=0;
 ind=0;
 fp = fopen("C:/git_g/libs/c/hbf/validation/taps.txt", "r");
 if (fp) {
    while (fscanf(fp, "%d", &val)!=EOF)
    {
        printf("%d\n",val);
        taps[k]=val;
        k=k+1;
    }
 fclose(fp);
 }
 
 //Load data
printf("load data\n");
k=0;
fp = fopen("C:/git_g/libs/c/hbf/validation/data_in.txt", "r");
if (fp) {
   while (fscanf(fp, "%d", &val)!=EOF)
   {
       printf("%d\n",val);
       data_in[k]=val;
       k=k+1;
   }
fclose(fp);
}

/*
 
 //Display taps
 printf("Display taps\n");
 for (k=0;k<33;k++){
     printf("taps[%d]=%d\n",k , taps[k]);
 }
 
 //Display data in
 printf("Display data in\n");
 for (k=0;k<2048;k++){
     printf("data_in[%d]=%d\n",k , data_in[k]);
 }
 
 */
 
 
// Filter
my_hbf( data_in, taps, data_out, 0);

fp = fopen("C:/git_g/libs/c/hbf/validation/data_out.txt", "w");
for (k=0; k<2048; k++){
    fprintf(fp,"%d\n",data_out[k]);
}
fclose(fp);

}