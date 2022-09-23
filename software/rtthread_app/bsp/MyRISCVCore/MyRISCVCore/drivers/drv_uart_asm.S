    .global send_char
send_char:
    csrw 0x810, a0
send_char_wait:
    csrr t0, 0x810
    srl t0, t0, 31
    bnez t0, send_char_wait
    ret

    .global rev_char
rev_char:
    csrr a0, 0x810
    ret