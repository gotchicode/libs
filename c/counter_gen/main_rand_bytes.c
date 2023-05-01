#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s [file size in bytes] [filename]\n", argv[0]);
        return 1;
    }

    long int size = atol(argv[1]);
    char* filename = argv[2];
    FILE* fp = fopen(filename, "wb");
    
    if (!fp) {
        printf("Error: Unable to open file %s\n", filename);
        return 1;
    }

    // Generate random values and write to file
    srand(time(NULL));
    for (long int i = 0; i < size; i += sizeof(int)) {
        int value = rand();
        fwrite(&value, sizeof(int), 1, fp);
    }

    fclose(fp);
    printf("Successfully wrote %ld bytes to %s\n", size, filename);
    return 0;
}
