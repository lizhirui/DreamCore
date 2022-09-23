#include <signal.h>
#include <stdlib.h>
#include <sys/prctl.h>
#include <unistd.h>
#include <time.h>
#include <fstream>
#include <iostream>

#include "qemu.h"
#include "dut.h"
#include "isa.h"

int total_instructions;

#define WAVE_TRACE
// #define IPC_TRACE

// dump qemu registers
void print_qemu_registers(qemu_regs_t *regs, bool wpc) {
    if (wpc) eprintf("$pc:  0x%08x\n", regs->pc);
    eprintf("$zero:0x%08x  $ra:0x%08x  $sp: 0x%08x  $gp: 0x%08x\n",
            regs->gpr[0], regs->gpr[1], regs->gpr[2], regs->gpr[3]);
    eprintf("$tp:  0x%08x  $t0:0x%08x  $t1: 0x%08x  $t2: 0x%08x\n",
            regs->gpr[4], regs->gpr[5], regs->gpr[6], regs->gpr[7]);
    eprintf("$fp:  0x%08x  $s1:0x%08x  $a0: 0x%08x  $a1: 0x%08x\n",
            regs->gpr[8], regs->gpr[9], regs->gpr[10], regs->gpr[11]);
    eprintf("$a2:  0x%08x  $a3:0x%08x  $a4: 0x%08x  $a5: 0x%08x\n",
            regs->gpr[12], regs->gpr[13], regs->gpr[14], regs->gpr[15]);
    eprintf("$a6:  0x%08x  $a7:0x%08x  $s2: 0x%08x  $s3: 0x%08x\n",
            regs->gpr[16], regs->gpr[17], regs->gpr[18], regs->gpr[19]);
    eprintf("$s4:  0x%08x  $s5:0x%08x  $s6: 0x%08x  $s7: 0x%08x\n",
            regs->gpr[20], regs->gpr[21], regs->gpr[22], regs->gpr[23]);
    eprintf("$s8:  0x%08x  $s9:0x%08x  $s10:0x%08x  $s11:0x%08x\n",
            regs->gpr[24], regs->gpr[25], regs->gpr[26], regs->gpr[27]);
    eprintf("$t3:  0x%08x  $t4:0x%08x  $t5: 0x%08x  $t6: 0x%08x\n",
            regs->gpr[28], regs->gpr[29], regs->gpr[30], regs->gpr[31]);
    eprintf("$ft0:  0x%08x  $ft1:0x%08x  $ft2: 0x%08x  $ft3: 0x%08x\n",
        regs->fpr[33], regs->fpr[34], regs->fpr[35], regs->fpr[36]);
    eprintf("$ft4:  0x%08x  $ft5:0x%08x  $ft6: 0x%08x  $ft7: 0x%08x\n",
        regs->fpr[37], regs->fpr[38], regs->fpr[39], regs->fpr[40]);
    eprintf("$fs0:  0x%08x  $fs1:0x%08x  $fa0: 0x%08x  $fa1: 0x%08x\n",
        regs->fpr[41], regs->fpr[42], regs->fpr[43], regs->fpr[44]);
    eprintf("$fa2:  0x%08x  $fa3:0x%08x  $fa4: 0x%08x  $fa5: 0x%08x\n",
        regs->fpr[45], regs->fpr[46], regs->fpr[47], regs->fpr[48]);
    eprintf("$fa6:  0x%08x  $fa7:0x%08x  $fs2: 0x%08x  $fs3: 0x%08x\n",
        regs->fpr[49], regs->fpr[50], regs->fpr[51], regs->fpr[52]);
    eprintf("$fs4:  0x%08x  $fs5:0x%08x  $fs6: 0x%08x  $fs7: 0x%08x\n",
        regs->fpr[53], regs->fpr[54], regs->fpr[55], regs->fpr[56]);
    eprintf("$fs8:  0x%08x  $fs9:0x%08x  $fs10: 0x%08x  $fs11: 0x%08x\n",
        regs->fpr[57], regs->fpr[58], regs->fpr[59], regs->fpr[60]);
    eprintf("$ft8:  0x%08x  $ft9:0x%08x  $ft10: 0x%08x  $ft11: 0x%08x\n",
        regs->fpr[61], regs->fpr[62], regs->fpr[63], regs->fpr[64]);
    eprintf("$mstatus: 0x%08x  $medeleg: 0x%08x  $mideleg: 0x%08x\n",
            regs->array[65], regs->array[66], regs->array[67]);
    eprintf("$mie:     0x%08x  $mip:     0x%08x  $mtvec:   0x%08x  $mscratch: 0x%08x\n",
            regs->array[68], regs->array[69], regs->array[70], regs->array[71]);
    eprintf("$mepc:    0x%08x  $mcause:  0x%08x  $mtval:   0x%08x\n",
            regs->array[72], regs->array[73], regs->array[74]);
    eprintf("$sstatus: 0x%08x  $sie:     0x%08x  $stvec:   0x%08x  $sscratch: 0x%08x\n",
            regs->array[75], regs->array[76], regs->array[77], regs->array[78]);
    eprintf("$sepc:    0x%08x  $scause:  0x%08x  $stval:   0x%08x  $sip:      0x%08x\n",
            regs->array[79], regs->array[80], regs->array[81], regs->array[82]);
}


