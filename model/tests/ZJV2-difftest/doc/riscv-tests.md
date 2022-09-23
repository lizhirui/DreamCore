Prepare Test Cases from [riscv-tests](https://github.com/riscv-software-src/riscv-tests)
========================================================================================

First, get source code and compile.

```bash
$ git clone https://github.com/riscv-software-src/riscv-tests
$ cd riscv-tests
$ git submodule update --init --recursive
$ make
```



## Collect Desired Test Cases

```bash
$ mkdir -p cases/riscv-tests
$ find ../riscv-tests/isa -maxdepth 1 -name "rv64mi-*" ! -name "*.dump" -type f -exec cp {} ./cases/riscv-tests/ \;
$ find ../riscv-tests/isa -maxdepth 1 -name "rv64si-*" ! -name "*.dump" -type f -exec cp {} ./cases/riscv-tests/ \;
$ find ../riscv-tests/isa -maxdepth 1 -name "rv64ui-*" ! -name "*.dump" -type f -exec cp {} ./cases/riscv-tests/ \;
$ find ../riscv-tests/isa -maxdepth 1 -name "rv64ud-*" ! -name "*.dump" -type f -exec cp {} ./cases/riscv-tests/ \;
$ find ../riscv-tests/isa -maxdepth 1 -name "rv64ua-*" ! -name "*.dump" -type f -exec cp {} ./cases/riscv-tests/ \;
$ find ../riscv-tests/isa -maxdepth 1 -name "rv64uc-*" ! -name "*.dump" -type f -exec cp {} ./cases/riscv-tests/ \;
```
