OUTPUT_ARCH(riscv)
ENTRY(_start)

BASE_ADDRESS = 0x80020000;
STACK_SIZE = 1024;

SECTIONS
{
    . = BASE_ADDRESS;
    start = .;

    .text :
    {
        stext = .;
        *(.text.entry)
        *(.text .text.*)
        etext = .;
    }

    . = ALIGN(8);

    .rodata :
    {
        srodata = .;
        *(.rodata .rodata.* .rodata*)
        *(.srodata .srodata.* .srodata*)
        erodata = .;
    }

    . = ALIGN(8);

    . = ALIGN(8);

    .eh_frame_hdr : 
    { 
         *(.eh_frame_hdr) 
         *(.eh_frame_entry)
    }

    .eh_frame : ONLY_IF_RO { KEEP (*(.eh_frame)) }

    . = ALIGN(8);

    .data :
    {
        sdata = .;
        *(.data .data.*)
        . = ALIGN(8);
        PROVIDE( __global_pointer$ = . + 0x800 );
        *(.sdata .sdata.*)
        edata = .;
    }
    . = ALIGN(8);

    __bss_start = .;

    .bss :
    {
        sbss = .;
        *(.sbss .sbss.*)
        *(.dynsbss)
        *(.scommon)
        *(.bss .bss.*)
        *(.dynbss)
        *(COMMON)
        . = ALIGN(4K);
        PROVIDE(__stack_start = .);
        . += STACK_SIZE;
        . = ALIGN(8);
        PROVIDE(__stack_default = .);
        ebss = .;
        __bss_end = .;
        . = ALIGN(4K);
        _heap_start = .;
    }

    PROVIDE(end = .);
}