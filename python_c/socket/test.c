// gcc test.c -o test.exe -lws2_32

#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include <winsock2.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <windows.h>
#include <math.h>
#define PI 3.14159265358979323846
#define SAMPLE_RATE 44800.0
#define SINE_FREQ 1000.0
#define MOD_SINE_FREQ 1000.0
#define MOD_AMPL_FREQ 1.0
#define FM_CARRIER_FREQ 1000.0
#define FM_MOD_FREQ     1.0
#define FM_DEVIATION    200.0



#pragma comment(lib, "ws2_32.lib")

static double sine_phase = 0.0;
static double sine_phase_mod = 0.0;
static double amp_phase = 0.0;
static double fm_phase = 0.0;
static double fm_mod_phase = 0.0;


void generate_sine_wave(uint8_t *buffer, int length) {
    double phase_step = 2.0 * PI * SINE_FREQ / SAMPLE_RATE;

    for (int i = 0; i < length; ++i) {
        double sample = sin(sine_phase);
        buffer[i] = (uint8_t)(128 + sample * 127);  // convert to unsigned 8-bit
        sine_phase += phase_step;
        if (sine_phase >= 2.0 * PI)
            sine_phase -= 2.0 * PI;
    }
}

void generate_fm_sine(uint8_t *buffer, int length) {
    for (int i = 0; i < length; ++i) {
        double mod = sin(fm_mod_phase);  // [-1, +1]
        double inst_freq = FM_CARRIER_FREQ + FM_DEVIATION * mod;
        double phase_step = 2.0 * PI * inst_freq / SAMPLE_RATE;

        double sample = sin(fm_phase);
        buffer[i] = (uint8_t)(128 + sample * 127);

        fm_phase += phase_step;
        fm_mod_phase += 2.0 * PI * FM_MOD_FREQ / SAMPLE_RATE;

        if (fm_phase >= 2.0 * PI) fm_phase -= 2.0 * PI;
        if (fm_mod_phase >= 2.0 * PI) fm_mod_phase -= 2.0 * PI;
    }
}



void generate_prbs23(uint8_t *buffer, int length) {
    uint32_t reg = 0x7FFFFF;
    for (int i = 0; i < length * 8; ++i) {
        uint8_t bit = ((reg >> 22) ^ (reg >> 17)) & 1;
        reg = ((reg << 1) | bit) & 0x7FFFFF;
        if (i % 8 == 0) buffer[i / 8] = 0;
        buffer[i / 8] |= (bit << (i % 8));
    }
}

void handle_mode1(SOCKET client) {
    while (1) {
        uint8_t buffer[255];
        int recv_size = recv(client, (char*)buffer, sizeof(buffer), 0);
        if (recv_size <= 0) {
            printf("[C] Connection closed or error.\n");
            break;
        }

        printf("[C] Received PRBS15 Frame: ");
        for (int i = 0; i < recv_size; i++) {
            printf("%02X", buffer[i]);
        }
        printf("\n");

        uint8_t response[255];
        generate_prbs23(response, 255);
        send(client, (char*)response, 255, 0);
        printf("[C] Sent PRBS23 Frame\n");

        Sleep(100);
    }
}

void handle_mode2_once(SOCKET client) {
    uint8_t header[5];
    int received = 0;
    while (received < 5) {
        int r = recv(client, (char*)&header[received], 5 - received, 0);
        if (r <= 0) {
            printf("[C] Error receiving mode 2 header.\n");
            return;
        }
        received += r;
    }

    if (header[0] != 0xAA) {
        printf("[C] Invalid mode 2 header byte.\n");
        return;
    }

    uint32_t length = (header[1] << 24) | (header[2] << 16) | (header[3] << 8) | header[4];
    if (length == 0 || length > 4096) {
        printf("[C] Invalid requested length: %u\n", length);
        return;
    }

    printf("[C] Mode 2: Sending %u PRBS23 bytes\n", length);

    uint8_t *response = (uint8_t*)malloc(length);
    if (!response) {
        printf("[C] Memory allocation failed.\n");
        return;
    }

    generate_prbs23(response, length);
    send(client, (char*)response, length, 0);
    printf("[C] Sent PRBS23 response.\n");

    free(response);
}

