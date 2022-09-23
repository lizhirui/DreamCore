import os

# toolchains options
ARCH='risc-v'
CPU='myriscvcore'
CROSS_TOOL='gcc'

# bsp lib config
BSP_LIBRARY_TYPE = None

if os.getenv('RTT_CC'):
    CROSS_TOOL = os.getenv('RTT_CC')

if CROSS_TOOL == 'gcc':
    PLATFORM  = 'gcc'
    EXEC_PATH = 'D:/Tools/Nuclei/gcc/bin'
else:
    print("CROSS_TOOL = {} not yet supported" % CROSS_TOOL)

# if os.getenv('RTT_EXEC_PATH'):
#     EXEC_PATH = os.getenv('RTT_EXEC_PATH')

BUILD = 'release'

# Fixed configurations below
build_ldscript = "linker.ld"
build_march = "rv32im"
build_mabi = "ilp32"
build_mcmodel = "medany"

build_core_options = " -march=%s -mabi=%s -mcmodel=%s " % (build_march, build_mabi, build_mcmodel)
extra_flags = build_core_options
extra_lflags = "{} -T {}".format(build_core_options, build_ldscript)

if PLATFORM == 'gcc':
    # toolchains
    PREFIX  = 'riscv-nuclei-elf-'
    CC      = PREFIX + 'gcc'
    CXX     = PREFIX + 'g++'
    AS      = PREFIX + 'gcc'
    AR      = PREFIX + 'ar'
    LINK    = PREFIX + 'gcc'
    GDB     = PREFIX + 'gdb'
    TARGET_EXT = 'elf'
    SIZE    = PREFIX + 'size'
    OBJDUMP = PREFIX + 'objdump'
    OBJCPY  = PREFIX + 'objcopy'

    CFLAGS  = ' -ffunction-sections -fdata-sections -fno-common'
    CFLAGS  += extra_flags
    AFLAGS  = CFLAGS
    LFLAGS  = ' --specs=nano.specs --specs=nosys.specs -nostartfiles -Wl,--gc-sections '
    LFLAGS  += ' -Wl,-cref,-Map=rtthread.map '
    #LFLAGS  += ' -u _isatty -u _write -u _sbrk -u _read -u _close -u _fstat -u _lseek '
    LFLAGS  += extra_lflags
    CPATH   = ''
    LPATH   = ''
    LIBS = ['stdc++']

    if BUILD == 'debug':
        CFLAGS += ' -O0 -Os -g'
        AFLAGS += ' -g'
    else:
        CFLAGS += ' -O2 -Os'

    CXXFLAGS = CFLAGS

DUMP_ACTION = OBJDUMP + ' -D -S $TARGET > rtthread.asm\n'
POST_ACTION = OBJCPY + ' -O binary $TARGET rtthread.bin\n' + SIZE + ' $TARGET \n'
POST_ACTION += OBJCPY + ' -O ihex rtthread.elf rtthread.hex\n'
