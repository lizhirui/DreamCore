#include <arpa/inet.h>
#include <assert.h>
#include <malloc.h>
#include <netinet/in.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/signal.h>
#include <unistd.h>

#include "debug.h"
#include "gdb_proto.h"


int start_gdb(int port) {
    char symbol_s[100], remote_s[100];
    const char *exec = "riscv64-unknown-elf-gdb";

    // snprintf(symbol_s, sizeof(symbol_s), "symbol %s", symbol_file);
    snprintf(remote_s, sizeof(remote_s), "target remote 127.0.0.1:%d", port);
    execlp(exec, exec, "-ex", symbol_s, "-ex", remote_s, NULL);

    return -1;
}

void start_bridge(int port, int serv_port) {
    struct gdb_conn *client = gdb_server_start(port);
    struct gdb_conn *server = gdb_begin_inet("127.0.0.1", serv_port);

    size_t size = 0;
    char *data = NULL;
    while (1) {
        data = (char *) (void *) gdb_recv(client, &size);
        printf("$ message: client --> server:%lx:\n", size);
        printf("'%s'\n", data);
        printf("\n");
        gdb_send(server, (const uint8_t *) data, size);
        free(data);

        data = (char *) (void *) gdb_recv(server, &size);
        printf("$ message: server --> client:%lx:\n", size);
        printf("'%s'\n", data);
        gdb_send(client, (const uint8_t *) data, size);
        printf("\n\n");
        free(data);
    }
}

int get_free_servfd() {
    // fill the socket information
    struct sockaddr_in sa;

    sa.sin_family = AF_INET;
    sa.sin_port = 0;
    sa.sin_addr.s_addr = htonl(INADDR_ANY);

    // open the socket and start the tcp connection
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (bind(fd, (const struct sockaddr *) &sa, sizeof(sa)) != 0) {
        close(fd);
        panic("bind");
    }
    return fd;
}

int get_port_of_servfd(int fd) {
    struct sockaddr_in serv_addr;
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = 0;

    socklen_t len = sizeof(serv_addr);
    if (getsockname(fd, (struct sockaddr *) &serv_addr, &len) == -1) {
        perror("getsockname");
        return -1;
    }
    return ntohs(serv_addr.sin_port);
}