void handle_mode3_loop(SOCKET client) {
    printf("[C] Entering mode 3 (looping PRBS23 responder)...\n");

    while (1) {
        uint8_t header[5];
        int received = 0;

        // Wait for header (0xAA + 4 bytes)
        while (received < 5) {
            int r = recv(client, (char*)&header[received], 5 - received, 0);
            if (r <= 0) {
                printf("[C] Client disconnected or error.\n");
                return;
            }
            received += r;
        }

        if (header[0] != 0xAA) {
            printf("[C] Invalid header prefix: 0x%02X\n", header[0]);
            continue;
        }

        uint32_t length = (header[1] << 24) | (header[2] << 16) | (header[3] << 8) | header[4];
        if (length == 0 || length > 4096) {
            printf("[C] Invalid requested length: %u\n", length);
            continue;
        }

        printf("[C] Mode 3: Received request for %u bytes\n", length);

        uint8_t *response = (uint8_t*)malloc(length);
        if (!response) {
            printf("[C] Memory allocation failed.\n");
            return;
        }

        generate_prbs23(response, length);
        send(client, (char*)response, length, 0);
        printf("[C] Sent PRBS23 response.\n");

        free(response);
        Sleep(100);
    }
}

void handle_mode4_audio_stream(SOCKET client) {
    printf("[C] Entering mode 4 (audio sine wave streaming)...\n");

    while (1) {
        uint8_t header[5];
        int received = 0;

        while (received < 5) {
            int r = recv(client, (char*)&header[received], 5 - received, 0);
            if (r <= 0) {
                printf("[C] Client disconnected or error.\n");
                return;
            }
            received += r;
        }

        if (header[0] != 0xAA) {
            printf("[C] Invalid header prefix: 0x%02X\n", header[0]);
            continue;
        }

        uint32_t length = (header[1] << 24) | (header[2] << 16) | (header[3] << 8) | header[4];
        if (length == 0 || length > 8192) {
            printf("[C] Invalid requested length: %u\n", length);
            continue;
        }

        printf("[C] Mode 4: Generating %u bytes of sine wave\n", length);

        uint8_t *response = (uint8_t*)malloc(length);
        if (!response) {
            printf("[C] Memory allocation failed.\n");
            return;
        }

        generate_sine_wave(response, length);
        send(client, (char*)response, length, 0);
        free(response);
    }
}

void generate_modulated_sine(uint8_t *buffer, int length) {
    double sine_step = 2.0 * PI * MOD_SINE_FREQ / SAMPLE_RATE;
    double amp_step = 2.0 * PI * MOD_AMPL_FREQ / SAMPLE_RATE;

    for (int i = 0; i < length; ++i) {
        double amp = 0.5 + 0.5 * sin(amp_phase); // amplitude in [0,1]
        double sample = amp * sin(sine_phase_mod);
        buffer[i] = (uint8_t)(128 + sample * 127);

        sine_phase_mod += sine_step;
        amp_phase += amp_step;

        if (sine_phase_mod >= 2.0 * PI)
            sine_phase_mod -= 2.0 * PI;
        if (amp_phase >= 2.0 * PI)
            amp_phase -= 2.0 * PI;
    }
}

void handle_mode5_modulated_audio(SOCKET client) {
    printf("[C] Entering mode 5 (modulated 1Hz on 1000Hz sine)...\n");

    while (1) {
        uint8_t header[5];
        int received = 0;

        while (received < 5) {
            int r = recv(client, (char*)&header[received], 5 - received, 0);
            if (r <= 0) {
                printf("[C] Client disconnected or error.\n");
                return;
            }
            received += r;
        }

        if (header[0] != 0xAA) {
            printf("[C] Invalid header prefix: 0x%02X\n", header[0]);
            continue;
        }

        uint32_t length = (header[1] << 24) | (header[2] << 16) | (header[3] << 8) | header[4];
        if (length == 0 || length > 8192) {
            printf("[C] Invalid requested length: %u\n", length);
            continue;
        }

        uint8_t *response = (uint8_t*)malloc(length);
        if (!response) {
            printf("[C] Memory allocation failed.\n");
            return;
        }

        generate_modulated_sine(response, length);
        send(client, (char*)response, length, 0);
        free(response);
    }
}

