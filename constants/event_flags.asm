; wEventFlags bit flags

	const_def


;; The first eight flags are reset upon reloading the map
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_4
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_5
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_6
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_7
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_8

if (const_value % 8) != 0
DEF const_value = const_value + 8 - (const_value % 8)
endc
DEF EVENT_TEMPORARY_UNTIL_MAP_RELOAD_FLAGS_END EQU const_value


;; The next flags are reset upon entering a new level (for e.g. trainers)
DEF EVENT_LEVEL_SCOPED_FLAGS_START EQU EVENT_TEMPORARY_UNTIL_MAP_RELOAD_FLAGS_END

	const EVENT_LEVEL_SCOPED_1
	const EVENT_LEVEL_SCOPED_2
	const EVENT_LEVEL_SCOPED_3
	const EVENT_LEVEL_SCOPED_4
	const EVENT_LEVEL_SCOPED_5
	const EVENT_LEVEL_SCOPED_6
	const EVENT_LEVEL_SCOPED_7
	const EVENT_LEVEL_SCOPED_8
	const EVENT_LEVEL_SCOPED_9
	const EVENT_LEVEL_SCOPED_10
	const EVENT_LEVEL_SCOPED_11
	const EVENT_LEVEL_SCOPED_12
	const EVENT_LEVEL_SCOPED_13
	const EVENT_LEVEL_SCOPED_14
	const EVENT_LEVEL_SCOPED_15
	const EVENT_LEVEL_SCOPED_16
	const EVENT_LEVEL_SCOPED_17
	const EVENT_LEVEL_SCOPED_18
	const EVENT_LEVEL_SCOPED_19
	const EVENT_LEVEL_SCOPED_20

if (const_value % 8) != 0
DEF const_value = const_value + 8 - (const_value % 8)
endc
DEF EVENT_LEVEL_SCOPED_FLAGS_END EQU const_value


;; The next flags are reset upon taking a step (for e.g. talker)
DEF EVENT_TURN_SCOPED_FLAGS_START EQU EVENT_LEVEL_SCOPED_FLAGS_END

	const EVENT_TURN_SCOPED_1
	const EVENT_TURN_SCOPED_2
	const EVENT_TURN_SCOPED_3
	const EVENT_TURN_SCOPED_4
	const EVENT_TURN_SCOPED_5
	const EVENT_TURN_SCOPED_6
	const EVENT_TURN_SCOPED_7
	const EVENT_TURN_SCOPED_8
	const EVENT_TURN_SCOPED_9
	const EVENT_TURN_SCOPED_10
	const EVENT_TURN_SCOPED_11
	const EVENT_TURN_SCOPED_12
	const EVENT_TURN_SCOPED_13
	const EVENT_TURN_SCOPED_14
	const EVENT_TURN_SCOPED_15
	const EVENT_TURN_SCOPED_16
	const EVENT_TURN_SCOPED_17
	const EVENT_TURN_SCOPED_18
	const EVENT_TURN_SCOPED_19
	const EVENT_TURN_SCOPED_20

if (const_value % 8) != 0
DEF const_value = const_value + 8 - (const_value % 8)
endc
DEF EVENT_TURN_SCOPED_FLAGS_END EQU const_value


;; The remaining flags are only reset explicitly
DEF EVENT_REGULAR_FLAGS_START EQU EVENT_TURN_SCOPED_FLAGS_END

	const EVENT_INITIALIZED_EVENTS

