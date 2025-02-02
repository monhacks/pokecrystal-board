SECTION "Events", ROMX

OverworldLoop::
	xor a ; MAPSTATUS_START
	ld [wMapStatus], a
	ld a, TRUE
	ld [hLCDStatIntRequired], a
.loop
	ld a, [wMapStatus]
	ld hl, .Jumptable
	rst JumpTable
	ld a, [wMapStatus]
	cp MAPSTATUS_DONE
	jr nz, .loop
.done
	call DisableOverworldHUD
	ld hl, wGameTimer
	res GAME_TIMER_COUNTING_F, [hl] ; stop game timer counter
	ld a, FALSE
	ld [wText2bpp], a
	ret

.Jumptable:
; entries correspond to MAPSTATUS_* constants
	dw StartMap
	dw EnterMap
	dw HandleMap
	dw .done

DisableEvents:
	xor a
	ld [wEnabledPlayerEvents], a
	ret

EnableEvents::
	ld a, $ff
	ld [wEnabledPlayerEvents], a
	ret

DisableTileEvents:
; DisableWarpsConnections + DisableCoordEvents + DisableStepCount + DisableWildEncounters
	push af
	ld hl, wEnabledPlayerEvents
	ld a, [hl]
	and ~((1 << 0) | (1 << 1) | (1 << 2) | (1 << 3))
	ld [hl], a
	pop af
	ret

DisableWarpsConnections: ; unreferenced
	ld hl, wEnabledPlayerEvents
	res 2, [hl]
	ret

DisableCoordEvents: ; unreferenced
	ld hl, wEnabledPlayerEvents
	res 1, [hl]
	ret

DisableStepCount: ; unreferenced
	ld hl, wEnabledPlayerEvents
	res 0, [hl]
	ret

DisableWildEncounters: ; unreferenced
	ld hl, wEnabledPlayerEvents
	res 3, [hl]
	ret

DisableSpaceEffects:
	ld hl, wEnabledPlayerEvents
	res 4, [hl]
	ret

DisableTrainerAndTalkerEvents: ; unreferenced
	ld hl, wEnabledPlayerEvents
	res 5, [hl]
	ret

EnableWarpsConnections: ; unreferenced
	ld hl, wEnabledPlayerEvents
	set 2, [hl]
	ret

EnableCoordEvents: ; unreferenced
	ld hl, wEnabledPlayerEvents
	set 1, [hl]
	ret

EnableStepCount: ; unreferenced
	ld hl, wEnabledPlayerEvents
	set 0, [hl]
	ret

EnableWildEncounters:
	ld hl, wEnabledPlayerEvents
	set 3, [hl]
	ret

EnableSpaceEffects: ; unreferenced
	ld hl, wEnabledPlayerEvents
	set 4, [hl]
	ret

EnableTrainerAndTalkerEvents: ; unreferenced
	ld hl, wEnabledPlayerEvents
	set 5, [hl]
	ret

CheckWarpConnectionsEnabled:
	ld hl, wEnabledPlayerEvents
	bit 2, [hl]
	ret

CheckCoordEventsEnabled:
	ld hl, wEnabledPlayerEvents
	bit 1, [hl]
	ret

CheckStepCountEnabled:
	ld hl, wEnabledPlayerEvents
	bit 0, [hl]
	ret

CheckWildEncountersEnabled:
	ld hl, wEnabledPlayerEvents
	bit 3, [hl]
	ret

CheckSpaceEffectsScriptFlag:
	ld hl, wEnabledPlayerEvents
	bit 4, [hl]
	ret

CheckTrainerAndTalkerEvents:
	ld hl, wEnabledPlayerEvents
	bit 5, [hl]
	ret

; on enter overworld loop (MAPSETUP_ENTERLEVEL or MAPSETUP_CONTINUE)
StartMap:
	xor a
	ldh [hScriptVar], a
	xor a
	ld [wScriptRunning], a
	ld hl, wMapStatus
	ld bc, wMapStatusEnd - wMapStatus
	call ByteFill
	farcall InitCallReceiveDelay
	call ClearJoypad

	ld a, [hMapEntryMethod]
	cp MAPSETUP_ENTERLEVEL
	jr nz, .not_starting_level

; initialize board state
	xor a
	ld hl, wCurTurn
	ld [hli], a ; wCurTurn
	ld [hli], a ;
	ld [hli], a ; wCurSpace
	ld [hli], a ; wCurLevelCoins
	ld [hli], a ;
	ld [hli], a ;
	ld [hli], a ; wCurLevelExp
	ld [hli], a ;
	ld [hl], a  ;

