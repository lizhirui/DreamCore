RT-Thread RV64 Port
===================

## Prerequiste

[qemu-system-riscv64](../README.md#qemu-system-riscv64)

## Compile RT-Thread 

```bash
$ sudo apt install scons g++-riscv64-linux-gnu binutils-riscv64-linux-gnu
$ git clone https://github.com/OSCPU/rt-thread.git
$ cd rt-thread/bsp/qemu-riscv-virt64
$ scons
```

## Run

```bash
$ ./qemu-nographic.sh
```


## Reference

https://github.com/OSCPU/ysyx/blob/main/events/2021-08-18_RT-Thread_Porting/RT-thread%E7%A7%BB%E6%A4%8D.pdf