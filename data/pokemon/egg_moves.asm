SECTION "Egg Move Pointers", ROMX

EggMovePointers::
	indirect_table 2, 1
	indirect_entries JOHTO_POKEMON - 1, EggMovePointers1
	indirect_entries NUM_EXT_POKEMON, EggMovePointers2
	
INCLUDE "data/pokemon/egg_moves_johto.asm"
INCLUDE "data/pokemon/egg_moves_kanto.asm"
