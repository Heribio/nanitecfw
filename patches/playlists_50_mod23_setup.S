@ Playlists: mod23 media browser (window 2), opened by the Media Library "Playlists"
@ entry with MusicTypeSelID 4 (Albums) and title 0x83 (library_menu_40).
@
@ pl_setup: level setup (called through here from window init, see
@ recent_albums_51_mod23_call.S). Runs artist_setup (stock setup + Recent Albums +
@ Artists), then for title 0x83 points the song list and the album level's groups at the
@ tables the CFW blob writes at refresh (SEC_PL_SONGS / SEC_PL_GROUPS: the playlists'
@ songs one after the other; per playlist {start, start, count, 0}).
@
@ pl_count: list refill gets the item count through here (see
@ track_artists_51_mod23_count_call.S). For title 0x83 at level 0 the count is u16[3]
@ of the first group entry (written by the blob); more than 64 means the tables were
@ never built: show an empty list.
@
@ Code cave: after artist_count in the unreferenced 0x03079d78..0x03079ef5.
@ patch 23 03079e40
#include "fw.inc"
    .equ    artist_setup, 0x03079de0
    .equ    artist_count, 0x03079e0a
    .equ    group_field,  0x0307a0d8    @ (table sector, index, which): which 4 = u16[3]
    .equ    TITLE,        0x83
    .equ    SEC_SONGS,    0x58200
    .equ    SEC_GROUPS,   0x58220
    .equ    PL_MAX,       64
pl_setup:
    push    {r3, lr}
    fbl     artist_setup
    ldrh    r0, [r4, #2]                @ window param: title
    cmp     r0, #TITLE
    bne     1f
    ldr     r1, =0x0300e808             @ level descriptor: +0 base, +0xc song list, +0x10 groups
    ldr     r0, [r1]
    ldr     r2, =SEC_SONGS
    add     r2, r0
    str     r2, [r1, #0x0c]
    ldr     r2, =SEC_GROUPS
    add     r0, r2
    str     r0, [r1, #0x10]
1:  pop     {r3, pc}
    .ltorg

    .org    0x40
pl_count:
    push    {r4, lr}
    fbl     artist_count
    ldr     r4, =0x0300e800             @ browser title string id
    ldrh    r1, [r4]
    cmp     r1, #TITLE
    bne     1f
    ldrh.w  r1, [r4, #0x246]            @ cursor 0x0300ea3c: [5] level
    cbnz    r1, 1f
    ldr     r0, [r4, #0x18]             @ level descriptor table[1]: groups
    movs    r1, #0
    movs    r2, #4
    fbl     group_field
    cmp     r0, #PL_MAX
    it      hi
    movhi   r0, #0
1:  pop     {r4, pc}
    .ltorg
