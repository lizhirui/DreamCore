#ifndef QEMU_H
#define QEMU_H

#include <stdbool.h>
#include "gdb_proto.h"
#include "isa.h"

typedef struct gdb_conn qemu_conn_t;

int qemu_start(const char *elf, int port);

qemu_conn_t *qemu_connect(int port);

void qemu_disconnect(qemu_conn_t *conn);

// bool qemu_memcpy_to_qemu_small(qemu_conn_t *conn, uint32_t dest, void *src, int len);

// bool qemu_memcpy_to_qemu(qemu_conn_t *conn, uint32_t dest, void *src, int len);

void qemu_getregs(qemu_conn_t *conn, qemu_regs_t *r);

bool qemu_setregs(qemu_conn_t *conn, qemu_regs_t *r);

bool qemu_single_step(qemu_conn_t *conn);

void qemu_break(qemu_conn_t *conn, uint32_t entry);

void qemu_remove_breakpoint(qemu_conn_t *conn, uint32_t entry);

void qemu_continue(qemu_conn_t *conn);

inst_t qemu_getinst(qemu_conn_t *conn, uint32_t pc);

bool qemu_setinst(qemu_conn_t *conn, uint32_t pc, inst_t *inst);

uint64_t qemu_getmem(qemu_conn_t *conn, uint32_t addr);

void qemu_getcsrs(qemu_conn_t *conn, qemu_regs_t *r);

void qemu_getfprs(qemu_conn_t *conn, qemu_regs_t *r);

bool qemu_setcsr(qemu_conn_t *conn, int csr_num, uint32_t *data);

void qemu_init(qemu_conn_t *conn);

#endif
