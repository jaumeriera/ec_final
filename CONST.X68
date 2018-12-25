; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS SPACE STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAGOVR     EQU     2                       ; GAME OVER STATE
;STASELB     EQU     3                       ; SELECT BALL STATE

; --- AGENT TYPES -------------------------------------------------------------

BALTYPE     EQU     1                       ; BALL TYPE
SQRTYPE     EQU     2                       ; SQUARE TYPE
BONTYPE     EQU     3                       ; BONUS TYPE +1 TO NUM BALLS
HUBTYPE     EQU     4                       ; HUB TYPE

; --- GENERIC BALL CONSTANTS -------------------------------------------------

GENBLSPD    EQU     10                      ; GENERIC BALL SPEED IN PIXELS
BALPENCL    EQU     $00FFFFFF               ; BALL PEN COLOR
BALFILCL    EQU     $0000FF00               ; BALL FIL COLOR
BALZONE     EQU     5                       ; ZONE WHERE BOUNCE ON X AXIS

; --- SMALL BALL CONSTANTS ---------------------------------------------------

SMLRADI     EQU     10                       ; RADIOUS OF SMALL BALL

; --- NORMAL BALL CONSTANTS --------------------------------------------------

NORRADI     EQU     20                      ; RADIOUS OF NORMAL BALL

; --- BIG BALL CONSTANTS -----------------------------------------------------

BIGRADI     EQU     30                      ; RADIOUS OF BIG BALL

; --- SQUARE CONSTANTS -------------------------------------------------------

SQRSIDEL    EQU     80                      ; SQUARE SIDE
SQRFILLC    EQU     $000000FF               ; SQUARE FILL COLOR
SQRLINEC    EQU     $00FFF000               ; SQUARE BORDER LINE COLOR
SQRTEXTX    EQU     5                       ; SQUARE COUNTER DISPLAY X COORD
SQRTEXTY    EQU     5                       ; SQUARE COUNTER DISPLAY Y COORD
SQRTEXTC    EQU     $00FFFFFF               ; SQUARE COUNTER DISPLAY COLOR

; --- GAME HUB CONSTANTS -----------------------------------------------------

HUBCOLOR    EQU     $00FFFFFF               ; HUB FONT COLOR
HUBFILCL    EQU     $00000000               ; HUB FILL COLOR
HUBSCORX    EQU     2                       ; HUB SCORE X COORDINATE
HUBRNDX     EQU     20                      ; HUB ROUND X COORDINATE
HUBTXTY     EQU     1                       ; HUB SCORE Y COORDINATE
HUBFLRYH    EQU     SCRHEIGH                ; HUB FLOOR LINE Y COORDINATE
; Angle constants:
; X = less significative byte
; Y = most significative byte
HUBANG      DC.W    $FFF8, $FEF9, $FDFA, $FCFB, $FBFC, $FAFD, $F9FE, $F8FF
            DC.W    $F700, $F801, $F902, $FA03, $FB04, $FC05, $FD06, $FE07
            DC.W    $FF08

HUBSTRIDX   EQU     8                       ; START PLAYER INDEX
HUBANGMAX   EQU     16                      ; MAX INDEX ANGLE ARRAY
HUBANGMIN   EQU     0                       ; MIN INDEX ANGLE ARRAY
HUBSTNBAL   EQU     1                       ; GENERIC NUM BALLS START
HUBSCRTXT   DC.B    'SCORE: ',0             ; GENERIC SCORE TEXT
HUBRNDTXT   DC.B    'ROUND: ',0            ; GENERIC ROUND TEXT
PLYSTARTX   EQU     SCRWIDTH/2

; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     35                      ; TITLE X COORDINATE
INTTITY     EQU     15                      ; TITLE Y COORDINATE
INTTITC     EQU     $000000FF               ; TITLE COLOR
INTPRSX     EQU     30                      ; PRESS "S" KEY X COORDINATE
INTPRSY     EQU     20                      ; PRESS "S" KEY Y COORDINATE
INTPRSC     EQU     $00FFFFFF               ; PRESS SPACE COLOR

; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     35                      ; TITLE X COORDINATE
GOVSTRY     EQU     15                      ; TITLE Y COORDINATE
GOVSTRC     EQU     $00FFFFFF               ; TITLE COLOR

; --- SPAWNER CONSTANTS -------------------------------------------------------

SPWCYCLE    EQU     16                      ; NUMBER OF CICLES BETWEEN SHOTS

; --- BONUS CONSTANTS ---------------------------------------------------------

BONSIDEL    EQU     SQRSIDEL                ; SIDE OF BONUS
BONCOLOR    EQU     $0000FFFF               ; COLOR OF BONUS
BONPENCL    EQU     $00000000               ; PENCIN OF BONUS
BONTHICK    EQU     10                      ; THICKNESS OF BONUS SYMBOL

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
