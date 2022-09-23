#include <signal.h>
#include <stdlib.h>
#include <sys/prctl.h>
#include <unistd.h>

#include "qemu.h"

/* only for debug, print the packets */
#if 0
#define CAT(a, b) CAT_IMPL(a, b)
#define CAT_IMPL(a, b) a##b

#define gdb_send(conn, buf, size)       \
  ({                                    \
    printf("send:'%s'\n", (char *)buf); \
    gdb_send(conn, buf, size);          \
  })

#define gdb_recv(conn, size)                               \
  ({                                                       \
    char *CAT(s, __LINE__) = (void *)gdb_recv(conn, size); \
    printf("recv:'%s'\n", (char *)CAT(s, __LINE__));       \
    (uint8_t *)CAT(s, __LINE__);                           \
  })
#endif


const char* init_cmds[] = {
    "qXfer:features:read:target.xml:0,ffb",             // target.xml
    // "qXfer:features:read:riscv-64bit-cpu.xml:0,ffb",    // riscv-64bit-cpu.xml
    //"qXfer:features:read:riscv-64bit-fpu.xml:0,ffb",    // riscv-64bit-fpu.xml
    //"qXfer:features:read:riscv-64bit-fpu.xml:7fd,ffb",
    // "qXfer:features:read:riscv-64bit-virtual.xml:0,ffb",// riscv-64bit-virtual.xml
    "qXfer:features:read:riscv-csr.xml:0,ffb",          // riscv-csr.xml
    "qXfer:features:read:riscv-csr.xml:7fd,ffb",        
    "qXfer:features:read:riscv-csr.xml:ffa,ffb",      
    "qXfer:features:read:riscv-csr.xml:17f7,ffb"
};

int qemu_start(const char *elf, int port) {
    char remote_s[100];
    const char *exec = "qemu-system-riscv32";
    snprintf(remote_s, sizeof(remote_s), "tcp::%d", port);

    execlp(exec, exec, "-S", "-gdb", remote_s, "-bios", elf, "-M", "virt", "-m", "64M", "-nographic", NULL);

    return -1;
}

qemu_conn_t *qemu_connect(int port) {
    qemu_conn_t *conn = NULL;
    while (
            (conn = gdb_begin_inet("127.0.0.1", port)) == NULL) {
        usleep(1);
    }

    return conn;
}

void qemu_getregs(qemu_conn_t *conn, qemu_regs_t *r) {
    // read GPRs
    gdb_send(conn, (const uint8_t *) "g", 1);
    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);

    // printf("[DEBUG] check reply\n%s\n", reply);

    uint8_t *p = reply;
    uint8_t c;
    for (int i = 0; i < 33; i++) {
        c = p[8];
        p[8] = '\0';
        r->array[i] = gdb_decode_hex_str(p);
        p[8] = c;
        p += 8;
    }

    free(reply);
    qemu_getfprs(conn, r);
    qemu_getcsrs(conn, r);
}

bool qemu_setregs(qemu_conn_t *conn, qemu_regs_t *r) {
    int len = sizeof(qemu_regs_t);
    char *buf = (char *) malloc(len * 2 + 128);
    assert(buf != NULL);
    buf[0] = 'G';

    void *src = r;
    int p = 1;
    for (int i = 0; i < len; i++) {
        p += sprintf(buf + p, "%c%c",
                     hex_encode(((uint8_t *) src)[i] >> 4),
                     hex_encode(((uint8_t *) src)[i] & 0xf));
    }

    gdb_send(conn, (const uint8_t *) buf, strlen(buf));
    free(buf);

    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);
    bool ok = !strcmp((const char *) reply, "OK");
    free(reply);

    return ok;
}

bool qemu_single_step(qemu_conn_t *conn) {
    char buf[] = "vCont;s:1";
    gdb_send(conn, (const uint8_t *) buf, strlen(buf));
    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);
    free(reply);
    return true;
}

void qemu_break(qemu_conn_t *conn, uint32_t entry) {
    char buf[32];
    snprintf(buf, sizeof(buf), "Z0,%08x,4", entry);
    gdb_send(conn, (const uint8_t *) buf, strlen(buf));

    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);
    free(reply);
}

void qemu_remove_breakpoint(qemu_conn_t *conn, uint32_t entry) {
    char buf[32];
    snprintf(buf, sizeof(buf), "z0,%08x,4", entry);
    gdb_send(conn, (const uint8_t *) buf, strlen(buf));

    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);
    free(reply);
}

void qemu_continue(qemu_conn_t *conn) {
    char buf[] = "vCont;c:1";
    gdb_send(conn, (const uint8_t *) buf, strlen(buf));
    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);
    free(reply);
}

void qemu_disconnect(qemu_conn_t *conn) {
    gdb_end(conn);
}

