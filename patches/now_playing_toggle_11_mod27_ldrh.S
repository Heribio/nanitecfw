@ Now Playing second line: "ldrh.w r1, [r0, #0x15e]" -> np_ldrh
@ (now_playing_toggle_10_mod00_cave.S).
@ patch 27 0307adf6
#include "fw.inc"
    .equ    np_ldrh, 0x03073f90
    fbl     np_ldrh
