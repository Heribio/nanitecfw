@ Now Playing second line: "add.w r1, r0, #0x15e" -> np_add
@ (now_playing_toggle_10_mod00_cave.S).
@ patch 27 0307ae00
#include "fw.inc"
    .equ    np_add, 0x03073fa0
    fbl     np_add