inst_t qemu_getinst(qemu_conn_t *conn, uint32_t pc) {
    char buf[32];
    snprintf(buf, sizeof(buf), "m0x%x,4", pc);
    gdb_send(conn, (const uint8_t *) buf, strlen(buf));

    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);

    reply[8] = '\0';
    inst_t inst = gdb_decode_inst(reply);

    free(reply);
    return inst;
}

bool qemu_setinst(qemu_conn_t *conn, uint32_t pc, inst_t *inst) {
    int len = sizeof(inst_t);
    char buf[2*4+128];

    int p = snprintf(buf, sizeof(buf), "M%x,4:", pc); // 1+8+1+1+1 = 12

    void *src = inst;
    int i;
    for (i = 0; i < len; i++) {
        p += sprintf(buf + p, "%c%c",
                     hex_encode(((uint8_t *) src)[i] >> 4),
                     hex_encode(((uint8_t *) src)[i] & 0xf));
    }
    gdb_send(conn, (const uint8_t *) buf, strlen(buf));

    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);
    bool ok = !strcmp((const char *) reply, "OK");
    free(reply);

    return ok;
}

uint64_t qemu_getmem(qemu_conn_t *conn, uint32_t addr) {
    char buf[32];
    snprintf(buf, sizeof(buf), "m0x%x,4", addr);
    gdb_send(conn, (const uint8_t *) buf, strlen(buf));

    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);

    reply[8] = '\0';
    uint32_t content = gdb_decode_hex_str(reply);
    printf("0x%x: %08x\n", addr, content);

    free(reply);
    return content;
}

// can't work properly
bool qemu_setcsrs(qemu_conn_t *conn, int csr_num, uint32_t *data) {
    int len = sizeof(uint32_t);
    char buf[2*4+128];

    int p = snprintf(buf, sizeof(buf), "P%x=", csr_num); // 1+8+1+1+1 = 12
    printf("%s\n", buf);

    void *src = data;
    int i;
    for (i = 0; i < len; i++) {
        p += sprintf(buf + p, "%c%c",
                     hex_encode(((uint8_t *) src)[i] >> 4),
                     hex_encode(((uint8_t *) src)[i] & 0xf));
    }
    printf("%s\n", buf);

    gdb_send(conn, (const uint8_t *) buf, strlen(buf));
    // free(buf);

    size_t size;
    uint8_t *reply = gdb_recv(conn, &size);
    bool ok = !strcmp((const char *) reply, "OK");
    printf("%s\n", (const char *) reply);
    assert(ok == true);
    free(reply);

    return ok;
}

void qemu_getcsrs(qemu_conn_t *conn, qemu_regs_t *r) {
    const int csr_num_list[csrs_count] = {
        0x346,  // mstatus
        0x348,  // medeleg
        0x349,  // mideleg
        0x34a,  // mie
        0x38a,  // mip
        0x34b,  // mtvec
        0x386,  // mscratch
        0x387,  // mepc
        0x388,  // mcause
        0x389,  // mtval

        0x146,  // sstatus
        0x14a,  // sie
        0x14b,  // stvec
        0x186,  // scratch
        0x187,  // sepc
        0x188,  // scause
        0x189,  // stval
        0x18a,  // sip 
    };

    for (int i = 0; i < csrs_count; i++) {
        char buf[32];
        snprintf(buf, sizeof(buf), "p%x", csr_num_list[i]);
        gdb_send(conn, (const uint8_t *) buf, strlen(buf));
        size_t size;
        uint8_t *reply = gdb_recv(conn, &size);

        r->array[65 + i] = gdb_decode_hex_str(reply);
        free(reply);
    }   
}

void qemu_getfprs(qemu_conn_t *conn, qemu_regs_t *r) {
    const int fpu_base = 33;

    for (int i = 0; i < 32; i++) {
        char buf[32];
        snprintf(buf, sizeof(buf), "p%x", (fpu_base + i));
        gdb_send(conn, (const uint8_t *) buf, strlen(buf));
        size_t size;
        uint8_t *reply = gdb_recv(conn, &size);

        r->array[33 + i] = gdb_decode_hex_str(reply);
        // if (i == 1) {
        //     printf("[DEBUG] ft1 = %lx\n", r->array[33 + i]);
        // }
        free(reply);
    }   
}

void qemu_init(qemu_conn_t *conn) {
    int init_cmds_count = sizeof(init_cmds) / sizeof(init_cmds[0]);
    
    for (int i =0; i < init_cmds_count; i++) {
        gdb_send(conn, (const uint8_t *) init_cmds[i], strlen(init_cmds[i]));
        size_t size;
        uint8_t *reply = gdb_recv(conn, &size);
        free(reply);
    }
}
