const_value set 2
	const SILPHCO1F_RECEPTIONIST
	const SILPHCO1F_OFFICER

SilphCo1F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

SilphCoReceptionist:
	jumptextfaceplayer SilphCoReceptionistText

OfficerScript_0x18abe8:
	faceplayer
	opentext
	checkevent EVENT_GOT_UP_GRADE
	iftrue UnknownScript_0x18abfd
	writetext UnknownText_0x18ac36
	buttonsound
	verbosegiveitem UP_GRADE
	iffalse UnknownScript_0x18ac01
	setevent EVENT_GOT_UP_GRADE
UnknownScript_0x18abfd:
	writetext UnknownText_0x18aca8
	waitbutton
UnknownScript_0x18ac01:
	closetext
	end

SilphCoReceptionistText:
	text "Welcome. This is"
	line "SILPH CO.'s HEAD"
	cont "OFFICE BUILDING."
	done

UnknownText_0x18ac36:
	text "Only employees are"
	line "permitted to go"
	cont "upstairs."

	para "But since you came"
	line "such a long way,"

	para "have this neat"
	line "little souvenir."
	done

UnknownText_0x18aca8:
	text "It's SILPH CO.'s"
	line "latest product."

	para "It's not for sale"
	line "anywhere yet."
	done

SilphCo1F_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 2, 7, 7, SAFFRON_CITY
	warp_event 3, 7, 7, SAFFRON_CITY

	db 0 ; coord events

	db 0 ; bg events

	db 2 ; object events
	object_event 4, 2, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCoReceptionist, -1
	object_event 13, 1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OfficerScript_0x18abe8, -1
