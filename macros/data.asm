; Value macros

DEF percent EQUS "* $ff / 100"

MACRO bcd2
	dn ((\1) / 1000) % 10, ((\1) / 100) % 10
	dn ((\1) / 10) % 10, (\1) % 10
ENDM

MACRO bcd3
	dn ((\1) / 100000) % 10, ((\1) / 10000) % 10
	dn ((\1) / 1000) % 10, ((\1) / 100) % 10
	dn ((\1) / 10) % 10, (\1) % 10
ENDM

; used in data/pokemon/base_stats/*.asm
MACRO tmhm
	; initialize bytes to 0
	FOR n, (NUM_TM_HM + 7) / 8
		DEF _tm{d:n} = 0
	ENDR
	; set bits of bytes
	REPT _NARG
		ASSERT FATAL, STRFIND("\1", " ") == -1, "Invalid move: \1"
		IF DEF(\1_TMNUM)
			DEF n = (\1_TMNUM - 1) / 8
			DEF i = (\1_TMNUM - 1) % 8
			DEF _tm{d:n} |= 1 << i
		ELSE
			FAIL "\1 is not a TM or HM move"
		ENDC
		SHIFT
	ENDR
	; output bytes
	FOR n, (NUM_TM_HM + 7) / 8
		db _tm{d:n}
	ENDR
ENDM


; Constant data (db, dw, dl) macros

MACRO dbw
	db \1
	dw \2
ENDM

MACRO dwb
	dw \1
	db \2
ENDM

MACRO dn ; nybbles
	REPT _NARG / 2
		db ((\1) << 4) | (\2)
		SHIFT 2
	ENDR
ENDM

MACRO dc ; "crumbs"
	REPT _NARG / 4
		db ((\1) << 6) | ((\2) << 4) | ((\3) << 2) | (\4)
		SHIFT 4
	ENDR
ENDM

MACRO bigdw ; big-endian word
	REPT _NARG
		db HIGH(\1), LOW(\1)
		SHIFT
	ENDR
ENDM

MACRO dba ; dbw bank, address
	REPT _NARG
		dbw BANK(\1), \1
		SHIFT
	ENDR
ENDM

MACRO dab ; dwb address, bank
	REPT _NARG
		dwb \1, BANK(\1)
		SHIFT
	ENDR
ENDM

MACRO dname
	IF _NARG == 2
		DEF n = \2
	ELSE
		DEF n = NAME_LENGTH - 1
	ENDC
	ASSERT STRFIND(\1, "@") == -1, "String terminator \"@\" in name: \1"
	ASSERT CHARLEN(\1) <= n, "Name longer than {d:n} characters: \1"
	db \1
	ds n - CHARLEN(\1), "@"
ENDM

MACRO with_each ; with_each FOO, BAR, "DEF BASE_? = 42"
	for _element, 1, _NARG ; iterates with FOO and BAR
		redef _eval_buffer EQUS STRRPL(\<_NARG>, "?", "\<_element>") ; redef _eval_buffer EQUS STRRPL("DEF BASE_? = 42", "?", "FOO") ; redef _eval_buffer EQUS STRRPL("DEF BASE_? = 42", "?", "BAR")
		{_eval_buffer} ; DEF BASE_FOO = 42 ; DEF BASE_BAR = 42
	endr
ENDM

DEF with_each_dv_stat EQUS "with_each ATK, DEF, SPD, SPC,"
DEF with_each_stat EQUS "with_each HP, ATK, DEF, SPD, SPC,"
DEF with_each_stat_all EQUS "with_each ALL, HP, ATK, DEF, SPD, SPC,"
