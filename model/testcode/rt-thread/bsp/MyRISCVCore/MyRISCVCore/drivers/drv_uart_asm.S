	.global send_char
send_char:
    csrw 0x800, a0
    ret

    .global rev_char
rev_char:
    csrr a0, 0x800
    ret