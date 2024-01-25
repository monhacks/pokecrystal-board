; CGBLayoutJumptable indexes (see engine/gfx/cgb_layouts.asm)
	const_def
	const CGB_BATTLE_GRAYSCALE
	const CGB_BATTLE_COLORS
	const CGB_POKEGEAR_PALS
	const CGB_STATS_SCREEN_HP_PALS
	const CGB_POKEDEX
	const CGB_SLOT_MACHINE
	const CGB_BETA_TITLE_SCREEN
	const CGB_GS_INTRO
	const CGB_DIPLOMA
	const CGB_MAPPALS
	const CGB_PARTY_MENU
	const CGB_EVOLUTION
	const CGB_GS_TITLE_SCREEN
	const CGB_LEVEL_SELECTION_MENU
	const CGB_MOVE_LIST
	const CGB_BETA_PIKACHU_MINIGAME
	const CGB_POKEDEX_SEARCH_OPTION
	const CGB_BETA_POKER
	const CGB_POKEPIC
	const CGB_MAGNET_TRAIN
	const CGB_PACKPALS
	const CGB_TRAINER_CARD
	const CGB_POKEDEX_UNOWN_MODE
	const CGB_BILLS_PC
	const CGB_UNOWN_PUZZLE
	const CGB_GAMEFREAK_LOGO
	const CGB_PLAYER_OR_MON_FRONTPIC_PALS
	const CGB_TRADE_TUBE
	const CGB_TRAINER_OR_MON_FRONTPIC_PALS
	const CGB_1D
DEF NUM_CGB_LAYOUTS EQU const_value

DEF CGB_PARTY_MENU_HP_BARS EQU $fc
DEF CGB_DEFAULT EQU $ff

; GetCrystalCGBLayout arguments (see engine/gfx/crystal_layouts.asm)
	const_def
	const CRYSTAL_CGB_MOBILE_0
	const CRYSTAL_CGB_MOBILE_1
	const CRYSTAL_CGB_NAME_CARD

; PredefPals indexes (see gfx/predef/predef.pal)
; GetPredefPal arguments (see engine/gfx/color.asm)
	const_def
	const PREDEFPAL_ROUTES
	const PREDEFPAL_PALLET
	const PREDEFPAL_VIRIDIAN
	const PREDEFPAL_PEWTER
	const PREDEFPAL_CERULEAN
	const PREDEFPAL_LAVENDER
	const PREDEFPAL_VERMILION
	const PREDEFPAL_CELADON
	const PREDEFPAL_FUCHSIA
	const PREDEFPAL_CINNABAR
	const PREDEFPAL_SAFFRON
	const PREDEFPAL_INDIGO
	const PREDEFPAL_NEW_BARK
	const PREDEFPAL_CHERRYGROVE
	const PREDEFPAL_VIOLET
	const PREDEFPAL_AZALEA
	const PREDEFPAL_GOLDENROD
	const PREDEFPAL_ECRUTEAK
	const PREDEFPAL_OLIVINE
	const PREDEFPAL_CIANWOOD
	const PREDEFPAL_MAHOGANY
	const PREDEFPAL_BLACKTHORN
	const PREDEFPAL_LAKE_OF_RAGE
	const PREDEFPAL_SILVER_CAVE
	const PREDEFPAL_DUNGEONS
	const PREDEFPAL_NITE
	const PREDEFPAL_BLACKOUT
	const PREDEFPAL_DIPLOMA ; RB_MEWMON
	const PREDEFPAL_TRADE_TUBE ; RB_BLUEMON
	const PREDEFPAL_POKEDEX ; RB_REDMON
	const PREDEFPAL_RB_CYANMON
	const PREDEFPAL_RB_PURPLEMON
	const PREDEFPAL_RB_BROWNMON
	const PREDEFPAL_RB_GREENMON
	const PREDEFPAL_RB_PINKMON
	const PREDEFPAL_RB_YELLOWMON
	const PREDEFPAL_CGB_BADGE ; RB_GRAYMON
	const PREDEFPAL_BETA_SHINY_MEWMON
	const PREDEFPAL_BETA_SHINY_BLUEMON
	const PREDEFPAL_BETA_SHINY_REDMON
	const PREDEFPAL_BETA_SHINY_CYANMON
	const PREDEFPAL_BETA_SHINY_PURPLEMON
	const PREDEFPAL_BETA_SHINY_BROWNMON
	const PREDEFPAL_BETA_SHINY_GREENMON
	const PREDEFPAL_BETA_SHINY_PINKMON
	const PREDEFPAL_BETA_SHINY_YELLOWMON
	const PREDEFPAL_PARTY_ICON ; BETA_SHINY_GRAYMON
	const PREDEFPAL_HP_GREEN
	const PREDEFPAL_HP_YELLOW
	const PREDEFPAL_HP_RED
	const PREDEFPAL_POKEGEAR
	const PREDEFPAL_BETA_LOGO_1
	const PREDEFPAL_BETA_LOGO_2
	const PREDEFPAL_GS_INTRO_GAMEFREAK_LOGO
	const PREDEFPAL_GS_INTRO_SHELLDER_LAPRAS
	const PREDEFPAL_BETA_INTRO_LAPRAS
	const PREDEFPAL_GS_INTRO_JIGGLYPUFF_PIKACHU_BG
	const PREDEFPAL_GS_INTRO_JIGGLYPUFF_PIKACHU_OB
	const PREDEFPAL_GS_INTRO_STARTERS_TRANSITION
	const PREDEFPAL_BETA_INTRO_VENUSAUR
	const PREDEFPAL_PACK ; GS_INTRO_CHARIZARD
	const PREDEFPAL_SLOT_MACHINE_0
	const PREDEFPAL_SLOT_MACHINE_1
	const PREDEFPAL_SLOT_MACHINE_2
	const PREDEFPAL_SLOT_MACHINE_3
	const PREDEFPAL_BETA_POKER_0
	const PREDEFPAL_BETA_POKER_1
	const PREDEFPAL_BETA_POKER_2
	const PREDEFPAL_BETA_POKER_3
	const PREDEFPAL_BETA_RADIO
	const PREDEFPAL_BETA_POKEGEAR
	const PREDEFPAL_47
	const PREDEFPAL_GS_TITLE_SCREEN_0
	const PREDEFPAL_GS_TITLE_SCREEN_1
	const PREDEFPAL_GS_TITLE_SCREEN_2
	const PREDEFPAL_GS_TITLE_SCREEN_3
	const PREDEFPAL_UNOWN_PUZZLE
	const PREDEFPAL_GAMEFREAK_LOGO_OB
	const PREDEFPAL_GAMEFREAK_LOGO_BG
DEF NUM_PREDEF_PALS EQU const_value

; RGBFadeEffectJumptable indexes (see engine/gfx/rgb_fade.asm:DoRGBFadeEffect)
	const_def
	const RGBFADE_TO_BLACK_6BGP
	const RGBFADE_TO_LIGHTER_6BGP
	const RGBFADE_TO_WHITE_6BGP_3OBP
	const RGBFADE_TO_WHITE_8BGP_8OBP
	const RGBFADE_TO_BLACK_6BGP_1OBP2
	const RGBFADE_TO_LIGHTER_6BGP_1OBP2
DEF NUM_RGB_FADE_EFFECTS EQU const_value
