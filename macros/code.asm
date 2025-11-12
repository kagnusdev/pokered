; Syntactic sugar macros

MACRO? lb ; r, hi, lo
	ld \1, ((\2) & $ff) << 8 + ((\3) & $ff)
ENDM

MACRO? ldpal
	ld \1, \2 << 6 | \3 << 4 | \4 << 2 | \5
ENDM

; Design patterns

MACRO dict
	IF \1 == 0
		and a
	ELSE
		cp \1
	ENDC
	jp z, \2
ENDM

; Avoids dec a, then AddNTimes
; Usage: add_n_times_1_based DataPointer, DATA_SIZE
MACRO add_n_times_1_based
	ld hl, (\1) - (\2)
	ld bc, \2
	call AddNTimes
ENDM
