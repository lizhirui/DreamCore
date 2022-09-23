TOOLCHAIN=riscv64-unknown-elf-

src_dir = .

RISCV_GCC_OPTS ?= -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -g -O3 -ffast-math -fno-common -fno-builtin-printf -funroll-all-loops -march=rv32im -mabi=ilp32
RISCV_LINK_OPTS ?= -static -nostartfiles -lm -lgcc -T$(src_dir)/link.ld

all: dhrystone_app.elf
	$(TOOLCHAIN)objcopy -O binary dhrystone_app.elf dhrystone_app.bin
	$(TOOLCHAIN)objcopy -I binary -O ihex dhrystone_app.bin dhrystone_app.hex
	$(TOOLCHAIN)objdump --disassemble-all --disassemble-zeroes dhrystone_app.elf > dhrystone_app.dump

dhrystone_app.elf: printf.c dhrystone_main.c dhrystone.c dhrystone.h printf.h startup.S
	$(TOOLCHAIN)gcc -Wl,-Map=output.map -g -O3 -funroll-all-loops -I$(src_dir) -mabi=ilp32 -march=rv32im -o $@ startup.S $(src_dir)/*.c $(RISCV_LINK_OPTS)


dasm: dhrystone_app.elf
	$(TOOLCHAIN)objdump -d $<

GDB_UPLOAD_ARGS ?= --batch
GDB_UPLOAD_CMDS += -ex "set remotetimeout 240"
GDB_UPLOAD_CMDS += -ex "target extended-remote localhost:3333"
GDB_UPLOAD_CMDS += -ex "monitor reset halt"
GDB_UPLOAD_CMDS += -ex "monitor flash protect 0 64 last off"
GDB_UPLOAD_CMDS += -ex "load"


upload: build/dhrystone_app
	$(TOOLCHAIN)gdb $< $(GDB_UPLOAD_ARGS) $(GDB_UPLOAD_CMDS) -ex "monitor resume" -ex "quit"

debug: build/dhrystone_app
	$(TOOLCHAIN)gdb $< -tui $(GDB_UPLOAD_CMDS)

clean:
	rm build/*
