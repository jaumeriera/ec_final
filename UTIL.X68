; =============================================================================
; UTILITY MACROS
; =============================================================================

; =============================================================================
; SCREEN MACROS
; =============================================================================
* -----------------------------------------------------------------------------
SC_ENABLE_DB    MACRO
* Enable double buffer
* Modifies  : D0, D1
* -----------------------------------------------------------------------------
        move.b  #17, D1
        move.b  #92, D0
        trap    #15 
        ENDM

* -----------------------------------------------------------------------------
SC_SWAP_DB      MACRO
* Repaint screen. Copies off screen buffer to vsible screen
* Modifies  : D0
* -----------------------------------------------------------------------------
        move.b  #94, D0
        trap    #15 
        ENDM
        
*------------------------------------------------------------------------------
SC_SET_RES      MACRO
* Macro to set screen resolution.
* Parameters: \1: Width (pixels)
*             \2: Height (pixels)
* Modifies  : D0, D1
*------------------------------------------------------------------------------
        move.b  #33, D0
        move.l  #\1*$10000+\2, D1
        trap    #15
        ENDM
        
*------------------------------------------------------------------------------
SC_SET_WINDOWED MACRO
* Macro to set windowed mode
* Modifies  : D0, D1
*------------------------------------------------------------------------------
        move.b  #33, D0
        move.l  #1, D1
        trap    #15
        ENDM
        
*------------------------------------------------------------------------------
SC_CLEAR        MACRO
* Macro to clear screen
* Modifies  : D0, D1
*------------------------------------------------------------------------------
        move.w  #$FF00, D1
        move.b  #11, D0
        trap    #15
        ENDM

; =============================================================================
; DRAW MACROS
; =============================================================================
* -----------------------------------------------------------------------------
DW_SET_PEN      MACRO
* Sets the drawing pen color
* Parameters: \1 Pen color in format $00BBGGRR
* -----------------------------------------------------------------------------
        move.l  #\1, D1
        move.b  #80, D0
        trap    #15
        ENDM

* -----------------------------------------------------------------------------
DW_SET_FILL     MACRO
* Sets the drawing fill color
* Parameters: \1 fill color in format $00BBGGRR
* ----------------------------------------------------------
        move.l  #\1, D1
        move.b  #81, D0
        trap    #15
        ENDM
        
* -----------------------------------------------------------------------------
DW_POS_TEXT     MACRO
* Wrapper to text positioning from TRAP 15
* Parameters: \1: X position, 
*             \2: Y position
* Modifies  : D0,D1
* -----------------------------------------------------------------------------
        MOVE.W  #\1<<8|\2, D1
        MOVE.B  #11, D0
        TRAP    #15
        ENDM

* -----------------------------------------------------------------------------
DW_POS_CURS     MACRO
* Wrapper to cursor positioning from TRAP 15
* Parameters: \1: X position, 
*             \2: Y position
* Modifies  : D0,D1,D2
* -----------------------------------------------------------------------------
        MOVE.W  #86, D0
        MOVE.W  \1, D1
        MOVE.W  \2, D2
        TRAP    #15
        ENDM

* -----------------------------------------------------------------------------
DW_LINE_XY     MACRO
* Wrapper to cursor positioning from TRAP 15
* Parameters: \1: X position, 
*             \2: Y position
* Modifies  : D0,D1,D2
* -----------------------------------------------------------------------------
        MOVE.W #85, D0
        MOVE.W \1, D1
        MOVE.W \2, D2
        TRAP #15
        ENDM

; =============================================================================
; INTERRUPTION MACROS
; =============================================================================

* -----------------------------------------------------------------------------
INT_SET_LEVEL   MACRO
* Set interruption bits on SR in order to set the interruption level
* Parameters: \1: interruption level accepted, 
* Modifies  : D0
* -----------------------------------------------------------------------------
        MOVE.W SR, D0
        ANDI.W #$F8FF, D0
        ORI.W   #(\1<<8)&$700, D0
        MOVE.W D0, SR
        ENDM

* -----------------------------------------------------------------------------
INT_DIS_AUTO_IRQ   MACRO
* Disable all auto interruptions 
* Modifies  : D0, D2
* -----------------------------------------------------------------------------
        MOVE.B  #00,D2
        MOVE.B  #32,D0
        TRAP    #15
        ENDM

* -----------------------------------------------------------------------------
INT_ENA_AUTO_IRQ   MACRO
* Enable all auto interruptions 
* Modifies  : D0, D1
* -----------------------------------------------------------------------------
        MOVE.B  #6,D1
        MOVE.B  #32,D0
        TRAP    #15
        ENDM
; =============================================================================
; KEYBOARD MACROS
; =============================================================================

* -----------------------------------------------------------------------------
KBD_LOAD_KEYS   MACRO
* Return current state up to 4 specific keys or return key scan codes
* Parameters: \1: key 1,
*             \2: key 2,
*             \3: key 3,
*             \4: key 4
* Modifies  : D0, D1
* -----------------------------------------------------------------------------
        MOVE.W #19, D0
        MOVE.L #\1<<24, D1
        ADD.L  #\2<<16, D1
        ADD.L  #\3<<8, D1
        ADD.L  #\4, D1
        TRAP #15
        ENDM

* -----------------------------------------------------------------------------
KBD_UPDT_VARS   MACRO
* Update KBDVAR KBDEDGE depending on register D1 and mask provided
* Parameters: \1: position of key to check,
*             \2: key mask,
* Modifies  : D0, D1, KBDVAL, KBDEDGE
* -----------------------------------------------------------------------------
        BTST.L  #\1 ,D1
        IF <NE> THEN
        ORI.B   #\2, (KBDVAL)
        BTST.B  #\2, (KBDEDGE)
        IF <EQ> THEN
        ORI.B   #\2, (KBDEDGE)
        ENDI            
        ENDI
        IF <EQ> THEN
        MOVE.B #\2, D0
        NOT.B D0
        AND.B   D0, (KBDEDGE)
        AND.B   D0, (KBDVAL)
        ENDI
        ENDM

