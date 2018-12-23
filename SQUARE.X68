; =============================================================================
; SQUARE MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 ROW NUMBER
; +2 COLUMN NUMBER
; +4 CURRENT HIT RESISTANCE
; =============================================================================

; -----------------------------------------------------------------------------
SQRINIT
; INITALIZES A SQUARE
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
;          - D1 ROW NUMBER
;          - D2 COLUMN NUMBER
;          - D3 CURRENT HIT RESISTANCE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
    MOVE.W  D1, (A0)
    MOVE.W  D2, 2(A0)
    MOVE.W  D3, 4(A0)
    RTS

; -----------------------------------------------------------------------------
SQRNWRND
; ADVANCE ROUND CONSISTS ON INCREMENT NUMBER OF ROUND, ADVANCE ONE ROW ALL
; THE SQUARES AND SPAWN A NEW LINE OF SQUARES. ALSO CHECK IF GAME END
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    JSR     SQRUPDRW
    JSR     SQRSPW
    ADD.W   #1, (PLYROUND)
    RTS

; -----------------------------------------------------------------------------
SQRSPW
; SPAWN A NEW LINE OF SQUARES
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVEM.L A0-A1/D0-D7,-(A7)
    MOVE.W  #SCRWIDTH, D2
    DIVU    #SQRSIDEL, D2
    JSR     UTLRAND
    MOVE.L  D0, D6
.LOOP                               ; LOOP WHILE CAN CREATE SQUARES
    SUB.W   #1, D2
    ROR.B   #1, D6
    BCC     .ISLAST
    MOVE.W  #SQRTYPE,D0
    MOVE.W  #0,D1
    MOVE.W  (PLYROUND), D3
    LEA     SQRINIT,A1
    LEA     SQRUPD,A2
    LEA     SQRPLOT,A3
    JSR     AGLADD
.ISLAST
    CMP.W   #0, D2
    BNE     .LOOP

    MOVEM.L (A7)+,A0-A1/D0-D7
    RTS

; -----------------------------------------------------------------------------
SQRUPDRW
; UPDATES ALL SQUARE ROWS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVEM.L A0-A1/D0-D7,-(A7)
    MOVE.W  #SQRTYPE,D0             ; LOOP THROUGH ALL SQUARES
    JSR     DMMFRSTO
.LOOP       
    CMP.L   #0,A0
    BEQ     .END
    ADD.W   #1, (A0)
    MOVE.W  (A0), D1                ; CHECK IF GAME OVER
    MULU.W  #SQRSIDEL, D1
    CMP.W   #SCRHEIGH, D1
    BLT     .CONTINUE
    MOVE.W  #2, D0
    MOVE.W  #STAGOVR, (STANEXT)
    BRA     .END
.CONTINUE
    JSR     DMMNEXTO
    BRA     .LOOP
.END        
    MOVEM.L (A7)+,A0-A1/D0-D7
    RTS

; -----------------------------------------------------------------------------
SQRUPD
; UPDATES A SQUARE
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    RTS

; -----------------------------------------------------------------------------
SQRPLOT
; PLOT SQUARE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVEM.L A0-A1/D0-D7,-(A7)
    DW_SET_PEN  SQRLINEC
    DW_SET_FILL SQRFILLC
    MOVE.W  (A0), D2
    MULU.W  #SQRSIDEL, D2
    MOVE.W  2(A0), D1
    MULU.W  #SQRSIDEL, D1
    MOVE.W  D2, D4
    ADD.W   #SQRSIDEL, D4
    MOVE.W  D1, D3
    ADD.W   #SQRSIDEL, D3
    MOVE.W  #87, D0
    TRAP    #15
    MOVEM.L (A7)+,A0-A1/D0-D7
    RTS