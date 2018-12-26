; =============================================================================
; BONUS MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD ROW NUMBER
; +2 WORD COLUMN NUMBER
; =============================================================================

; -----------------------------------------------------------------------------
BONINIT
; INITALIZES A BONUS
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - NONE
; -----------------------------------------------------------------------------
    MOVE.W  D1, (A0)
    MOVE.W  D2, 2(A0)
    RTS

; -----------------------------------------------------------------------------
BONUPD
; UPDATE A BONUS
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - NONE
; -----------------------------------------------------------------------------
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
    COLL_BON_HITBOX  (A1), 2(A1), #BONSIDEL
    MOVE.W  D1, D0
    MOVE.W  D2, D1
    MOVE.W  D3, D2
    MOVE.W  D4, D3
    MOVE.W  (AUXVARONE), D4
    ; IN THIS MOMENT WE HAVE BOTH HITBOX CALCULATED. FROM D0 TO D3 BONUS
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
    ADD.W   #1, (TKNBON)           ; COLLISION
    MOVE.L  A1, A0
    JSR     AGLKILL
    BRA     .END
.NEXT
    MOVE.W  #BALTYPE, D0
    JSR     DMMNEXTO
    BRA     .LOOP
.END
    MOVEM.L (A7)+,A0-A1/D0-D7 
    RTS

; -----------------------------------------------------------------------------
BONPLOT
; PLOT A BONUS
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - NONE
; -----------------------------------------------------------------------------
    MOVEM.L D0-D5,-(A7)
    DW_SET_PEN  BONPENCL
    DW_SET_FILL BONCOLOR
    COLL_BON_HITBOX (A0), 2(A0), #BONSIDEL
    MOVE.B  #88,D0
    TRAP    #15
    MOVE.W  D1, D5
    DW_SET_FILL BONPENCL
    MOVE.W  D5, D1    
    ADD.W   #BONTHICK, D1
    ADD.W   #BONTHICK, D2
    SUB.W   #BONTHICK, D3
    SUB.W   #BONTHICK, D4
    MOVE.B  #88,D0
    TRAP    #15
    MOVEM.L (A7)+,D0-D5
    RTS
