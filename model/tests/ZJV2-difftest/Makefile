TARGET_DIR  := $(CURDIR)/build
INCLUDE_DIR := $(CURDIR)/include
SRC_DIR     := $(CURDIR)/src
OBJ_DIR     := $(TARGET_DIR)/obj
VSRC_DIR    := $(CURDIR)/verilog

CROSS_COMPILE := riscv64-unknown-elf-

SRC         := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*.cpp)
OBJ         := $(patsubst $(SRC_DIR)/%.c $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC))

CC          := gcc
CFLAGS      := -I$(INCLUDE_DIR) -O3

CASES_DIR	:= $(CURDIR)/cases

all: $(TARGET_DIR)/emulator

$(TARGET_DIR)/emulator: $(SRC)
	mkdir -p build
	g++ -O2 -g src/main.cpp src/dut.cpp src/difftest.cpp src/qemu.c src/isa.c src/gdb_proto.c src/gdb_bridge.c -Iinclude -I./src -lpthread -o build/emulator

prepare:
	mkdir -p build
	cp -v $(CASES_DIR)/$(ELF) $(TARGET_DIR)/testfile.elf
	$(CROSS_COMPILE)objdump -d $(TARGET_DIR)/testfile.elf > $(TARGET_DIR)/testfile.dump
	$(CROSS_COMPILE)objcopy -O binary $(TARGET_DIR)/testfile.elf $(TARGET_DIR)/testfile.bin
	$(CROSS_COMPILE)objdump -d $(TARGET_DIR)/testfile.elf > $(TARGET_DIR)/testfile.dump
	od -t x1 -An -w1 -v $(TARGET_DIR)/testfile.bin > $(TARGET_DIR)/testfile.hex


clean:
	-@rm -rf $(TARGET_DIR)