; initialize overworld state
	ld hl, wNextWarp
	xor a
	ld [hli], a ; wNextWarp
	ld [hli], a ; wNextMapGroup
	ld [hli], a ; wNextMapNumber
	ld [hli], a ; wPrevWarp
	ld [hli], a ; wPrevMapGroup
	ld [hl], a  ; wPrevMapNumber
	ld [wPlayerState], a ; PLAYER_NORMAL
	ld [wCurOverworldMiscPal], a ; OW_MISC_BOARD_MENU_ITEMS | BOARDMENUITEM_DIE
	ld hl, wStatusFlags
	res STATUSFLAGS_FLASH_F, [hl]

	ld a, BANK(wDisabledSpacesBackups)
	ld [rSVBK], a
	ld hl, wDisabledSpacesBackups
	ld bc, wDisabledSpacesBackupsEnd - wDisabledSpacesBackups
	xor a
	call ByteFill
	ld e, NUM_DISABLED_SPACES_BACKUPS
	ld hl, wDisabledSpacesBackups
	ld bc, wMap2DisabledSpacesBackup - wMap1DisabledSpacesBackup
.loop1
	ld a, GROUP_N_A
	ld [hl], a
	add hl, bc
	dec e
	jr nz, .loop1
	ld [hl], $00 ; list terminator

	ld a, BANK(wMapObjectsBackups)
	ld [rSVBK], a
	ld e, NUM_MAP_OBJECTS_BACKUPS
	ld hl, wMapObjectsBackups
	ld bc, wMap2ObjectsBackup - wMap1ObjectsBackup
.loop2
	ld a, GROUP_N_A
	ld [hl], a
	add hl, bc
	dec e
	jr nz, .loop2
	ld [hl], $00 ; list terminator

	ld a, 1
	ld [rSVBK], a

.not_starting_level
	ld a, BOARDEVENT_DISPLAY_MENU
	ldh [hCurBoardEvent], a
; fallthrough

; on map reload (e.g. after battle), warps and connections
EnterMap:
	xor a
	ld [wXYComparePointer], a
	ld [wXYComparePointer + 1], a
	call SetUpFiveStepWildEncounterCooldown
	farcall RunMapSetupScript
	call DisableEvents

	ldh a, [hMapEntryMethod]
	cp MAPSETUP_CONNECTION
	jr nz, .dont_enable
	call EnableEvents
.dont_enable

	ldh a, [hMapEntryMethod]
	cp MAPSETUP_RELOADMAP
	jr nz, .dontresetpoison
	xor a
	ld [wPoisonStepCount], a
.dontresetpoison

	xor a ; end map entry
	ldh [hMapEntryMethod], a
	ld a, MAPSTATUS_HANDLE
	ld [wMapStatus], a
	ret

HandleMap:
	call ResetOverworldDelay
	call HandleMapTimeAndJoypad
	call HandleCmdQueue
	call MapEvents

; Not immediately entering a connected map will cause problems.
	ld a, [wMapStatus]
	cp MAPSTATUS_HANDLE
	ret nz

	call HandleMapObjects
	call NextOverworldFrame
	call HandleMapBackground
	call CheckPlayerState
	ret

MapEvents:
	ld a, [wMapEventStatus]
	ld hl, .Jumptable
	rst JumpTable
	ret

.Jumptable:
; entries correspond to MAPEVENTS_* constants
	dw .events
	dw .no_events

.events:
	call PlayerEvents
	farcall ScriptEvents
	ret

.no_events:
	ret

DEF MAX_OVERWORLD_DELAY      EQU 2
DEF VIEW_MAP_OVERWORLD_DELAY EQU 1
ResetOverworldDelay:
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_VIEW_MAP_MODE
	ld a, MAX_OVERWORLD_DELAY
	jr nz, .set_delay
	ld a, VIEW_MAP_OVERWORLD_DELAY
.set_delay
	ldh [hOverworldDelay], a
	ret

NextOverworldFrame:
	ldh a, [hOverworldDelay]
	and a
	ret z
	ld c, a
	call DelayFrames
	ret

HandleMapTimeAndJoypad:
	ld a, [wMapEventStatus]
	cp MAPEVENTS_OFF
	ret z

	call GetJoypad
	call TimeOfDayPals
	ret

HandleMapObjects:
	farcall HandleNPCStep
	farcall _HandlePlayerStep
	call _CheckObjectEnteringVisibleRange
	ret

HandleMapBackground:
	call UpdateActiveSprites
	farcall ScrollScreen
	ret

CheckPlayerState:
	ld a, [wPlayerStepFlags]
	bit PLAYERSTEP_CONTINUE_F, a
	jr z, .events ; PLAYERSTEP_CONTINUE_F not set
	bit PLAYERSTEP_STOP_F, a
	jr z, .noevents ; PLAYERSTEP_CONTINUE_F set and PLAYERSTEP_STOP_F not set
	bit PLAYERSTEP_MIDAIR_F, a
	jr nz, .noevents ; PLAYERSTEP_CONTINUE_F, PLAYERSTEP_STOP_F, and PLAYERSTEP_MIDAIR_F all set
	call EnableEvents
.events
	ld a, MAPEVENTS_ON
	ld [wMapEventStatus], a
	ret

.noevents
	ld a, MAPEVENTS_OFF
	ld [wMapEventStatus], a
	ret

_CheckObjectEnteringVisibleRange:
	ld hl, wPlayerStepFlags
	bit PLAYERSTEP_STOP_F, [hl]
	ret z
	farcall CheckObjectEnteringVisibleRange
	ret

PlayerEvents:
	xor a
