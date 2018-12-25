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
    ADD.W   #1, (PLYNBAL)           ; COLLISION
    MOVE.L  A1, A0
    JSR     AGLKILL
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
    DW_SET_PEN  BONPENCL
    DW_SET_FILL BONCOLOR
    MOVEM.W D1-D4,-(A7)
    COLL_BON_HITBOX (A1), 2(A1), #BONSIDEL
    MOVE.B  #88,D0
    TRAP    #15
    COLL_BON_HITBOX (A1), 2(A1), #BONSIDEL-BONTHICK
    MOVE.B  #88,D0
    TRAP    #15
    RTS