; =============================================================================
; COLLISION UTILS
; =============================================================================

* -----------------------------------------------------------------------------
COLL_BALL_HITBOX   MACRO
* Calculate the hitbox of the ball
* Parameters : \1: X center coordinate,
*              \2: Y center coordinate
* Modifies  : D1, D2, D3, D4
* -----------------------------------------------------------------------------
        MOVE.W  \1, D1
        SUB.W   #NORRADI/2, D1
        MOVE.W  \2, D2
        SUB.W   #NORRADI/2, D2
        MOVE.W  D1, D3
        MOVE.W  D2, D4
        ADD.W   #NORRADI, D3
        ADD.W   #NORRADI, D4
        ENDM

* -----------------------------------------------------------------------------
COLL_SQR_HITBOX   MACRO
* Calculate the hitbox of the square
* Parameters : \1: square row,
*              \2: sqaure column
* Modifies  : D1, D2, D3, D4
* -----------------------------------------------------------------------------
        MOVE.W  \1, D2
        MULU.W  #SQRSIDEL, D2
        MOVE.W  \2, D1
        MULU.W  #SQRSIDEL, D1
        MOVE.W  D2, D4
        ADD.W   #SQRSIDEL, D4
        MOVE.W  D1, D3
        ADD.W   #SQRSIDEL, D3
        ENDM

* -----------------------------------------------------------------------------
COLL_BON_HITBOX   MACRO
* Calculate the hitbox of the bonus
* Parameters : \1: square row,
*              \2: sqaure column
*              \3: side lenght
* Modifies  : D1, D2, D3, D4
* -----------------------------------------------------------------------------
        MOVE.W  \1, D2
        MULU.W  \3, D2
        MOVE.W  \2, D1
        MULU.W  \3, D1
        MOVE.W  D2, D4
        ADD.W   \3, D4
        MOVE.W  D1, D3
        ADD.W   \3, D3
        ENDM

; =============================================================================
; UTILITIES
; =============================================================================

* -----------------------------------------------------------------------------
BYTE_ABSOLUTE_VALUE   MACRO
* Calculate the absolute value of WORD
* Parameters : D0
* Modifies  : D0
* -----------------------------------------------------------------------------
        TST.B D0
        BPL .END
        NEG.B D0
.END:
        ENDM

; -----------------------------------------------------------------------------
UTLINIT
; INITIALIZES UTILITY CODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (UTLRNDIX)
            RTS

; -----------------------------------------------------------------------------
UTLRAND
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    - NONE
; OUTPUT   - D0.L RANDOM VALUE (ONLY BYTE)
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RANDVEC,A0
            CLR.L   D0
            MOVE.B  (UTLRNDIX),D0
            MOVE.B  (A0,D0.L),D0
            ADDQ.B  #1,(UTLRNDIX)
            MOVE.L  (A7)+,A0
            RTS

.RANDVEC    DC.B    162, 238, 154, 12 , 245, 36 , 32 , 103
            DC.B    42 , 163, 81 , 38 , 224, 172, 19 , 69
            DC.B    117, 81 , 202, 253, 51 , 235, 108, 154
            DC.B    96 , 204, 231, 184, 154, 235, 34 , 203
            DC.B    29 , 118, 181, 149, 176, 137, 62 , 108
            DC.B    57 , 21 , 72 , 201, 110, 202, 159, 41
            DC.B    67 , 231, 226, 124, 55 , 37 , 84 , 62
            DC.B    233, 148, 206, 233, 228, 82 , 243, 78
            DC.B    55 , 109, 154, 132, 162, 40 , 30 , 39
            DC.B    25 , 226, 198, 119, 128, 212, 232, 225
            DC.B    10 , 90 , 50 , 103, 51 , 194, 222, 40
            DC.B    89 , 128, 220, 14 , 87 , 252, 243, 252
            DC.B    138, 171, 188, 247, 7  , 77 , 29 , 234
            DC.B    239, 213, 119, 110, 30 , 187, 131, 23
            DC.B    214, 224, 42 , 143, 189, 40 , 212, 130
            DC.B    19 , 79 , 102, 236, 10 , 100, 122, 188
            DC.B    86 , 82 , 154, 22 , 155, 144, 7  , 199
            DC.B    6  , 138, 164, 247, 1  , 218, 166, 82
            DC.B    242, 231, 119, 40 , 177, 118, 220, 102
            DC.B    164, 66 , 227, 129, 177, 103, 165, 108
            DC.B    191, 206, 250, 22 , 191, 56 , 30 , 161
            DC.B    209, 139, 80 , 12 , 95 , 73 , 168, 56
            DC.B    222, 76 , 20 , 162, 64 , 220, 93 , 12
            DC.B    182, 155, 10 , 56 , 93 , 171, 89 , 6
            DC.B    226, 27 , 221, 117, 21 , 130, 101, 18
            DC.B    138, 38 , 81 , 48 , 159, 71 , 57 , 21
            DC.B    30 , 138, 187, 113, 198, 110, 185, 152
            DC.B    159, 71 , 229, 52 , 148, 39 , 77 , 6
            DC.B    125, 6  , 214, 186, 48 , 15 , 212, 22
            DC.B    236, 127, 126, 3  , 207, 45 , 193, 2
            DC.B    148, 91 , 35 , 242, 139, 205, 248, 237
            DC.B    116, 51 , 236, 185, 15 , 213, 221, 6
            


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
