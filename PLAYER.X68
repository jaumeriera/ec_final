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
        MOVE.W #PLYSTARTX, (PLYXPOS)
        MOVE.W #HUBSTNBAL, (PLYNBAL)
        MOVE.B #HUBSTRIDX, (PLYIDX)
        MOVE.W #0, (PLYROUND)
        JSR UPDATE_ANGLE_VALUES
        RTS

; -----------------------------------------------------------------------------
PLRUPD
; INPUT    - NONE (ACCESSES KBDVAL AND KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        MOVE.L D0, -(A7)
        JSR UPDATE_ANGLE_VALUES
        MOVE.B  (SPWON), D0
        CMP.B   #0, D0
        BNE     .END
        MOVE.B (KBDVAL), D0
        ; CHECK IF ANGLE INCREASE
        ROR.B #1, D0
        BCC .CHKUP
        JSR DECREASE_PLY_ANGLE
        JSR UPDATE_ANGLE_VALUES
.CHKUP
        ROR.B #1, D0
        BCC .CHKRT
.CHKRT
        ; CHECK IF ANGLE DECREASE
        ROR.B #1, D0
        BCC .CHKDW
        JSR INCREASE_PLY_ANGLE
        JSR UPDATE_ANGLE_VALUES
.CHKDW
        ROR.B #1, D0
        BCC .SPAWN
.SPAWN  
        ; CHECK IF MUST SPAWN BALLS
        ROR.B #1, D0
        BCC .END
        MOVE.B #1,(SPWON) ; ENABLE SPAWNER                   
.END    MOVE.L (A7)+, D0
        RTS 

; -----------------------------------------------------------------------------
DECREASE_PLY_ANGLE
; INPUT    - NONE (ACCESSES PLYIDX)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        MOVE.L D0, -(A7)
        MOVE.B #HUBANGMIN, D0
        CMP.B (PLYIDX), D0
        BEQ .END
        SUB.B #1, (PLYIDX)
.END    MOVE.L (A7)+, D0
        RTS

; -----------------------------------------------------------------------------
INCREASE_PLY_ANGLE
; INPUT    - NONE (ACCESSES PLYIDX)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        MOVE.L D0, -(A7)
        MOVE.B #HUBANGMAX, D0
        CMP.B (PLYIDX), D0
        BEQ .END
        ADD.B #1, (PLYIDX)
.END    MOVE.L (A7)+, D0
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
        DW_SET_FILL HUBFILCL
        ; SCORE HUB
        DW_POS_CURS #HUBSCORX, #HUBTXTY
        LEA     HUBSCRTXT, A1
        CLR.L   D1
        MOVE.W  (PLYNBAL), D1
        MOVE.B  #17, D0
        TRAP    #15
        DW_POS_CURS #HUBRNDX, #HUBTXTY
        LEA     HUBRNDTXT, A1
        CLR.L   D1
        MOVE.W  (PLYROUND), D1
        MOVE.B  #17, D0
        TRAP    #15
        ; CHECK IF MUST PRINT PLAYER ANGLE
        MOVE.B  (SPWON), D0
        CMP.B   #0, D0
        BNE     .END
        ; MOVE CURSOR TO CURRENT PLAYER POSITION
        DW_POS_CURS (PLYXPOS), #SCRHEIGH
        ; DRAWL LINE TO END POINT
        DW_LINE_XY (PLYENDX), (PLYENDY)
.END
        MOVEM.L (A7)+, D0-D7
        RTS

* -----------------------------------------------------------------------------
UPDATE_ANGLE_VALUES
* UPDATE THE X AND Y PLAYER ANGLE VALUES. UTIL THIS TAKES CURRENT INDEX, GET
* CONTANT ANGLE VALUES AND SET X AND Y ANGLE DEPENDING ON CURRENT INDEX 
* MODIFIES  : PLYXANG, PLYYANG
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
        JSR UPDATE_END_COORDINATES
        RTS

* -----------------------------------------------------------------------------
UPDATE_END_COORDINATES
* UPDATE THE X AND Y END COORDINATES IN ORDER TO DRAW ANGLE 
* MODIFIES  : PLYENDX, PLYENDY
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
* CALCULATE END COORDINATE FOR Y ANGLE COORDINATE AND LENGH. IN ORDER TO
* CALCULATE END POINT, THE FUCNTION CALCULATES THE NUMBER OF INCREMENTS OF Y
* AXIS TO COLLIDE WITH THE TOP. THIS FUNCTION TAKES CARE OF DECIMAL DIVISIONS
* TO SOLVE THIS PROBLES ALWAYS ADD ONE INCREMENT SO THAT MEANS THAT WE ALWAYS
* RETURN A POINT OUT OF THE SCREEN BOUNDS.
*
* PARAMETERS: D0.B: Y ANGLE COORDINATE
*             D1.B: X ANGLE COORDINATE
*             D2.W: LENGHT 
* MODIFIES:   D0, D1, D2, D3
* OUTPU :     D0.W: Y END COORDINATE
*             D1.W: X END COORDINATE
*             D2, D3: CLEANED REGISTERS 
* -----------------------------------------------------------------------------
        CLR.L D3
        MOVE.B D0, D3
        BYTE_ABSOLUTE_VALUE
        DIVU.W D0, D2
        ; CONVERT TO INTEGER
        ANDI.L #$0000FFFF, D2
        ADDI.L #1, D2
        EXT.W D1
        MULS.W D1, D2                   
        MOVE.W D2, D1
        ADD.W (PLYXPOS), D1             ; NOW D1 CONTAINS X COORDINATE
        MOVE.W #0, D0
        EXT.W D3
        ADD.W D3, D0                    ; NOW D0 CONTAINS Y COORDINATE
        CLR.L D2
        CLR.L D3
        RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
