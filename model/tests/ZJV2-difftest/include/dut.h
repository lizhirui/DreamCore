#ifndef DUT_H
#define DUT_H

#include <stdbool.h>
#include "qemu.h"

// TODO sync cycle and sync interrupt
void dut_connect();
void dut_disconnect();
void dut_reset();
int dut_commit();
void dut_load(uint32_t address, char *buffer, uint32_t size);
void dut_step(int cycle);
bool dut_checkfinish();
void dut_getregs(qemu_regs_t *regs);
void dut_write_counter(int value);

#endif
