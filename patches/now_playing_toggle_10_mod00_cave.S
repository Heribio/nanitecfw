@ Now Playing: album / artist, helpers for mod27 (second line of the view).
@ settings.txt "now_playing_album=1" (written to the DB at refresh by the blob,
@ SEC_SETTINGS = 0x58240: u32 magic, u32 value) selects the album. Lives in an
@ unreferenced zero area of resident mod00 (0x03073ed4, 720 bytes). The state byte
@ at 0x03073f00 caches the setting: 0 = read the sector, 1 = artist, 2 = album
@ (the refresh sets it back to 0).
@ Tag buffer 0x030398c8: +0x25c album, +0x15e artist.
@ patch 0 03073f10
#include "fw.inc"
    .equ    np_state, 0x03073f00
    .equ    db_base,  0x0300d148
    .equ    fw_read,  0x0306b36c        @ (dev, byte address, length, buffer)
    .equ    np_off_abs, 0x03073f10
    .equ    SEC,      0x58240
    .equ    MAGIC,    0x5e771a65
np_off:                                 @ r1 = offset of the shown field; keeps all else
    push    {r0, r2, r3, r12, lr}
    sub     sp, #12
    ldr     r2, =np_state
    ldrb    r1, [r2]
    cbnz    r1, 2f
    ldr     r0, =db_base
    ldr     r0, [r0]
    ldr     r1, =SEC
    add     r0, r1
    lsls    r1, r0, #9
    ldr     r0, =0x30001
    movs    r2, #8
    mov     r3, sp
    fbl     fw_read
    movs    r1, #1
    ldr     r0, [sp]
    ldr     r3, =MAGIC
    cmp     r0, r3
    bne     3f
    ldr     r0, [sp, #4]
    cmp     r0, #1
    bne     3f
    movs    r1, #2
3:  ldr     r2, =np_state
    strb    r1, [r2]
2:  cmp     r1, #2
    ite     eq
    movweq  r1, #0x25c
    movwne  r1, #0x15e
    add     sp, #12
    pop     {r0, r2, r3, r12, lr}
    bx      lr
    .ltorg
    .org    0x80
np_ldrh:                                @ ldrh.w r1, [r0, #off]
    push    {lr}
    fbl     np_off_abs
    ldrh    r1, [r0, r1]
    pop     {pc}
    .org    0x90
np_add:                                 @ add.w r1, r0, #off
    push    {lr}
    fbl     np_off_abs
    add     r1, r0
    pop     {pc}
