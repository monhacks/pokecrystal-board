; at normal speed:
; each color takes around 3.2 scanlines to fade
; up to 10 (11?) palettes can be faded per frame

FadeStepColorsToBlack:
.loop
	push de
	push bc
	call FadeStepColorToBlack
	pop bc
	pop de
	inc de
	inc de
	dec c
	jr nz, .loop
	ret

FadeStepColorsToDarker:
; decrease rgb channels of a color by 2 points each
; input
;	 c: number of consecutive colors to fade
;   de: pointer to c long array of 2-byte rgb colors to fade
;   hl: pointer to c long array of 2-byte rgb colors with cap values for each channel
.loop
	push hl
	push de
	push bc
	call FadeStepColorToDarker
	pop bc
	pop de
	pop hl
	inc de
	inc de
	inc hl
	inc hl
	dec c
	jr nz, .loop
	ret

FadeStepColorToBlack:
	ld hl, BlackRGB
	; fallthrough

FadeStepColorToDarker:
; decrease rgb channels of a color by 2 points each
; input
;   de: pointer to 2-byte rgb color to fade
;   hl: pointer to 2-byte rgb color with cap values for each channel
	push de

; convert source and cap colors to channels
	push hl
	ld hl, hRGBFadeSourceChannels
	call RGBColorToChannels
	pop de
	ld hl, hRGBFadeCapChannels
	call RGBColorToChannels

; apply fading to source channels accounting for caps
	ldh a, [hRGBFadeCapRChannel]
	ld b, a
	ldh a, [hRGBFadeSourceRChannel]
	sub 2
	jr c, .nok1
	cp b
	jr nc, .ok1
.nok1
	ld a, b
.ok1
	ldh [hRGBFadeSourceRChannel], a
	ldh a, [hRGBFadeCapGChannel]
	ld b, a
	ldh a, [hRGBFadeSourceGChannel]
	sub 2
	jr c, .nok2
	cp b
	jr nc, .ok2
.nok2
	ld a, b
.ok2
	ldh [hRGBFadeSourceGChannel], a
	ldh a, [hRGBFadeCapBChannel]
	ld b, a
	ldh a, [hRGBFadeSourceBChannel]
	sub 2
	jr c, .nok3
	cp b
	jr nc, .ok3
.nok3
	ld a, b
.ok3
	ldh [hRGBFadeSourceBChannel], a

; convert faded source channels to color
	pop de

	ld hl, hRGBFadeSourceChannels
	call RGBChannelsToColor
	ret

FadeStepColorsToWhite:
	ld hl, WhiteRGB
.loop
	push de
	push bc
	call FadeStepColorToWhite
	pop bc
	pop de
	inc de
	inc de
	dec c
	jr nz, .loop
	ret

FadeStepColorsToLighter:
; increase rgb channels of a color by 2 points each
; input
;	 c: number of consecutive colors to fade
;   de: pointer to c long array of 2-byte rgb colors to fade
;   hl: pointer to c long array of 2-byte rgb colors with cap values for each channel
.loop
	push hl
	push de
	push bc
	call FadeStepColorToLighter
	pop bc
	pop de
	pop hl
	inc de
	inc de
	inc hl
	inc hl
	dec c
	jr nz, .loop
	ret

FadeStepColorToWhite:
	ld hl, WhiteRGB
	; fallthrough

FadeStepColorToLighter:
; increase rgb channels of a color by 2 points each
; input
;   de: pointer to 2-byte rgb color to fade
;   hl: pointer to 2-byte rgb color with cap values for each channel
	push de

; convert source and cap colors to channels
	push hl
	ld hl, hRGBFadeSourceChannels
	call RGBColorToChannels
	pop de
	ld hl, hRGBFadeCapChannels
	call RGBColorToChannels

; apply fading to source channels accounting for caps
	ldh a, [hRGBFadeCapRChannel]
	ld b, a
	ldh a, [hRGBFadeSourceRChannel]
	add 2
	cp b
	jr c, .ok1
	ld a, b
.ok1
	ldh [hRGBFadeSourceRChannel], a
	ldh a, [hRGBFadeCapGChannel]
	ld b, a
	ldh a, [hRGBFadeSourceGChannel]
	add 2
	cp b
	jr c, .ok2
	ld a, b
.ok2
	ldh [hRGBFadeSourceGChannel], a
	ldh a, [hRGBFadeCapBChannel]
	ld b, a
	ldh a, [hRGBFadeSourceBChannel]
	add 2
	cp b
	jr c, .ok3
	ld a, b
.ok3
	ldh [hRGBFadeSourceBChannel], a

; convert faded source channels to color
	pop de

	ld hl, hRGBFadeSourceChannels
	call RGBChannelsToColor
	ret

RGBColorToChannels:
; convert 2-byte rgb color at de to rgb channels into hl
; red channel
	ld a, [de]
	ld c, a
	and %00011111
	ld [hli], a
; green channel
	inc de
	ld a, [de]
	and %00000011
	swap a
	srl a
	ld b, a ; 000gg000
	ld a, c
	and %11100000
	swap a
	srl a ; 00000ggg
	add b
	ld [hli], a
; blue channel
	ld a, [de]
	and %01111100
	srl a
	srl a
	ld [hl], a
	ret

