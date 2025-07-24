DEF DATA_SIZE EQU (NUM_POKEMON + 7) / 8

; this function temporarily makes the starters (and Ivysaur) owned
; so that the full Pokedex information gets displayed in Oak's lab
StarterDex:
	ld a, $ff
	ld hl, wPokedexOwned
	ld bc, DATA_SIZE
	call FillMemory
	predef ShowPokedexData
	xor a
	ld hl, wPokedexOwned
	ld bc, DATA_SIZE
	jp FillMemory

PURGE DATA_SIZE
