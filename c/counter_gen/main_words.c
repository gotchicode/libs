#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <num_words> <filename>\n", argv[0]);
        return 1;
    }
    if (strcmp(argv[1], "help") == 0) {
        printf("Usage: %s <num_words> <filename>\n", argv[0]);
        printf("Writes a binary file with the specified number of 16-bit words,\n");
        printf("incrementing from 0 to num_words-1, with the specified filename.\n");
        return 0;
    }
    int num_words = atoi(argv[1]);
    if (num_words <= 0) {
        fprintf(stderr, "Invalid number of words: %s\n", argv[1]);
        return 1;
    }
    FILE *fp = fopen(argv[2], "wb");
    if (!fp) {
        perror("Failed to open file");
        return 1;
    }
    uint16_t counter = 0;
    for (int i = 0; i < num_words; i++) {
        fwrite(&counter, sizeof(counter), 1, fp);
        counter++;
    }
    fclose(fp);
    return 0;
}
