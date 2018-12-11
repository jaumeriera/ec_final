; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS SPACE STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
;STAGOVR     EQU     2                       ; GAME OVER STATE
;STASELB     EQU     3                       ; SELECT BALL STATE

; --- AGENT TYPES -------------------------------------------------------------

BLLTYPE     EQU     1                       ; BALL TYPE
SQRTYPE     EQU     2                       ; SQUARE TYPE
BONTYPE     EQU     3                       ; BONUS TYPE +1 TO NUM BALLS
HUBTYPE     EQU     4                       ; HUB TYPE

; --- GENERIC BALL CONSTANTS -------------------------------------------------

GENBLSPD    EQU     10                      ; GENERIC BALL SPEED IN PIXELS
GENCOLOR    EQU     $000000FF               ; GENERIC BALL COLOR

; --- SMALL BALL CONSTANTS ---------------------------------------------------

SMLRADI     EQU     5                       ; RADIOUS OF SMALL BALL

; --- NORMAL BALL CONSTANTS --------------------------------------------------

NORRADI     EQU     10                      ; RADIOUS OF NORMAL BALL

; --- BIG BALL CONSTANTS -----------------------------------------------------

BIGRADI     EQU     15                      ; RADIOUS OF BIG BALL

; --- SQUARE CONSTANTS -------------------------------------------------------

SQRSIDEL    EQU     80                      ; SQUARE SIDE
SQRFILLC    EQU     $FFFFFFFF               ; SQUARE FILL COLOR
SQRLINEC    EQU     $00000010               ; SQUARE BORDER LINE COLOR
SQRTEXTX    EQU     5                       ; SQUARE COUNTER DISPLAY X COORD
SQRTEXTY    EQU     5                       ; SQUARE COUNTER DISPLAY Y COORD
SQRTEXTC    EQU     $00FFFFFF               ; SQUARE COUNTER DISPLAY COLOR

; --- GAME HUB CONSTANTS -----------------------------------------------------

HUBCOLOR    EQU     $00FFFFFF               ; HUB FONT COLOR
HUBSCORX    EQU     2                       ; HUB SCORE X COORDINATE
HUBSCORY    EQU     1                       ; HUB SCORE Y COORDINATE
HUBFLRYH    EQU     SCRHEIGH                ; HUB FLOOR LINE Y COORDINATE
; Angle constants:
; X = less significative byte
; Y = most significative byte
HUBANG      DC.W    $F8FF , $F9FE , $FAFD , $FBFC , $FCFB , $FDFA , $FEF9
            DC.W    $FFF8 , $F700 , $01F8 , $02F9 , $03FA , $04FB , $05FC
            DC.W    $06FD , $07FE , $08FF


HUBSTRIDX   EQU     8                       ; START PLAYER INDEX
HUBSTNBAL   EQU     1                       ; GENERIC NUM BALLS START
HUBSCRTXT   DC.B    'SCORE: ',0             ; GENERIC SCORE TEXT

; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     35                      ; TITLE X COORDINATE
INTTITY     EQU     15                      ; TITLE Y COORDINATE
INTTITC     EQU     $000000FF               ; TITLE COLOR
INTPRSX     EQU     31                      ; PRESS SPACE X COORDINATE
INTPRSY     EQU     20                      ; PRESS SPACE Y COORDINATE
INTPRSC     EQU     $00FFFFFF               ; PRESS SPACE COLOR

; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     35                      ; TITLE X COORDINATE
GOVSTRY     EQU     15                      ; TITLE Y COORDINATE
GOVSTRC     EQU     $00FFFFFF               ; TITLE COLOR

; --- PLAYER CONSTANTS --------------------------------------------------------


; --- SELECT BALL STATE CONSTANTS ---------------------------------------------

; TODO
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
