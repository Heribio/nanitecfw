@ Track Artists / Playlists: mod23 list refill FUN_03079ef6 "bl FUN_03079418" -> pl_count
@ (playlists_50_mod23_setup.S), which runs artist_count (track_artists_50_mod23_setup.S).
@ patch 23 03079ef8
#include "fw.inc"
    .equ    pl_count, 0x03079e80
    fbl     pl_count