; If there's already a player event, don't interrupt it.
	ld a, [wScriptRunning]
	and a
	ret nz

	call CheckBoardEvent
	call DisableSpaceEffects ; doesn't alter f
	jr c, .ok

	call CheckTrainerOrTalkerEvent
	jr c, .ok

	call CheckTileEvent
	call DisableTileEvents ; preserves f
	jr c, .ok

	call CheckFacingTileEvent
	jr c, .ok

	call RunMemScript
	jr c, .ok

	call RunSceneScript
	jr c, .ok

	call CheckTimeEvents
	jr c, .ok

; BOARDEVENT_END_TURN is used as turn cleanup after BOARDEVENT_HANDLE_BOARD.
; when we make it here, it means there's finally nothing else to do (e.g. a trainer),
; so return with BOARDEVENT_DISPLAY_MENU for the next MapEvents iteration.
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_END_TURN
	jr nz, .continue
	ld a, BOARDEVENT_DISPLAY_MENU
	ldh [hCurBoardEvent], a
	xor a
	ret

.continue
	call OWPlayerInput
	jr c, .ok

	xor a
	ret

.ok
	push af
	farcall EnableScriptMode
	pop af

	ld [wScriptRunning], a
	call DoPlayerEvent
	scf
	ret

CheckBoardEvent:
	jumptable .Jumptable, hCurBoardEvent

.Jumptable:
	table_width 2, .Jumptable
	dw .none
	dw .menu    ; BOARDEVENT_DISPLAY_MENU
	dw .board   ; BOARDEVENT_HANDLE_BOARD
	dw .none    ; BOARDEVENT_END_TURN
	dw .viewmap ; BOARDEVENT_VIEW_MAP_MODE
	dw .menu    ; BOARDEVENT_REDISPLAY_MENU
	dw .branch  ; BOARDEVENT_RESUME_BRANCH
	assert_table_length NUM_BOARD_EVENTS + 1

.none
	xor a
	ret

.menu
	ld a, BANK(BoardMenuScript)
	ld hl, BoardMenuScript
	call CallScript
	scf
	ret

.board
	call CheckSpaceEffectsScriptFlag
	jr z, .no_space_effect

; anchor point handler
; if wCurSpaceNextSpace is not an anchor point, override any anchor point we pass through
	ld a, [wCurSpaceNextSpace]
	cp NEXT_SPACE_IS_ANCHOR_POINT
	jr c, .next
	ld a, [wCurMapAnchorEventCount]
	and a
	jr z, .next
; if we have arrived to an anchor point, load its associated next space to wCurSpaceNextSpace right now.
; don't queue a script so that it happens transparently from the point of view of the player's movement.
; note that the next space of an anchor point could be another anchor point.
	ld c, a
	ld hl, wCurMapAnchorEventsPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wXCoord]
	ld d, a
	ld a, [wYCoord]
	ld e, a
	call CheckAndApplyAnchorPoint
	ret nc ; if we applied an anchor point, we're done here (we're not in a space)

.next
; space handler
	ld a, [wPlayerTileCollision]
	and $f0
	cp HI_NYBBLE_SPACES
	jr nz, .no_space_effect
	ld a, [wPlayerTileCollision]
	and $0f
	ld e, a
	ld d, 0
	ld hl, .SpaceScripts
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(BoardSpaceScripts)
	call CallScript
	scf
	ret

.viewmap
; check if player pressed B and if so queue the script to exit View Map mode
	ldh a, [hJoyDown]
	and D_PAD
	ret nz ; nc
	ldh a, [hJoyPressed]
	bit B_BUTTON_F, a
	ret z ; nc
; B was pressed
	ld a, BANK(.ExitViewMapModeScript)
	ld hl, .ExitViewMapModeScript
	call CallScript
	scf
	ret

.ExitViewMapModeScript:
	reloadmapafterviewmapmode
	end

.branch
; special handler to resume branch space after returning from View Map mode.
; skip scall to .ArriveToBranchSpaceScript not to recompute branch struct.
	ld a, BOARDEVENT_HANDLE_BOARD
	ldh [hCurBoardEvent], a
	ld a, BANK(BranchSpaceScript)
	ld hl, BranchSpaceScript_PromptPlayer
	call CallScript
	scf
	ret

.no_space_effect
; continue moving in board
	xor a
	ret

.SpaceScripts:
	table_width 2, .SpaceScripts
	dw BlueSpaceScript     ; COLL_BLUE_SPACE
	dw RedSpaceScript      ; COLL_RED_SPACE
	dw GreenSpaceScript    ; COLL_GREEN_SPACE
	dw ItemSpaceScript     ; COLL_ITEM_SPACE
	dw PokemonSpaceScript  ; COLL_POKEMON_SPACE
	dw MinigameSpaceScript ; COLL_MINIGAME_SPACE
	dw EndSpaceScript      ; COLL_END_SPACE
	dw GreySpaceScript     ; COLL_GREY_SPACE
	dw BranchSpaceScript   ; COLL_BRANCH_SPACE
	dw UnionSpaceScript    ; COLL_UNION_SPACE
	assert_table_length NUM_COLL_SPACES

