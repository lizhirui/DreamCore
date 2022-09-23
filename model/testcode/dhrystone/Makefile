TOOLCHAIN=riscv64-unknown-elf-

src_dir = .

RISCV_GCC_OPTS ?= -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -g -O3 -ffast-math -fno-common -fno-builtin-printf -funroll-all-loops -march=rv32im -mabi=ilp32
RISCV_LINK_OPTS ?= -static -nostartfiles -lm -lgcc -T$(src_dir)/link.ld

all: dhrystone.elf
	$(TOOLCHAIN)objcopy -O binary dhrystone.elf dhrystone.bin
	$(TOOLCHAIN)objcopy -I binary -O ihex dhrystone.bin dhrystone.hex
	$(TOOLCHAIN)objdump --disassemble-all --disassemble-zeroes dhrystone.elf > dhrystone.dump

dhrystone.elf: printf.c dhrystone_main.c dhrystone.c dhrystone.h printf.h startup.S
	$(TOOLCHAIN)gcc -Wl,-Map=output.map -g -O3 -funroll-all-loops -I$(src_dir) -mabi=ilp32 -march=rv32im -o $@ startup.S $(src_dir)/*.c $(RISCV_LINK_OPTS)

dasm: coremark.elf
	$(TOOLCHAIN)objdump -d $<

GDB_UPLOAD_ARGS ?= --batch
GDB_UPLOAD_CMDS += -ex "set remotetimeout 240"
GDB_UPLOAD_CMDS += -ex "target extended-remote localhost:3333"
GDB_UPLOAD_CMDS += -ex "monitor reset halt"
GDB_UPLOAD_CMDS += -ex "monitor flash protect 0 64 last off"
GDB_UPLOAD_CMDS += -ex "load"


upload: build/coremark
	$(TOOLCHAIN)gdb $< $(GDB_UPLOAD_ARGS) $(GDB_UPLOAD_CMDS) -ex "monitor resume" -ex "quit"

debug: build/coremark
	$(TOOLCHAIN)gdb $< -tui $(GDB_UPLOAD_CMDS)

clean:
	rm build/*
