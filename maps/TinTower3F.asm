const_value set 2
	const TINTOWER3F_POKE_BALL

TinTower3F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

TinTower3FFullHeal:
	itemball FULL_HEAL

TinTower3F_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 10, 14, 1, TIN_TOWER_2F
	warp_event 16, 2, 2, TIN_TOWER_4F

	db 0 ; coord events

	db 0 ; bg events

	db 1 ; object events
	object_event 3, 14, SPRITE_POKE_BALL, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, TinTower3FFullHeal, EVENT_TIN_TOWER_3F_FULL_HEAL