CheckTrainerOrTalkerEvent:
	call CheckTrainerAndTalkerEvents
	jr z, .nope
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_VIEW_MAP_MODE
	ret z ; nc

	call CheckTrainerBattleOrTalkerPrompt
	jr nc, .nope

	ld a, [wSeenTrainerOrTalkerIsTalker]
	and a ; cp FALSE
	ld a, PLAYEREVENT_SEENBYTRAINER
	jr z, .done
	ld a, PLAYEREVENT_SEENBYTALKER
.done
	scf
	ret

.nope
	xor a
	ret

CheckTileEvent:
; Check for warps, coord events, or wild battles.

	call CheckWarpConnectionsEnabled
	jr z, .connections_disabled

	farcall CheckMovingOffEdgeOfMap
	jr c, .map_connection

	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_VIEW_MAP_MODE
	ret z ; nc

	call CheckWarpTile
	jr c, .warp_tile

.connections_disabled
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_VIEW_MAP_MODE
	ret z ; nc

	call CheckCoordEventsEnabled
	jr z, .coord_events_disabled

	call CheckCurrentMapCoordEvents
	jr c, .coord_event

.coord_events_disabled
	call CheckStepCountEnabled
	jr z, .step_count_disabled

	call CountStep
	ret c

.step_count_disabled
	call CheckWildEncountersEnabled
	jr z, .ok

	call RandomEncounter
	ret c

.ok
	xor a
	ret

.map_connection
	ld a, PLAYEREVENT_CONNECTION
	scf
	ret

.warp_tile
	ld a, [wPlayerTileCollision]
	call CheckPitTile
	jr nz, .not_pit
	ld a, PLAYEREVENT_FALL
	scf
	ret

.not_pit
	ld a, PLAYEREVENT_WARP
	scf
	ret

.coord_event
	ld hl, wCurCoordEventScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapScriptsBank
	call CallScript
	ret

CheckWildEncounterCooldown::
	ld hl, wWildEncounterCooldown
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret z
	scf
	ret

SetUpFiveStepWildEncounterCooldown:
	ld a, 5
	ld [wWildEncounterCooldown], a
	ret

SetMinTwoStepWildEncounterCooldown: ; unreferenced
	ld a, [wWildEncounterCooldown]
	cp 2
	ret nc
	ld a, 2
	ld [wWildEncounterCooldown], a
	ret

CheckFacingTileEvent:
; no tile events if not in BOARDEVENT_HANDLE_BOARD (e.g. after player lands in space)
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_HANDLE_BOARD
	jr nz, .NoAction

; no facing-tile events until player has turned to the walking direction.
; if the player has to perform a STEP_TURN first, the facing tile is not the right one.
	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .NoAction
	ld e, a
	ld a, [wPlayerDirection]
	rrca
	rrca
	maskbits NUM_DIRECTIONS
	cp e
	jr nz, .NoAction

	call .TryObjectEvent
	jr c, .Action
	call .TryTileCollisionEvent
	jr c, .Action
	; fallthrough

.NoAction:
	xor a
	ret

.Action:
	push af
	farcall StopPlayerForEvent
	pop af
	scf
	ret

.TryObjectEvent:
	farcall CheckFacingObject
	jr c, .IsObject
	xor a
	ret

.IsObject:
	ldh a, [hObjectStructIndex]
	call GetObjectStruct
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	ldh [hLastTalked], a

	ldh a, [hLastTalked]
	call GetMapObject
	ld hl, MAPOBJECT_TYPE
	add hl, bc
	ld a, [hl]
	and MAPOBJECT_TYPE_MASK

	push bc
	ld de, 3
	ld hl, .ObjectEventTypeArray
	call IsInArray
	pop bc
	jr nc, .nope

	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.nope
	xor a
	ret

.ObjectEventTypeArray:
	table_width 3, .ObjectEventTypeArray
	dbw OBJECTTYPE_SCRIPT, .none
	dbw OBJECTTYPE_ITEMBALL, .none
	dbw OBJECTTYPE_TRAINER, .none
	dbw OBJECTTYPE_TALKER, .none
	dbw OBJECTTYPE_ROCK, .rock
	dbw OBJECTTYPE_TREE, .tree
	dbw OBJECTTYPE_6, .none
	assert_table_length NUM_OBJECT_TYPES
	db -1 ; end

.none
	xor a
	ret ; nc

.rock
	ld a, BANK(RockSmashAutoScript)
	ld hl, RockSmashAutoScript
	call CallScript
	ret ; c

.tree
	ld a, BANK(Script_CutAuto)
	ld hl, Script_CutAuto
	call CallScript
	ret ; c

.TryTileCollisionEvent:
	call GetFacingTileCoord
	ld [wFacingTileID], a

;; Surf
; Don't surf if already surfing.
	ld a, [wPlayerState]
	cp PLAYER_SURF_PIKA
	jr z, .next_event_1
	cp PLAYER_SURF
	jr z, .next_event_1

; Must be facing water.
	ld a, [wFacingTileID]
	call GetTilePermission
	cp WATER_TILE
	jr nz, .next_event_1

	ld a, PLAYER_SURF
	ld [wSurfingPlayerState], a

	ld a, BANK(SurfAutoScript)
	ld hl, SurfAutoScript
	call CallScript
	ret ; c

