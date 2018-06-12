;===================================================================================================
; Written By: Oded Cnaan (oded.8bit@gmail.com)
; Site: http://odedc.net 
; Licence: None
; Package: XXX
; Date: 12-06-2018
; File: t.asm
;
; Description: 
;===================================================================================================
LOCALS @@

.486
IDEAL
MODEL small
STACK 256

; Global Definitions
TRUE  = 1
FALSE = 0
NULL  = 0

; Inlude bmp implementation
include "bmp.asm"

DATASEG

    _background     Bitmap        {ImagePath="bg.bmp"}
    ;_otherImage     Bitmap        {ImagePath="images\\other.bmp"}

CODESEG

;=+=+=+=+=+=+=+=+=+=+=+=+=+= GRAPHIC MODES +=+=+=+=+=+=+=+=+=+=+=+=+=+=+

;----------------------------------------------------------
; Sets the MS-DOS BIOS Video Mode
;----------------------------------------------------------
MACRO gr_set_video_mode mode
  mov al, mode
  mov ah, 0
  int 10h
ENDM
;----------------------------------------------------------
; Explicitly sets the MS-DOS BIOS Video Mode
; to 80x25 Monochrome text 
;----------------------------------------------------------
MACRO gr_set_video_mode_txt 
  gr_set_video_mode 03h
ENDM
;----------------------------------------------------------
; Explicitly sets the MS-DOS BIOS Video Mode
; to 320x200 256 color graphics
;----------------------------------------------------------
MACRO gr_set_video_mode_vga 
  gr_set_video_mode 13h
ENDM

;=+=+=+=+=+=+=+=+=+=+=+=+=+= KEY PRESS +=+=+=+=+=+=+=+=+=+=+=+=+=+=+

;------------------------------------------------------------------
; WaitForKeypress: Checks for a keypress; Sets ZF if no keypress 
; is available Otherwise returns it's scan code into AH and it's 
; ASCII into al Removes the charecter from the Type Ahead Buffer 
; return: AX  = _Key
;------------------------------------------------------------------
PROC WaitForKeypress
    push bp
	mov bp,sp

@@check_keypress:
    mov ah, 1     ; Checks if there is a character in the type ahead buffer
    int 16h       ; MS-DOS BIOS Keyboard Services Interrupt
    jz @@check_keypress_empty
    mov ah, 0
    int 16h
    jmp @@exit
@@check_keypress_empty:
    cmp ax, ax    ; Explicitly sets the ZF
    jz   @@check_keypress

@@exit:
    mov sp,bp
    pop bp
    ret
ENDP WaitForKeypress


;=+=+=+=+=+=+=+=+=+=+=+=+=+= PROGRAM +=+=+=+=+=+=+=+=+=+=+=+=+=+=+

start:
  mov ax, @data
  mov ds,ax

  gr_set_video_mode_vga

  mov si, offset _background
  Display_BMP si, 10,30

  call WaitForKeypress

  gr_set_video_mode_txt

exit:
  mov ah, 4ch
  mov al, 0
  int 21h
END start
CODSEG ends

