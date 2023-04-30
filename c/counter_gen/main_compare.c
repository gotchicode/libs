#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 1024

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s file1 file2\n", argv[0]);
        return 1;
    }

    FILE *fp1, *fp2;
    char buf1[BUFFER_SIZE], buf2[BUFFER_SIZE];
    size_t n1, n2;
    int line = 1, column = 0, errors = 0;

    fp1 = fopen(argv[1], "rb");
    fp2 = fopen(argv[2], "rb");
    if (fp1 == NULL) {
        printf("Error: cannot open file %s\n", argv[1]);
        return 1;
    }
    if (fp2 == NULL) {
        printf("Error: cannot open file %s\n", argv[2]);
        fclose(fp1);
        return 1;
    }

    do {
        n1 = fread(buf1, 1, BUFFER_SIZE, fp1);
        n2 = fread(buf2, 1, BUFFER_SIZE, fp2);
        column += n1;

        if (n1 != n2 || memcmp(buf1, buf2, n1) != 0) {
            printf("Difference found at line %d, column %d\n", line, column - n1);
            errors++;
        }

        for (int i = 0; i < n1; i++) {
            if (buf1[i] == '\n') {
                line++;
                column = 0;
            }
        }

    } while (n1 > 0 && n2 > 0);

    if (n1 != n2) {
        printf("Files have different lengths\n");
        errors++;
    }

    if (errors == 0) {
        printf("Files are identical\n");
    } else {
        printf("%d difference(s) found\n", errors);
    }

    fclose(fp1);
    fclose(fp2);
    return 0;
}