void difftest_start_qemu(const char *path, int port, int ppid) {
    // install a parent death signal in the child
    int r = prctl(PR_SET_PDEATHSIG, SIGTERM);
    if (r == -1) { panic("prctl error"); }

    if (getppid() != ppid) { panic("parent has died"); }

    close(0); // close STDIN

    qemu_start(path, port);    // start qemu in single-step mode and stub gdb
}


// 比较寄存器，包括 GPRs 和 CSRs
bool difftest_regs (qemu_regs_t *regs, qemu_regs_t *dut_regs) {
    const char *alias[regs_count] = {
        "zero", "ra", "sp", "gp",
        "tp", "t0", "t1", "t2",
        "fp", "s1", "a0", "a1",
        "a2", "a3", "a4", "a5",
        "a6", "a7", "s2", "s3",
        "s4", "s5", "s6", "s7",
        "s8", "s9", "s10", "s11",
        "t3", "t4", "t5", "t6", "pc",
        "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",
        "fs0", "fs1", "fa0", "fa1", "fa2", "fa3", "fa4", "fa5",
        "fa6", "fa7", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7",
        "fs8", "fs9", "fs10", "fs11", "ft8", "ft9", "ft10", "ft11",
        "mstatus", "medeleg", "mideleg", "mie", 
        "mip", "mtvec", "mscratch", "mepc", 
        "mcause", "mtval", "sstatus", "sie", "stvec", 
        "sscratch", "sepc", "scause", "stval", "sip"
    };

    static uint32_t last_3_qpcs[3] = {0};
    for (int i = 0; i <= 32; i++) {
        // GPR
        if (regs->gpr[i] != dut_regs->gpr[i]) {
            sleep(0.5);
            for (int j = 0; j < 3; j++) {
                printf("QEMU PC at [0x%08x]\n", last_3_qpcs[j]);
            }
            printf("\x1B[31mError in $%s, QEMU %x, ZJV2 %x\x1B[37m\n", 
                alias[i], regs->gpr[i], dut_regs->gpr[i]);
            return false;
        }
        // FPR
        /*if (regs->fpr[i + 33] != dut_regs->fpr[i + 33]) {
            sleep(0.5);
            for (int j = 0; j < 3; j++) {
                printf("QEMU PC at [0x%08x]\n", last_3_qpcs[j]);
            }
            printf("\x1B[31mError in $%s, QEMU %lx, ZJV2 %lx\x1B[37m\n", 
                alias[33 + i], regs->fpr[i + 33], dut_regs->fpr[i + 33]);
            return false;
        }*/
    }

    // CSR
    for (int i = 65; i < regs_count; i++) {
        if (i == 65 || i == 75 || i == 66 || i == 67 || i == 68 || i == 69) { continue; }   // skip `mstatus` and `sstatus`

        //skip s mode regs
        if(i >= 75)
        {
            break;
        }

        if (regs->array[i] != dut_regs->array[i]) {
            sleep(0.5);
            for (int j = 0; j < 3; j++) {
                printf("QEMU PC at [0x%08x]\n", last_3_qpcs[j]);
            }
            printf("\x1B[31mError in $%s, QEMU %x, ZJV2 %x\x1B[37m\n", 
                alias[i], regs->array[i], dut_regs->array[i]);
            return false;
        }
    }

    last_3_qpcs[0] = last_3_qpcs[1];
    last_3_qpcs[1] = last_3_qpcs[2];
    last_3_qpcs[2] = regs->pc - 4;
    return true;
}

