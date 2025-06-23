// gcc test.c -o test.exe -lws2_32

#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include <winsock2.h>
#include <stdio.h>
#include <stdint.h>
#include <windows.h>

#pragma comment(lib, "ws2_32.lib")

void generate_prbs23(uint8_t *buffer, int length) {
    uint32_t reg = 0x7FFFFF;
    for (int i = 0; i < length * 8; ++i) {
        uint8_t bit = ((reg >> 22) ^ (reg >> 17)) & 1;
        reg = ((reg << 1) | bit) & 0x7FFFFF;
        if (i % 8 == 0) buffer[i / 8] = 0;
        buffer[i / 8] |= (bit << (i % 8));
    }
}

void run_prbs_server() {
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

    closesocket(client);
    closesocket(server);
    WSACleanup();
}

int main() {
    char choice[10];

    while (1) {
        printf("\n=== C Server Menu ===\n");
        printf("1: Start PRBS15/23 Test\n");
        printf("0: Exit\n");
        printf("Enter choice: ");
        fgets(choice, sizeof(choice), stdin);

        if (choice[0] == '1') {
            run_prbs_server();
        } else if (choice[0] == '0') {
            printf("Exiting.\n");
            break;
        } else {
            printf("Invalid choice. Try again.\n");
        }
    }

    return 0;
}
