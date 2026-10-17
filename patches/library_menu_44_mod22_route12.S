@ Media Library menu: the dispatcher's last case ("cmp r4, #100; beq ...; b.w done")
@ ends every type it does not know in "b.w done"; send those to library_menu
@ (library_menu_40_mod22_dispatch.S), which handles 12 (Playlists) and leaves the
@ rest to the same exit.
@ patch 22 03079650
#include "fw.inc"
    .equ    library_menu, 0x03079490
    fb library_menu
