@ Recent Albums / Track Artists / Playlists: mod23 FUN_03079f1e "bl FUN_0307a144" ->
@ pl_setup (playlists_50_mod23_setup.S), which runs artist_setup, which runs recent_setup.
@ patch 23 03079f22
#include "fw.inc"
    .equ    pl_setup, 0x03079e40
    fbl     pl_setup