.next_event_1
;; Waterfall
	ld a, [wFacingTileID]
	call CheckWaterfallTile
	jr nz, .next_event_2

; Must be facing up and facing a waterfall tile to trigger the waterfall up sequence.
; Otherwise HI_NYBBLE_CURRENT collision (forced walking in walking direction) applies.
	farcall CheckMapCanWaterfall
	jr c, .next_event_2

	ld a, BANK(Script_WaterfallAuto)
	ld hl, Script_WaterfallAuto
	call CallScript
	ret ; c

.next_event_2
.no_event
	xor a
	ret ; nc

RunSceneScript:
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_VIEW_MAP_MODE
	ret z ; nc

	ld a, [wCurMapSceneScriptCount]
	and a
	jr z, .nope

	ld c, a
	call CheckScenes
	cp c
	jr nc, .nope

	ld e, a
	ld d, 0
	ld hl, wCurMapSceneScriptsPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
rept SCENE_SCRIPT_SIZE
	add hl, de
endr

	call GetMapScriptsBank
	call GetFarWord
	call GetMapScriptsBank
	call CallScript

	ld hl, wScriptFlags
	res 3, [hl]

	farcall EnableScriptMode
	farcall ScriptEvents

	ld hl, wScriptFlags
	bit 3, [hl]
	jr z, .nope

	ld hl, wDeferredScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wDeferredScriptBank]
	call CallScript
	scf
	ret

.nope
	xor a
	ret

CheckTimeEvents:
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_VIEW_MAP_MODE
	ret z ; nc

	ld a, [wLinkMode]
	and a
	jr nz, .nothing

	ld hl, wStatusFlags2
	bit STATUSFLAGS2_BUG_CONTEST_TIMER_F, [hl]
	jr z, .do_daily

	farcall CheckBugContestTimer
	jr c, .end_bug_contest
	xor a
	ret

.do_daily
	farcall CheckDailyResetTimer
	farcall CheckPokerusTick
	farcall CheckPhoneCall
	ret c

.nothing
	xor a
	ret

.end_bug_contest
	ld a, BANK(BugCatchingContestOverScript)
	ld hl, BugCatchingContestOverScript
	call CallScript
	scf
	ret

OWPlayerInput:
	call PlayerMovement
	ret c
	and a
	jr nz, .NoAction

; Can't perform button actions while in BOARDEVENT_HANDLE_BOARD or BOARDEVENT_VIEW_MAP_MODE
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_HANDLE_BOARD
	jr z, .NoAction
	cp BOARDEVENT_VIEW_MAP_MODE
	jr z, .NoAction

; Can't perform button actions while sliding on ice.
	farcall CheckStandingOnIce
	jr c, .NoAction

	call CheckAPressOW
	jr c, .Action

	call CheckMenuOW
	jr c, .Action

.NoAction:
	xor a
	ret

.Action:
	push af
	farcall StopPlayerForEvent
	pop af
	scf
	ret

CheckAPressOW:
	ldh a, [hJoyPressed]
	and A_BUTTON
	ret z
	call TryObjectEvent
	ret c
	call TryBGEvent
	ret c
	call TryTileCollisionEvent
	ret c
	xor a
	ret

PlayTalkObject:
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret

TryObjectEvent:
	farcall CheckFacingObject
	jr c, .IsObject
	xor a
	ret

.IsObject:
	call PlayTalkObject
	ldh a, [hObjectStructIndex]
	call GetObjectStruct
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	ldh [hLastTalked], a

	ldh a, [hLastTalked]
	call GetMapObject
	ld hl, MAPOBJECT_TYPE
	add hl, bc
	ld a, [hl]
	and MAPOBJECT_TYPE_MASK

	push bc
	ld de, 3
	ld hl, ObjectEventTypeArray
	call IsInArray
	pop bc
	jr nc, .nope

	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.nope
	xor a
	ret

ObjectEventTypeArray:
	table_width 3, ObjectEventTypeArray
	dbw OBJECTTYPE_SCRIPT, .script
	dbw OBJECTTYPE_ITEMBALL, .itemball
	dbw OBJECTTYPE_TRAINER, .trainer
	; the remaining four are dummy events
	dbw OBJECTTYPE_TALKER, .three
	dbw OBJECTTYPE_ROCK, .four
	dbw OBJECTTYPE_TREE, .five
	dbw OBJECTTYPE_6, .six
	assert_table_length NUM_OBJECT_TYPES
	db -1 ; end

.script
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapScriptsBank
	call CallScript
	ret

.itemball
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapScriptsBank
	ld de, wItemBallData
	ld bc, wItemBallDataEnd - wItemBallData
	call FarCopyBytes
	ld a, PLAYEREVENT_ITEMBALL
	scf
	ret

.trainer
	call TalkToTrainer
	ld a, PLAYEREVENT_TALKTOTRAINER
	scf
	ret

.three
	xor a
	ret

.four
	xor a
	ret

.five
	xor a
	ret

.six
	xor a
	ret

