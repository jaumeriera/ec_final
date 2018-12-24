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
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
    MOVE.W  D1, (A0)
    MOVE.W  D2, 2(A0)
    MOVE.W  (PLYROUND), 4(A0)
    RTS

; -----------------------------------------------------------------------------
SQRNWRND
; ADVANCE ROUND CONSISTS ON INCREMENT NUMBER OF ROUND, ADVANCE ONE ROW ALL
; THE SQUARES AND SPAWN A NEW LINE OF SQUARES. ALSO CHECK IF GAME END
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    ADD.W   #1, (PLYROUND)
    JSR     SQRUPDRW
    JSR     SQRSPW
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
    ADD.W   #1, 8(A0)
    MOVE.W  8(A0), D1               ; CHECK IF GAME OVER
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
    ; CHECK IF BALL COLLIDES WITH SQUARE
    MOVEM.L A0-A1/D0-D7,-(A7)
    MOVE.L  A0, A1
    MOVE.W  #BALTYPE, D0            ; LOOP THROUGH ALL BALLS
    JSR     DMMFRSTO
.LOOP
    CMP.L   #0, A0
    BEQ     .END
    ; GET BALL HITBOX COORDINATES
    COLL_BALL_HITBOX 8(A0), 10(A0)
    MOVE.W  D1, (AUXVARONE)
    MOVE.W  D2, D5
    MOVE.W  D3, D6
    MOVE.W  D4, D7
    ; GET SQAURE HITBOX COORDINATES
    COLL_SQR_HITBOX  (A1), 2(A1)
    MOVE.W  D1, D0
    MOVE.W  D2, D1
    MOVE.W  D3, D2
    MOVE.W  D4, D3
    MOVE.W  (AUXVARONE), D4
    ; IN THIS MOMENT WE HAVE BOTH HITBOX CALCULATED. FROM D0 TO D3 SQAURE
    ; HITBOX AND FROM D4 TO D7 BALL HITBOX. NOW WE MUST CHECK IF THERE
    ; ARE COLLISION
    CMP.W   D5, D3
    BLT     .NEXT
    CMP.W   D7, D1
    BGT     .NEXT
    CMP.W   D4, D2
    BLT     .NEXT
    CMP.W   D6, D0
    BGT     .NEXT
    SUB.W   #1, 4(A1)           ; COLLISION
    CMP.W   #0, 4(A1)
    BEQ     .KILL
.NEXT
    MOVE.W  #BALTYPE, D0
    JSR     DMMNEXTO
    BRA     .LOOP
.KILL
    MOVE.L  A1, A0
    JSR     AGLKILL
.END
    MOVEM.L (A7)+,A0-A1/D0-D7 
    RTS

; -----------------------------------------------------------------------------
SQRPLOT
; PLOT SQUARE
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVEM.L A0-A1/D0-D7,-(A7)
    ; DRAW SQAURE
    DW_SET_PEN  SQRLINEC
    DW_SET_FILL SQRFILLC
    COLL_SQR_HITBOX (A0), 2(A0)
    MOVE.W  #87, D0
    TRAP    #15
    ; DRAW COLLISION RESISTANCE
    DW_SET_PEN  SQRTEXTC
    JSR SQR_CALC_CENTER
    LSL.W   #8, D1
    MOVE.B  D2, D1
    MOVE.B  #11, D0
    TRAP    #15
    CLR.L   D1
    MOVE.W  4(A0), D1
    MOVE.B  #17, D0
    TRAP    #15
    MOVEM.L (A7)+,A0-A1/D0-D7
    RTS

; -----------------------------------------------------------------------------
SQR_CALC_CENTER
; CALCULATE THE CENTER OF THE SQUARE
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - D1 CHARACTER ROW
;          - D2 CHATACTER COL
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVEM.L D3-D4,-(A7)
    ; CALC COLUMN OF SQUARE IN ORDER TO PRINT TEXT
    MOVE.W  #SCRWIDTH, D3
    DIVU.W  #SQRSIDEL, D3
    MOVE.W  #SCRCOL, D2
    DIVU.W  D3, D2
    MOVE.W  D2, D4                      
    MULU.W  2(A0), D2
    DIVU.W  #2, D4
    SUB.W  D4, D2
    ; CALC ROW OF SQUARE IN ORDER TO PRINT TEXT
    MOVE.W  #SCRHEIGH, D3
    DIVU.W  #SQRSIDEL, D3
    MOVE.W  #SCRROW, D1
    DIVU.W  D3, D1
    MOVE.W  D1, D4
    MULU.W  (A0), D1
    DIVU.W  #2, D4
    SUB.W  D4, D1
    MOVEM.L (A7)+,D3-D4
    RTS
