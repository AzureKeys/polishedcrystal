MACRO evo_data
	db \1 ; evolution type
	if \1 == EVOLVE_PARTY
		dp \2, PLAIN_FORM ; parameter
	else
		db \2 ; parameter
	endc
	if \1 == EVOLVE_STAT || \1 == EVOLVE_HOLDING
		db \3 ; ATK_*_DEF | time of day
		shift
	endc
	if _NARG > 3
		dp \3, \4
	else
		dp \3, PLAIN_FORM
	endc
ENDM


SECTION "Evolutions and Attacks Pointers", ROMX

INCLUDE "data/pokemon/evolution_moves.asm"

EvosAttacksPointers::
	indirect_table 2, 1
	indirect_entries JOHTO_POKEMON -1, EvosAttacksPointers1
	indirect_entries NUM_EXT_POKEMON, EvosAttacksPointers2
	indirect_table_end
	
INCLUDE "data/pokemon/evos_attacks_kanto.asm"
INCLUDE "data/pokemon/evos_attacks_johto.asm"

EggEvosAttacks::
	db 0 ; no more evolutions
	db 0 ; no more level-up moves
