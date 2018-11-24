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
* Wrapper to tect positioning from TRAP 15
* Parameters: \1: X position, 
*             \2: Y position
* Modifies  : D0,D1
* -----------------------------------------------------------------------------
            MOVE.W  #\1<<8|\2, D1
            MOVE.B  #11, D0
            TRAP    #15
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
            MOVE.B #\2, D0
            NOT.B D0
            IF <EQ> THEN
            AND.B   D0, (KBDEDGE)
            AND.B   D0, (KBDVAL)
            ENDI
            ENDM

            


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
