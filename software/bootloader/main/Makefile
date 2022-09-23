.PHONY: all code dump qemu run qemu-dbg dbg gdb

all_elf := test.elf
bin := test.bin

default: qemu

all: dump

code:
	scons

dump: build
	scons --dump

build: code

clean:
	scons -c

qemu: build
	qemu-system-riscv64 -nographic -machine virt -m 256M -all $(bin)

qemu-dbg: build
	qemu-system-riscv64 -s -S -nographic -machine virt -m 256M -all $(bin)

run: qemu

dbg: qemu-dbg

gdb:
	gdbgui -p 10002 -r $(all_elf) -g "riscv64-unknown-elf-gdb --command=gdbcommand.txt"
