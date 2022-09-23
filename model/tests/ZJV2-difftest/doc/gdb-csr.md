Read CSRs from RISC-V GDB
=========================

从 GDB 的 remote serial protocol 中并不能直接读取 CSR 的值。为了能够使得 GDB 能够读取 CSR，需要在初始化时使用 `qXfer` 命令选取对应的 CSR 描述文件 (xml 格式)。

在目前版本的 ZJV2-difftest 中已经能够顺利读取 CSR。

## 初始化命令

在 `src/qemu.c` 中定义了初始化命令：

```c
const char* init_cmds[] = {
    "qXfer:features:read:target.xml:0,ffb",             // target.xml
    "qXfer:features:read:riscv-64bit-cpu.xml:0,ffb",    // riscv-64bit-cpu.xml
    "qXfer:features:read:riscv-64bit-fpu.xml:0,ffb",    // riscv-64bit-fpu.xml
    "qXfer:features:read:riscv-64bit-fpu.xml:7fd,ffb",
    "qXfer:features:read:riscv-64bit-virtual.xml:0,ffb",// riscv-64bit-virtual.xml
    "qXfer:features:read:riscv-csr.xml:0,ffb",          // riscv-csr.xml
    "qXfer:features:read:riscv-csr.xml:7fd,ffb",        
    "qXfer:features:read:riscv-csr.xml:ffa,ffb",      
    "qXfer:features:read:riscv-csr.xml:17f7,ffb"
};
```

将这些命令发送到 GDB Server 中就可以成功完成初始化，并且能够使用 `p` 命令来读取 CSR 的值。然而 `p` 命令的参数并不是直接 CSR 的编号，而是映射的值。