TryBGEvent:
	call CheckFacingBGEvent
	jr c, .is_bg_event
	xor a
	ret

.is_bg_event:
	ld a, [wCurBGEventType]
	ld hl, BGEventJumptable
	rst JumpTable
	ret

BGEventJumptable:
	table_width 2, BGEventJumptable
	dw .read
	dw .up
	dw .down
	dw .right
	dw .left
	dw .ifset
	dw .ifnotset
	dw .itemifset
	dw .copy
	assert_table_length NUM_BGEVENTS

.up:
	ld b, OW_UP
	jr .checkdir

.down:
	ld b, OW_DOWN
	jr .checkdir

.right:
	ld b, OW_RIGHT
	jr .checkdir

.left:
	ld b, OW_LEFT
	jr .checkdir

.checkdir:
	ld a, [wPlayerDirection]
	and %1100
	cp b
	jp nz, .dontread
.read:
	call PlayTalkObject
	ld hl, wCurBGEventScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapScriptsBank
	call CallScript
	scf
	ret

.itemifset:
	call CheckBGEventFlag
	jp nz, .dontread
	call PlayTalkObject
	call GetMapScriptsBank
	ld de, wHiddenItemData
	ld bc, wHiddenItemDataEnd - wHiddenItemData
	call FarCopyBytes
	ld a, BANK(HiddenItemScript)
	ld hl, HiddenItemScript
	call CallScript
	scf
	ret

.copy:
	call CheckBGEventFlag
	jr nz, .dontread
	call GetMapScriptsBank
	ld de, wHiddenItemData
	ld bc, wHiddenItemDataEnd - wHiddenItemData
	call FarCopyBytes
	jr .dontread

.ifset:
	call CheckBGEventFlag
	jr z, .dontread
	jr .thenread

.ifnotset:
	call CheckBGEventFlag
	jr nz, .dontread
.thenread:
	push hl
	call PlayTalkObject
	pop hl
	inc hl
	inc hl
	call GetMapScriptsBank
	call GetFarWord
	call GetMapScriptsBank
	call CallScript
	scf
	ret

.dontread:
	xor a
	ret

CheckBGEventFlag:
	ld hl, wCurBGEventScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	call GetMapScriptsBank
	call GetFarWord
	ld e, l
	ld d, h
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	pop hl
	ret

PlayerMovement:
	farcall DoPlayerMovement
	ld a, c
	ld hl, PlayerMovementPointers
	rst JumpTable
	ld a, c
	ret

PlayerMovementPointers:
; entries correspond to PLAYERMOVEMENT_* constants
	table_width 2, PlayerMovementPointers
	dw .normal
	dw .warp
	dw .turn
	dw .force_turn
	dw .finish
	dw .continue
	dw .exit_water
	dw .jump
	assert_table_length NUM_PLAYER_MOVEMENTS

.normal:
.finish:
	xor a
	ld c, a
	ret

.jump:
	xor a
	ld c, a
	ret

.warp:
	ld a, PLAYEREVENT_WARP
	ld c, a
	scf
	ret

.turn:
	ld a, PLAYEREVENT_JOYCHANGEFACING
	ld c, a
	scf
	ret

.force_turn:
; force the player to move in some direction
	ld a, BANK(Script_ForcedMovement)
	ld hl, Script_ForcedMovement
	call CallScript
	ld c, a
	scf
	ret

.continue:
.exit_water:
	ld a, -1
	ld c, a
	and a
	ret

CheckMenuOW:
	xor a
	ld [wMenuReturn], a
	ldh a, [hJoyPressed]

	bit SELECT_F, a
	jr nz, .Select

	bit START_F, a
	jr z, .NoMenu

	ld a, BANK(StartMenuScript)
	ld hl, StartMenuScript
	call CallScript
	scf
	ret

.NoMenu:
	xor a
	ret

.Select:
	call PlayTalkObject
	ld a, BANK(SelectMenuScript)
	ld hl, SelectMenuScript
	call CallScript
	scf
	ret

StartMenuScript:
	callasm StartMenu
	sjump StartMenuCallback

SelectMenuScript:
	callasm SelectMenu
	sjump SelectMenuCallback

StartMenuCallback:
SelectMenuCallback:
	readmem wMenuReturn
	ifequal MENURETURN_SCRIPT, .Script
	ifequal MENURETURN_ASM, .Asm
	end

.Script:
	memjump wQueuedScriptBank

.Asm:
	memcallasm wQueuedScriptBank
	end

CountStep:
	; Don't count steps in link communication rooms.
	ld a, [wLinkMode]
	and a
	jr nz, .done

	; If there is a special phone call, don't count the step.
	farcall CheckSpecialPhoneCall
	jr c, .doscript

	; If Repel wore off, don't count the step.
	call DoRepelStep
	jr c, .doscript

	; Count the step for poison and total steps
	ld hl, wPoisonStepCount
	inc [hl]
	ld hl, wStepCount
	inc [hl]
	; Every 256 steps, increase the happiness of all your Pokemon.
	jr nz, .skip_happiness

	farcall StepHappiness

