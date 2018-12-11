; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        MOVE.W #SCRWIDTH/2, (PLYXPOS)
        MOVE.W #HUBSTNBAL, (PLYNBAL)
        MOVE.B #HUBSTRIDX, (PLYIDX)
        JSR UPDATE_ANGLE_VALUES
        JSR UPDATE_END_COORDINATES
        RTS

; -----------------------------------------------------------------------------
PLRUPD
; INPUT    - NONE (ACCESSES KBDVAL AND KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        ; TODO
        MOVE.W D0, D0
        RTS 

; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER ANGLE AND THE SCORE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        MOVEM.L D0-D7, -(A7)
        ; SET COLORS
        DW_SET_PEN HUBCOLOR
        ; MOVE CURSOR TO CURRENT PLAYER POSITION
        DW_POS_CURS (PLYXPOS), #SCRHEIGH
        ; DRAWL LINE TO END POINT
        DW_LINE_XY (PLYENDX), (PLYENDY)
        ; SCORE HUB
        DW_POS_CURS #HUBSCORX, #HUBSCORY
        LEA     HUBSCRTXT,A1
        CLR.L   D1
        MOVE.W  (PLYNBAL),D1
        MOVE.B  #17,D0
        TRAP    #15
        MOVEM.L (A7)+, D0-D7
        RTS

* -----------------------------------------------------------------------------
UPDATE_ANGLE_VALUES
* Update the x and y player angle values. util This takes current index, get
* contant angle values and set x and y angle depending on current index 
* Modifies  : PLYXANG, PLYYANG
* -----------------------------------------------------------------------------
        MOVEM.L A0/D0-D1, -(A7)
        LEA HUBANG, A0
        CLR.L D0
        MOVE.B (PLYIDX), D0
        LSL.W #1, D0
        MOVE.W (A0, D0.L), D0
        MOVE.W D0, D1
        ANDI.W #$00FF, D0
        MOVE.B D0, (PLYXANG)
        LSR.W #8, D1
        MOVE.B D1, (PLYYANG)
        MOVEM.L (A7)+, A0/D0-D1
        RTS

* -----------------------------------------------------------------------------
UPDATE_END_COORDINATES
* Update the x and y end coordinates in order to draw angle 
* Modifies  : PLYENDX, PLYENDY
* -----------------------------------------------------------------------------
        MOVEM.L D0-D3, -(A7)
        CLR.L D0
        CLR.L D1
        MOVE.B (PLYYANG), D0
        MOVE.B (PLYXANG), D1
        MOVE.W #SCRHEIGH, D2
        JSR CALC_END_POINT
        MOVE.W D0, (PLYENDY)
        MOVE.W D1, (PLYENDX)
        MOVEM.L (A7)+, D0-D3
        RTS

* -----------------------------------------------------------------------------
CALC_END_POINT
* Calculate end coordinate for y angle coordinate and lengh. In order to
* calculate end point, the fucntion calculates the number of increments of Y
* axis to collide with the top. this function takes care of decimal divisions
* to solve this probles always add one increment so that means that we always
* return a point out of the screen bounds.
*
* Parameters: D0.B: Y angle coordinate
*             D1.B: X angle coordinate
*             D2.W: Lenght 
* Modifies:   D0, D1, D2, D3
* Outpu :     D0.W: Y end coordinate
*             D1.W: X end coordinate
*             D2, D3: cleaned registers
* -----------------------------------------------------------------------------
        CLR.L D3
        MOVE.B D0, D3
        BYTE_ABSOLUTE_VALUE
        DIVU.W D0, D2
        ; Convert to integer
        ANDI.L #$0000FFFF, D2
        ADDI.L #1, D2
        EXT.W D1
        MULS.W D1, D2                   
        MOVE.W D2, D1                   ; now D1 contains X coordinate
        MOVE.W #0, D0
        EXT.W D3
        ADD.W D3, D0                    ; now D0 contains Y coordinate
        CLR.L D2
        CLR.L D3
        RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