void handle_mode6_fm_audio(SOCKET client) {
    printf("[C] Entering mode 6 (FM sweep 800–1200Hz)...\n");

    while (1) {
        uint8_t header[5];
        int received = 0;

        while (received < 5) {
            int r = recv(client, (char*)&header[received], 5 - received, 0);
            if (r <= 0) {
                printf("[C] Client disconnected or error.\n");
                return;
            }
            received += r;
        }

        if (header[0] != 0xAA) {
            printf("[C] Invalid header prefix: 0x%02X\n", header[0]);
            continue;
        }

        uint32_t length = (header[1] << 24) | (header[2] << 16) | (header[3] << 8) | header[4];
        if (length == 0 || length > 8192) {
            printf("[C] Invalid requested length: %u\n", length);
            continue;
        }

        uint8_t *response = (uint8_t*)malloc(length);
        if (!response) {
            printf("[C] Memory allocation failed.\n");
            return;
        }

        generate_fm_sine(response, length);
        send(client, (char*)response, length, 0);
        free(response);
    }
}


void run_server(int mode) {
    WSADATA wsa;
    SOCKET server, client;
    struct sockaddr_in server_addr, client_addr;
    int c;

    printf("[C] Initializing Winsock...\n");
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        printf("[C] Winsock failed. Error Code : %d\n", WSAGetLastError());
        return;
    }

    if ((server = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET) {
        printf("[C] Could not create socket : %d\n", WSAGetLastError());
        WSACleanup();
        return;
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    server_addr.sin_port = htons(12345);

    if (bind(server, (struct sockaddr *)&server_addr, sizeof(server_addr)) == SOCKET_ERROR) {
        printf("[C] Bind failed with error code : %d\n", WSAGetLastError());
        closesocket(server);
        WSACleanup();
        return;
    }

    listen(server, 1);
    printf("[C] Waiting for incoming connection...\n");

    c = sizeof(struct sockaddr_in);
    client = accept(server, (struct sockaddr *)&client_addr, &c);
    if (client == INVALID_SOCKET) {
        printf("[C] Accept failed: %d\n", WSAGetLastError());
        closesocket(server);
        WSACleanup();
        return;
    }

    printf("[C] Connection accepted\n");

    if (mode == 1)
        handle_mode1(client);
    else if (mode == 2)
        handle_mode2_once(client);
    else if (mode == 3)
        handle_mode3_loop(client);
    else if (mode == 4)
        handle_mode4_audio_stream(client);
    else if (mode == 5)
        handle_mode5_modulated_audio(client);
    else if (mode == 6)
        handle_mode6_fm_audio(client);

    closesocket(client);
    closesocket(server);
    WSACleanup();
}

int main() {
    char choice[10];

    while (1) {
        printf("\n=== C Server Menu ===\n");
        printf("1: Start PRBS15/23 Test\n");
        printf("2: Respond to PRBS23 request (once)\n");
        printf("3: Respond to PRBS23 requests in loop\n");
        printf("4: Stream 1000Hz sine wave (audio test)\n");
        printf("5: Modulated 1Hz tremolo on 1000Hz tone (Compatible with 4)\n");
        printf("6: Frequency-modulated 1Hz sweep around 1000Hz (+/- 200 Hz) (Compatible with 4)\n");
        printf("0: Exit\n");
        printf("Enter choice: ");
        fgets(choice, sizeof(choice), stdin);

        if (choice[0] == '1') {
            run_server(1);
        } else if (choice[0] == '2') {
            run_server(2);
        } else if (choice[0] == '3') {
            run_server(3);
        } else if (choice[0] == '4') {
            run_server(4);
        } else if (choice[0] == '5') {
            run_server(5);
        } else if (choice[0] == '6') {
            run_server(6);
        } else if (choice[0] == '0') {
            printf("Exiting.\n");
            break;
        } else {
            printf("Invalid choice. Try again.\n");
        }
    }

    return 0;
}
