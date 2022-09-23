#ifndef DEBUG_H
#define DEBUG_H

#include <assert.h>
#include <setjmp.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>


/* kernel-debug */
extern void check_kernel_image(const char *image);
extern void dump_syscall(
    uint32_t v0, uint32_t a0, uint32_t a1, uint32_t a2);

/* nemu-diff */
void init_nemu_dylib();
void diff_with_nemu();

extern void instr_enqueue_pc(uint32_t pc);
extern void instr_enqueue_instr(uint32_t pc);
extern void kdbg_print_instr_queue(void);
extern void kdbg_print_registers(void);

extern void nemu_epilogue();

/* APIs from iq.c */
extern uint32_t get_current_pc();
extern uint32_t get_current_instr();

/* frame recorder */
void kdbg_print_frames();
void kdbg_print_backtraces();
void frames_enqueue_call(uint32_t pc, uint32_t target);
void frames_enqueue_ret(uint32_t pc, uint32_t target);

#define eprintf(...) fprintf(stderr, ##__VA_ARGS__)

#define Abort() exit(-1)

// we are properly doing diff testing in batch_mode, so do
// not Log in batch_mode
#define Log(format, ...)                          \
  do {                                            \
    eprintf("nemu: %s:%d: %s: " format, __FILE__, \
        __LINE__, __func__, ##__VA_ARGS__);       \
  } while (0)

#define Assert(cond, fmt, ...)                             \
  do {                                                     \
    if (!(cond)) {                                         \
      Log("Assertion `%s' failed: \e[1;31m" fmt "\e[0m\n", \
          #cond, ##__VA_ARGS__);                           \
      Abort();                                             \
    }                                                      \
  } while (0)

#define panic(fmt, ...)                               \
  do {                                                \
    eprintf("nemu: %s:%d: %s: panic: \e[1;31m" fmt    \
            "\e[0m\n",                                \
        __FILE__, __LINE__, __func__, ##__VA_ARGS__); \
    Abort();                                          \
  } while (0)

#define TODO() panic("please implement me")

#define CPUAbort()                      \
  do {                                  \
    extern jmp_buf gdb_mode_top_caller; \
    if (work_mode == MODE_GDB) {        \
      longjmp(gdb_mode_top_caller, 1);  \
    } else {                            \
      abort();                          \
    }                                   \
  } while (0)

#define CPUAssert(cond, fmt, ...)                          \
  do {                                                     \
    if (!(cond)) {                                         \
      nemu_epilogue();                                     \
      eprintf("nemu: %s:%d: %s: Assertion `%s' failed\n",  \
          __FILE__, __LINE__, __func__, #cond);            \
      eprintf("\e[1;31mCPUAssert message: " fmt "\e[0m\n", \
          ##__VA_ARGS__);                                  \
      CPUAbort();                                          \
    }                                                      \
  } while (0)

#endif