; Decorations
	const EVENT_DECO_BED_1
	const EVENT_DECO_BED_2
	const EVENT_DECO_BED_3
	const EVENT_DECO_BED_4
	const EVENT_DECO_CARPET_1
	const EVENT_DECO_CARPET_2
	const EVENT_DECO_CARPET_3
	const EVENT_DECO_CARPET_4
	const EVENT_DECO_PLANT_1
	const EVENT_DECO_PLANT_2
	const EVENT_DECO_PLANT_3
	const EVENT_DECO_POSTER_1
	const EVENT_DECO_POSTER_2
	const EVENT_DECO_POSTER_3
	const EVENT_DECO_POSTER_4
	const EVENT_DECO_FAMICOM
	const EVENT_DECO_SNES
	const EVENT_DECO_N64
	const EVENT_DECO_VIRTUAL_BOY
	const EVENT_DECO_PIKACHU_DOLL
	const EVENT_DECO_SURFING_PIKACHU_DOLL
	const EVENT_DECO_CLEFAIRY_DOLL
	const EVENT_DECO_JIGGLYPUFF_DOLL
	const EVENT_DECO_BULBASAUR_DOLL
	const EVENT_DECO_CHARMANDER_DOLL
	const EVENT_DECO_SQUIRTLE_DOLL
	const EVENT_DECO_POLIWAG_DOLL
	const EVENT_DECO_DIGLETT_DOLL
	const EVENT_DECO_STARYU_DOLL
	const EVENT_DECO_MAGIKARP_DOLL
	const EVENT_DECO_ODDISH_DOLL
	const EVENT_DECO_GENGAR_DOLL
	const EVENT_DECO_SHELLDER_DOLL
	const EVENT_DECO_GRIMER_DOLL
	const EVENT_DECO_VOLTORB_DOLL
	const EVENT_DECO_WEEDLE_DOLL
	const EVENT_DECO_UNOWN_DOLL
	const EVENT_DECO_GEODUDE_DOLL
	const EVENT_DECO_MACHOP_DOLL
	const EVENT_DECO_TENTACOOL_DOLL
	const EVENT_PLAYERS_ROOM_POSTER
	const EVENT_DECO_GOLD_TROPHY
	const EVENT_DECO_SILVER_TROPHY
	const EVENT_DECO_BIG_SNORLAX_DOLL
	const EVENT_DECO_BIG_ONIX_DOLL
	const EVENT_DECO_BIG_LAPRAS_DOLL
	const EVENT_PLAYERS_HOUSE_2F_CONSOLE
	const EVENT_PLAYERS_HOUSE_2F_DOLL_1
	const EVENT_PLAYERS_HOUSE_2F_DOLL_2
	const EVENT_PLAYERS_HOUSE_2F_BIG_DOLL

; Bug catching contest
	const EVENT_BUG_CATCHING_CONTESTANT_1A
	const EVENT_BUG_CATCHING_CONTESTANT_2A
	const EVENT_BUG_CATCHING_CONTESTANT_3A
	const EVENT_BUG_CATCHING_CONTESTANT_4A
	const EVENT_BUG_CATCHING_CONTESTANT_5A
	const EVENT_BUG_CATCHING_CONTESTANT_6A
	const EVENT_BUG_CATCHING_CONTESTANT_7A
	const EVENT_BUG_CATCHING_CONTESTANT_8A
	const EVENT_BUG_CATCHING_CONTESTANT_9A
	const EVENT_BUG_CATCHING_CONTESTANT_10A
	const EVENT_BUG_CATCHING_CONTESTANT_1B
	const EVENT_BUG_CATCHING_CONTESTANT_2B
	const EVENT_BUG_CATCHING_CONTESTANT_3B
	const EVENT_BUG_CATCHING_CONTESTANT_4B
	const EVENT_BUG_CATCHING_CONTESTANT_5B
	const EVENT_BUG_CATCHING_CONTESTANT_6B
	const EVENT_BUG_CATCHING_CONTESTANT_7B
	const EVENT_BUG_CATCHING_CONTESTANT_8B
	const EVENT_BUG_CATCHING_CONTESTANT_9B
	const EVENT_BUG_CATCHING_CONTESTANT_10B
	const EVENT_CONTEST_OFFICER_HAS_SUN_STONE
	const EVENT_CONTEST_OFFICER_HAS_EVERSTONE
	const EVENT_CONTEST_OFFICER_HAS_GOLD_BERRY
	const EVENT_CONTEST_OFFICER_HAS_BERRY
	const EVENT_LEFT_MONS_WITH_CONTEST_OFFICER

; Chambers
	const EVENT_WALL_OPENED_IN_HO_OH_CHAMBER
	const EVENT_WALL_OPENED_IN_KABUTO_CHAMBER
	const EVENT_WALL_OPENED_IN_OMANYTE_CHAMBER
	const EVENT_WALL_OPENED_IN_AERODACTYL_CHAMBER

DEF NUM_EVENTS EQU const_value ; 800