.skip_happiness
	; Every 256 steps, offset from the happiness incrementor by 128 steps,
	; decrease the hatch counter of all your eggs until you reach the first
	; one that is ready to hatch.
	ld a, [wStepCount]
	cp $80
	jr nz, .skip_egg

	farcall DoEggStep
	jr nz, .hatch

.skip_egg
	; Increase the EXP of (both) DayCare Pokemon by 1.
	farcall DayCareStep

	; Every 4 steps, deal damage to all poisoned Pokemon.
	ld hl, wPoisonStepCount
	ld a, [hl]
	cp 4
	jr c, .skip_poison
	ld [hl], 0

	farcall DoPoisonStep
	jr c, .doscript

.skip_poison
	farcall DoBikeStep

.done
	xor a
	ret

.doscript
	ld a, -1
	scf
	ret

.hatch
	ld a, PLAYEREVENT_HATCH
	scf
	ret

.whiteout ; unreferenced
	ld a, PLAYEREVENT_WHITEOUT
	scf
	ret

DoRepelStep:
	ld a, [wRepelEffect]
	and a
	ret z

	dec a
	ld [wRepelEffect], a
	ret nz

	ld a, BANK(RepelWoreOffScript)
	ld hl, RepelWoreOffScript
	call CallScript
	scf
	ret

DoPlayerEvent:
	ld a, [wScriptRunning]
	and a
	ret z

	cp PLAYEREVENT_MAPSCRIPT ; run script
	ret z

	cp NUM_PLAYER_EVENTS
	ret nc

	ld c, a
	ld b, 0
	ld hl, PlayerEventScriptPointers
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wScriptBank], a
	ld a, [hli]
	ld [wScriptPos], a
	ld a, [hl]
	ld [wScriptPos + 1], a
	ret

PlayerEventScriptPointers:
; entries correspond to PLAYEREVENT_* constants
	table_width 3, PlayerEventScriptPointers
	dba InvalidEventScript      ; PLAYEREVENT_NONE
	dba SeenByTrainerScript     ; PLAYEREVENT_SEENBYTRAINER
	dba TalkToTrainerScript     ; PLAYEREVENT_TALKTOTRAINER
	dba FindItemInBallScript    ; PLAYEREVENT_ITEMBALL
	dba EdgeWarpScript          ; PLAYEREVENT_CONNECTION
	dba WarpToNewMapScript      ; PLAYEREVENT_WARP
	dba FallIntoMapScript       ; PLAYEREVENT_FALL
	dba OverworldWhiteoutScript ; PLAYEREVENT_WHITEOUT
	dba HatchEggScript          ; PLAYEREVENT_HATCH
	dba ChangeDirectionScript   ; PLAYEREVENT_JOYCHANGEFACING
	dba SeenByTalkerScript      ; PLAYEREVENT_SEENBYTALKER
	dba InvalidEventScript      ; (NUM_PLAYER_EVENTS)
	assert_table_length NUM_PLAYER_EVENTS + 1

InvalidEventScript:
	end

HatchEggScript:
	callasm OverworldHatchEgg
	end

WarpToNewMapScript:
	warpsound
	newloadmap MAPSETUP_DOOR
	end

FallIntoMapScript:
	newloadmap MAPSETUP_FALL
	playsound SFX_KINESIS
	applymovement PLAYER, .SkyfallMovement
	playsound SFX_STRENGTH
	scall LandAfterPitfallScript
	end

.SkyfallMovement:
	skyfall
	step_end

LandAfterPitfallScript:
	earthquake 16
	end

EdgeWarpScript:
	reloadend MAPSETUP_CONNECTION

ChangeDirectionScript:
	deactivatefacing 3
	callasm EnableWildEncounters
	end

INCLUDE "engine/overworld/scripting.asm"

WarpToSpawnPoint::
	ld hl, wStatusFlags2
	res STATUSFLAGS2_SAFARI_GAME_F, [hl]
	res STATUSFLAGS2_BUG_CONTEST_TIMER_F, [hl]
	ret

RunMemScript::
	ldh a, [hCurBoardEvent]
	cp BOARDEVENT_VIEW_MAP_MODE
	ret z ; nc
; If there is no script here, we don't need to be here.
	ld a, [wMapReentryScriptQueueFlag]
	and a
	ret z ; nc
; Execute the script at (wMapReentryScriptBank):(wMapReentryScriptAddress).
	ld hl, wMapReentryScriptAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMapReentryScriptBank]
	call CallScript
	scf
; Clear the buffer for the next script.
	push af
	xor a
	ld hl, wMapReentryScriptQueueFlag
	ld bc, 8
	call ByteFill
	pop af
	ret

LoadMemScript::
; If there's already a script here, don't overwrite.
	ld hl, wMapReentryScriptQueueFlag
	ld a, [hl]
	and a
	ret nz
; Set the flag
	ld [hl], 1
	inc hl
; Load the script pointer b:de into (wMapReentryScriptBank):(wMapReentryScriptAddress)
	ld [hl], b
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	scf
	ret

