INCLUDE "engine/16/macros.asm"

; Note: ID = 8-bit ID used in memory, etc.; index = true 16-bit index into tables
_GetMoveIndexFromID::
	___conversion_table_load wMoveIndexTable, MOVE_TABLE

_GetMoveIDFromIndex::
	___conversion_table_store wMoveIndexTable, MOVE_TABLE
	; fallthrough
MoveTableGarbageCollection:
	; must preserve de and rSVBK
	push de
	ldh a, [rSVBK]
	push af
	ld a, 1
	ldh [rSVBK], a
	FOR ___move, NUM_MOVES
		___conversion_bitmap_check_structs wPartyMon1Moves + ___move, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
		___conversion_bitmap_check_structs wBreedMon1Moves + ___move, wBreedMon2 - wBreedMon1, 2, .set_bit
		; may or may not be valid
		___conversion_bitmap_check_structs wOTPartyMon1Moves + ___move, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
		___conversion_bitmap_check_values .set_bit, wTempMonMoves + ___move, wContestMonMoves + ___move, \
		                                            wBattleMonMoves + ___move, wEnemyMonMoves + ___move, \
		                                            wPlayerUsedMoves + ___move
	endr
	ld a, [wNamedObjectIndex] ;or any of its aliases...
	call .set_bit
	; only valid sometimes
	___conversion_bitmap_check_values .set_bit, wCurPlayerMove, wCurEnemyMove, wPlayerSelectedMove, wLastPlayerMove, \
	                                            wLastEnemyMove, wLastPlayerCounterMove, wLastEnemyCounterMove, wPlayerTrappingMove, \
	                                            wEnemyTrappingMove, wPlayerMoveStructAnimation, wEnemyMoveStructAnimation, \
	                                            wPutativeTMHMMove, wEnemySelectedMove
	pop af
	ldh [rSVBK], a
	ldh a, [hSRAMBank]
	push af
	ld a, BANK(sBoxMons1A)
	call GetSRAMBank
	FOR ___move, NUM_MOVES
		___conversion_bitmap_check_structs sBoxMons1AMon1Moves + ___move, SAVEMON_STRUCT_LENGTH, MONDB_ENTRIES_A, .set_bit
	endr
	ld a, BANK(sBoxMons2A)
	call GetSRAMBank
	FOR ___move, NUM_MOVES
		___conversion_bitmap_check_structs sBoxMons2AMon1Moves + ___move, SAVEMON_STRUCT_LENGTH, MONDB_ENTRIES_A, .set_bit
	endr
	ld a, BANK(sBoxMons1B)
	call GetSRAMBank
	FOR ___move, NUM_MOVES
		___conversion_bitmap_check_structs sBoxMons1BMon1Moves + ___move, SAVEMON_STRUCT_LENGTH, MONDB_ENTRIES_B, .set_bit
	endr
	ld a, BANK(sBoxMons2B)
	call GetSRAMBank
	FOR ___move, NUM_MOVES
		___conversion_bitmap_check_structs sBoxMons2BMon1Moves + ___move, SAVEMON_STRUCT_LENGTH, MONDB_ENTRIES_B, .set_bit
	endr
	ld a, BANK(sBoxMons1C)
	call GetSRAMBank
	FOR ___move, NUM_MOVES
		___conversion_bitmap_check_structs sBoxMons1CMon1Moves + ___move, SAVEMON_STRUCT_LENGTH, MONDB_ENTRIES_C, .set_bit
	endr
	ld a, BANK(sBoxMons2C)
	call GetSRAMBank
	FOR ___move, NUM_MOVES
		___conversion_bitmap_check_structs sBoxMons2CMon1Moves + ___move, SAVEMON_STRUCT_LENGTH, MONDB_ENTRIES_C, .set_bit
	endr
	pop af
	call GetSRAMBank
	___conversion_bitmap_free_unused wMoveIndexTable, MOVE_TABLE
	pop de
	ret

.set_bit
	___conversion_bitmap_set MOVE_TABLE

_LockMoveID::
	___conversion_table_lock_ID wMoveIndexTable, MOVE_TABLE
	