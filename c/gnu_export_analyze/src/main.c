#include <stdio.h>
#include <stdlib.h>


int main()
{


    unsigned char load_8b_var;
    FILE * bin;


    bin = fopen("C:\git_g\libs\c\gnu_export_analyze\export", "rb");

    while(1) {
        fread( load_8b_var, sizeof(load_8b_var), 1, bin);
        if(feof(bin)!=0)
            break;
        printf("%u\n",load_8b_var);
        system("PAUSE");
    }

    fclose(bin);


    printf("End\n");

    return 0;
}
