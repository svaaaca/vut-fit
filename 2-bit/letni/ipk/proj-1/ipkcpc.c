/**
 * Implementace 1. ulohy do IPK 2022/23
 * Jmeno a prijmeni: David Kvacek
 * Login: xkvace00
 * Datum: 2023-03-21
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <errno.h>

#define MAX_LENGTH 1024

int sockfd;

void sigint_handler(int sig) {
    printf("\nGracefully terminating connection...\n");
    if (close(sockfd) == -1) {
        perror("Error closing socket");
    }
    exit(0);
}

void send_command(const char *command) {
    int nbytes, len = strlen(command);
    if ((nbytes = send(sockfd, command, len, 0)) != len) {
        fprintf(stderr, "Error sending command: %s\n", strerror(errno));
        exit(1);
    }
}

void read_response(char *response) {
    int nbytes, total_bytes = 0;
    do {
        if ((nbytes = recv(sockfd, response + total_bytes, MAX_LENGTH - total_bytes - 1, 0)) == -1) {
            fprintf(stderr, "Error receiving response: %s\n", strerror(errno));
            exit(1);
        }
        total_bytes += nbytes;
        response[total_bytes] = '\0';
    } while (total_bytes < MAX_LENGTH && !strstr(response, "\n"));
    response[strcspn(response, "\r\n")] = '\0'; // odstraneni zalomeni radku
}

int main(int argc, char **argv) {
    struct addrinfo hints, *res;
    int status;
    char command[MAX_LENGTH], response[MAX_LENGTH];
    char *host, *port, *mode;

    if (argc != 7) {
        fprintf(stderr, "Usage: %s -h <host> -p <port> -m <mode>\n", argv[0]);
        exit(1);
    }
    for (int i = 1; i < argc; i += 2) {
        if (strcmp(argv[i], "-h") == 0) {
            host = argv[i+1];
        } else if (strcmp(argv[i], "-p") == 0) {
            port = argv[i+1];
        } else if (strcmp(argv[i], "-m") == 0) {
            mode = argv[i+1];
        } else {
            fprintf(stderr, "Unknown option: %s\n", argv[i]);
            exit(1);
        }
    }

    signal(SIGINT, sigint_handler);

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET; // IPv4
    hints.ai_socktype = strcmp(mode, "udp") == 0 ? SOCK_DGRAM : SOCK_STREAM; // UDP nebo TCP
    if ((status = getaddrinfo(host, port, &hints, &res)) != 0) {
        fprintf(stderr, "Error getting address info: %s\n", gai_strerror(status));
        exit(1);
    }
    if ((sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol)) == -1) {
        fprintf(stderr, "Error creating socket: %s\n", strerror(errno));
        exit(1);
    }
    if (connect(sockfd, res->ai_addr, res->ai_addrlen) == -1) {
        fprintf(stderr, "Error connecting to server: %s\n", strerror(errno));
        exit(1);
    }
    freeaddrinfo(res);

    while (1) {
        if (fgets(command, MAX_LENGTH, stdin) == NULL) {
            fprintf(stderr, "Error reading command from input: %s\n", strerror(errno));
            exit(1);
        }
        if (strlen(command) == 1 && command[0] == '\n') { // prazdny prikaz
            continue;
        }
        send_command(command);
        read_response(response);
        if (strncmp(response, "ERR:", 4) == 0) {
            fprintf(stderr, "%s\n", response);
        } else {
            printf("%s\n", response);
        }
    }
return 0;
}