TryTileCollisionEvent::
	call GetFacingTileCoord
	ld [wFacingTileID], a
	ld c, a
	; CheckFacingTileForStdScript preserves c, and
	; farcall copies c back into a.
	farcall CheckFacingTileForStdScript
	jr c, .done

	; CheckCutTreeTile expects a == [wFacingTileID], which
	; it still is after the previous farcall.
	call CheckCutTreeTile
	jr nz, .whirlpool
	farcall TryCutOW
	jr .done

.whirlpool
	ld a, [wFacingTileID]
	call CheckWhirlpoolTile
	jr nz, .waterfall
	farcall TryWhirlpoolOW
	jr .done

.waterfall
	ld a, [wFacingTileID]
	call CheckWaterfallTile
	jr nz, .headbutt
	farcall TryWaterfallOW
	jr .done

.headbutt
	ld a, [wFacingTileID]
	call CheckHeadbuttTreeTile
	jr nz, .surf
	farcall TryHeadbuttOW
	jr c, .done
	jr .noevent

.surf
	farcall TrySurfOW
	jr nc, .noevent
	jr .done

.noevent
	xor a
	ret

.done
	call PlayClickSFX
	ld a, PLAYEREVENT_MAPSCRIPT
	scf
	ret

RandomEncounter::
; Random encounter

	call CheckWildEncounterCooldown
	jr c, .nope
	call CanEncounterWildMon
	jr nc, .nope
	ld hl, wStatusFlags2
	bit STATUSFLAGS2_BUG_CONTEST_TIMER_F, [hl]
	jr nz, .bug_contest
	farcall TryWildEncounter
	jr nz, .nope
	jr .ok

.bug_contest
	call _TryWildEncounter_BugContest
	jr nc, .nope
	jr .ok_bug_contest

.nope
	ld a, 1
	and a
	ret

.ok
	ld a, BANK(WildBattleScript)
	ld hl, WildBattleScript
	jr .done

.ok_bug_contest
	ld a, BANK(BugCatchingContestBattleScript)
	ld hl, BugCatchingContestBattleScript
	jr .done

.done
	call CallScript
	scf
	ret

WildBattleScript:
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

CanEncounterWildMon::
	ld hl, wStatusFlags
	bit STATUSFLAGS_NO_WILD_ENCOUNTERS_F, [hl]
	jr nz, .no
	ld a, [wEnvironment]
	cp INDOOR_ENVIRONMENT
	jr nc, .ice_check
	farcall CheckGrassCollision
	jr nc, .no

.ice_check
	ld a, [wPlayerTileCollision]
	call CheckIceTile
	jr z, .no
	scf
	ret

.no
	and a
	ret

_TryWildEncounter_BugContest:
	call TryWildEncounter_BugContest
	ret nc
	call ChooseWildEncounter_BugContest
	farcall CheckRepelEffect
	ret

ChooseWildEncounter_BugContest::
; Pick a random mon out of ContestMons.

.loop
	call Random
	cp 100 << 1
	jr nc, .loop
	srl a

	ld hl, ContestMons
	ld de, 4
.CheckMon:
	sub [hl]
	jr c, .GotMon
	add hl, de
	jr .CheckMon

.GotMon:
	inc hl

; Species
	ld a, [hli]
	ld [wTempWildMonSpecies], a

; Min level
	ld a, [hli]
	ld d, a

; Max level
	ld a, [hl]

	sub d
	jr nz, .RandomLevel

; If min and max are the same.
	ld a, d
	jr .GotLevel

.RandomLevel:
; Get a random level between the min and max.
	ld c, a
	inc c
	call Random
	ldh a, [hRandomAdd]
	call SimpleDivide
	add d

.GotLevel:
	ld [wCurPartyLevel], a

	xor a
	ret

TryWildEncounter_BugContest:
	ld a, [wPlayerTileCollision]
	call CheckSuperTallGrassTile
	ld b, 40 percent
	jr z, .ok
	ld b, 20 percent

.ok
	farcall ApplyMusicEffectOnEncounterRate
	farcall ApplyCleanseTagEffectOnEncounterRate
	call Random
	ldh a, [hRandomAdd]
	cp b
	ret c
	ld a, 1
	and a
	ret

INCLUDE "data/wild/bug_contest_mons.asm"

DoBikeStep::
	; If the bike shop owner doesn't have our number, or
	; if we've already gotten the call, we don't have to
	; be here.
	ld hl, wStatusFlags2
	bit STATUSFLAGS2_BIKE_SHOP_CALL_F, [hl]
	jr z, .dont_increment

	; If we're not on the bike, we don't have to be here.
	ld a, [wPlayerState]
	cp PLAYER_BIKE
	jr nz, .dont_increment

	; If we're not in an area of phone service, we don't
	; have to be here.
	call GetMapPhoneService
	and a
	jr nz, .dont_increment

	; Check the bike step count and check whether we've
	; taken 65536 of them yet.
	ld hl, wBikeStep
	ld a, [hli]
	ld d, a
	ld e, [hl]
	cp 255
	jr nz, .increment
	ld a, e
	cp 255
	jr z, .dont_increment

.increment
	inc de
	ld [hl], e
	dec hl
	ld [hl], d

.dont_increment
	xor a
	ret

INCLUDE "engine/overworld/cmd_queue.asm"
