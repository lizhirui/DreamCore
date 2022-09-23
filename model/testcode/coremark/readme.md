# 编译CoreMark

1. 进入coremark目录，运行：

   ```tcl
   make build/coremark
   ```

# 运行CoreMark

1. 下载比特流到FPGA。

2. 连接JTAG到主机。

3. 进入coremark目录，运行：

   ```tcl
   sudo openocd -f kc705_swerv_eh1.cfg
   ```

4. 进入coremark/build目录，运行：

   ```tcl
   riscv64-unknown-elf- coremark
   # > ...
   extended-remote localhost:3333
   # > ...
   load
   ```