RGBChannelsToColor:
; convert rgb channels at hl to 2-byte rgb color into de
; first byte: gggrrrrr
	ld a, [hli]
	ld c, a
	ld a, [hl]
	and %00000111
	swap a
	sla a
	add c
	ld [de], a
; second byte: 0bbbbbgg
	inc de
	ld a, [hli]
	and %00011000
	srl a
	srl a
	srl a
	ld c, a
	ld a, [hl]
	sla a
	sla a
	add c
	ld [de], a
	ret

BlackRGB:
	RGB 00, 00, 00

WhiteRGB:
	RGB 31, 31, 31

_DoRGBFadeEffect::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals2) ; BANK(wOBPals2)
	ldh [rSVBK], a

	ld l, b
	ld h, 0
	add hl, hl
	ld de, RGBFadeEffectJumptable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, .done
	push de
	jp hl

.done:
	pop af
	ldh [rSVBK], a
	ret

RGBFadeEffectJumptable:
; entries correspond to RGBFADE_* constants (see constants/cgb_pal_constants.asm)
	table_width 2, RGBFadeEffectJumptable
	dw _RGBFadeToBlack_6BGP         ; RGBFADE_TO_BLACK_6BGP
	dw _RGBFadeToLighter_6BGP       ; RGBFADE_TO_LIGHTER_6BGP
	dw _RGBFadeToWhite_6BGP_6OBP    ; RGBFADE_TO_WHITE_6BGP_6OBP
	dw _RGBFadeToWhite_8BGP_8OBP    ; RGBFADE_TO_WHITE_8BGP_8OBP
	dw _RGBFadeToBlack_6BGP_1OBP1   ; RGBFADE_TO_BLACK_6BGP_1OBP1
	dw _RGBFadeToLighter_6BGP_1OBP1 ; RGBFADE_TO_LIGHTER_6BGP_1OBP1
	assert_table_length NUM_RGB_FADE_EFFECTS

; in RGBFadeEffectJumptable functions, use DelayFrame calls appropriately
; inside the loop to adjust loop duration, accounting for whether a loop
; takes up less or more than one frame.

_RGBFadeToBlack_6BGP:
	ld c, 32 / 2
.loop
	push bc

; fade BGP to black
	ld de, wBGPals2
	ld c, 6 * NUM_PAL_COLORS
	call FadeStepColorsToBlack

; commit pals
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	call DelayFrame

	pop bc
	dec c
	jr nz, .loop
	ret

_RGBFadeToBlack_6BGP_1OBP1:
	ld c, 32 / 2
.loop
	push bc

; fade BGP to black
	ld de, wBGPals2
	ld c, 6 * NUM_PAL_COLORS
	call FadeStepColorsToBlack

; fade OBP to black
	ld de, wOBPals2 + 1 palettes
	ld c, NUM_PAL_COLORS
	call FadeStepColorsToBlack

; commit pals
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	call DelayFrame

	pop bc
	dec c
	jr nz, .loop
	ret

_RGBFadeToLighter_6BGP:
	ld c, 32 / 2
.loop
	push bc

; fade BGP to lighter (towards wBGPals1)
	ld de, wBGPals2
	ld hl, wBGPals1
	ld c, 6 * NUM_PAL_COLORS
	call FadeStepColorsToLighter

; commit pals
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	call DelayFrame

	pop bc
	dec c
	jr nz, .loop
	ret

_RGBFadeToLighter_6BGP_1OBP1:
	ld c, 32 / 2
.loop
	push bc

; fade BGP to lighter (towards wBGPals1)
	ld de, wBGPals2
	ld hl, wBGPals1
	ld c, 6 * NUM_PAL_COLORS
	call FadeStepColorsToLighter

; fade OBP to lighter (towards wOBPals1)
	ld de, wOBPals2 + 1 palettes
	ld hl, wOBPals1 + 1 palettes
	ld c, NUM_PAL_COLORS
	call FadeStepColorsToLighter

; commit pals
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	call DelayFrame

	pop bc
	dec c
	jr nz, .loop
	ret

_RGBFadeToWhite_6BGP_6OBP:
	ld c, 32 / 2
.loop
	push bc

; fade BGP to white
	ld de, wBGPals2
	ld c, 6 * NUM_PAL_COLORS
	call FadeStepColorsToWhite

; fade OBP to white
	ld de, wOBPals2
	ld c, 6 * NUM_PAL_COLORS
	call FadeStepColorsToWhite

; commit pals
	ld a, TRUE
	ldh [hCGBPalUpdate], a

	pop bc
	dec c
	jr nz, .loop
	ret

_RGBFadeToWhite_8BGP_8OBP:
	ld c, 32 / 2
.loop
	push bc

; fade BGP to white
	ld de, wBGPals2
	ld c, 8 * NUM_PAL_COLORS
	call FadeStepColorsToWhite

; commit pals
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	call DelayFrame

; fade OBP to white
	ld de, wOBPals2
	ld c, 8 * NUM_PAL_COLORS
	call FadeStepColorsToWhite

; commit pals and apply delay
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ld c, 2
	call DelayFrames

	pop bc
	dec c
	jr nz, .loop
	ret
