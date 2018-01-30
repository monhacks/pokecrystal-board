const_value set 2
	const SILVERCAVEPOKECENTER1F_NURSE
	const SILVERCAVEPOKECENTER1F_GRANNY

SilverCavePokecenter1F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

NurseScript_0x1ae59a:
	jumpstd pokecenternurse

SilverCavePokecenter1FGrannyScript:
	jumptextfaceplayer SilverCavePokecenter1FGrannyText

SilverCavePokecenter1FGrannyText:
	text "Trainers who seek"
	line "power climb MT."

	para "SILVER despite its"
	line "many dangers…"

	para "With their trusted"
	line "#MON, they must"

	para "feel they can go"
	line "anywhere…"
	done

SilverCavePokecenter1F_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event 3, 7, 1, SILVER_CAVE_OUTSIDE
	warp_event 4, 7, 1, SILVER_CAVE_OUTSIDE
	warp_event 0, 7, 1, POKECENTER_2F

	db 0 ; coord events

	db 0 ; bg events

	db 2 ; object events
	object_event 3, 1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, NurseScript_0x1ae59a, -1
	object_event 1, 5, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_LEFT, 2, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilverCavePokecenter1FGrannyScript, -1