bool check_and_close_difftest(qemu_conn_t *conn) 
{
    if(dut_checkfinish()) 
    {
        printf("difftest pass!\n");

#ifdef IPC_TRACE
        // print information
        printf("Total Instructions: %d\n", total_instructions);
        printf("Total Cycles: %lld\n", dut->io_difftest_counter);
        printf("IPC: %lf\n", double(total_instructions) / dut->io_difftest_counter);
        printf("Both Cache Stall Cycles: %lld\n", dut->io_difftest_common);
        printf("\tDcache Stall Cycles: %lld\n", dut->io_difftest_dstall);
        printf("\tIcache Stall Cycles: %lld\n", dut->io_difftest_istall);
        printf("MDU Stall Cycles: %lld\n", dut->io_difftest_mduStall);
#endif

        qemu_disconnect(conn);
        return true;
    }
    return false;
}

int difftest_body(const char *path, int port) {
    int result = 0;
    qemu_regs_t regs = {0};
    qemu_regs_t dut_regs = {0};

    int bubble_count = 0;

    qemu_conn_t *conn = qemu_connect(port);
    qemu_init(conn);                            // 初始化 GDB，发送 qXfer 命令注册 features 

    extern uint32_t elf_entry;
    regs.pc = elf_entry;
    qemu_break(conn, elf_entry);
    qemu_continue(conn);
    qemu_remove_breakpoint(conn, elf_entry);
    qemu_setregs(conn, &regs);
    qemu_getregs(conn, &regs);

    // set up device under test

    try
    {
        dut_connect();
        dut_reset();

        std::ifstream binfile("testfile.bin", std::ios::in | std::ios::binary | std::ios::ate);

        if(!binfile || !binfile.is_open())
        {
            std::cout << "testfile.bin Open Failed!" << std::endl;
            goto exit;
        }

        auto n = binfile.tellg();
        binfile.seekg(0, std::ios::beg);
        auto buf = new char[n];
        binfile.read(buf, n);
        std::cout << "read " << n << " bytes!" << std::endl;
        dut_load(elf_entry, buf, n);
        delete[] buf;

        while(1) 
        {
            dut_step(1);

            if(check_and_close_difftest(conn))
            {
                return 0;
            }
                
            bubble_count = 0;

            auto commit_num = dut_commit();

            while(commit_num == 0) 
            {
                dut_step(1);

                if(check_and_close_difftest(conn))
                {
                    return 0;
                }

                bubble_count++;
                // printf("dut bubble count: %d\n", bubble_count);

                if(bubble_count > 200) 
                {
                    printf("Too many bubbles.\n");
                    break;
                }

                commit_num = dut_commit();
            }

            
            total_instructions += commit_num;
            //printf("commit_num = %d\n", commit_num);

            for(int i = 0; i < commit_num; i++) 
            {
                // get current instruction
                inst_t inst = qemu_getinst(conn, regs.pc);
                //printf("qemu single step\n");
                qemu_single_step(conn);
                qemu_getregs(conn, &regs);
                sleep(0.25);

    #ifdef TRACE
                printf("\nQEMU\n");
                print_qemu_registers(&regs, true);
                printf("\nDUT\n");
                print_qemu_registers(&dut_regs, true);
                printf("==============\n");
    #endif
            }

            qemu_getregs(conn, &regs);
            dut_getregs(&dut_regs);
            //printf("QEMU = 0x%08x, DUT = 0x%08x\n", regs.pc, dut_regs.pc);

            if(!difftest_regs(&regs, &dut_regs)) 
            {
                sleep(1);
                printf("\nQEMU\n");
                print_qemu_registers(&regs, true);
                printf("\nDUT\n");
                print_qemu_registers(&dut_regs, true);
                printf("\n");
                result = 1;
                break;
            }
        }
    }
    catch(const std::exception &ex)
    {
        std::cout << ex.what() << std::endl;
    }

exit:
    qemu_disconnect(conn);
    dut_disconnect();
    return result;
}

int difftest(const char *path) 
{
    int port = 1234;
    int ppid = getpid();
    int result = 0;

    printf("Welcome to ZJV2 differential test with QEMU!\n");

    if(fork() != 0) 
    {    // child process
        result = difftest_body(path, port);
    } 
    else 
    {              // parent process
        difftest_start_qemu(path, port, ppid);
    }

    return result;
}
