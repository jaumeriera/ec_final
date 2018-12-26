; =============================================================================
; BALL MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE
; +4 WORD X SPEED
; +6 WORD Y SPEED
; =============================================================================

; -----------------------------------------------------------------------------
BALINIT
; INITALIZES A BALL
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - NONE
; -----------------------------------------------------------------------------
    MOVE.W  D0,-(A7)
    MOVE.W  (PLYXPOS), (A0)                  ; X POSITION
    MOVE.W  #HUBFLRYH-NORRADI, 2(A0)        ; Y POSITION
    MOVE.B  (PLYXANG), D0
    EXT.W   D0
    MOVE.W  D0, 4(A0)                       ; X SPEED
    MOVE.B  (PLYYANG), D0
    EXT.W   D0
    MOVE.W  D0, 6(A0)                 ; Y SPEED
    MOVE.W  (A7)+,D0
    RTS

; -----------------------------------------------------------------------------
BALUPD
; UPDATES A BALL
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVE.L  D0, -(A7)
    MOVE.W  4(A0),D0                ; UPDATE COORDINATES
    ADD.W   D0,(A0)
    MOVE.W  6(A0),D0
    ADD.W   D0,2(A0)
    ; CHECK COLISION WITH LEFT SIDE
    CMP.W   #NORRADI/2, (A0)
    BLT     .SIDE
    ; CHECK COLISION WITH RIGHT SIDE
    CMP.W   #SCRWIDTH-NORRADI/2, (A0)
    BGT     .SIDE
    ; CHECK COLLISION WITH THE TOP
    CMP.W   #0, 2(A0)
    BLT     .TOP
    ; CHEK BOTTOM COLLISION
    CMP.W   #SCRHEIGH, 2(A0)
    BGT     .BOTTOM
    ; NO COLLISION
    JSR     BALSQRCOL
    BRA     .END
.SIDE
    NEG.W   4(A0)
    BRA .END
.TOP
    NEG.W   6(A0)
    BRA .END
.BOTTOM
    ; WHEN COLLIDES TO BOTTOM CHECK IF IS THE FIRST BALL WICH LAND
    ; IF ITS THE FIRST BALL, UPDATE X COORDINATE FOR THE PLAYER
    ; IF ITS THE LAST BALL, PUT NEXT STATE AS PLAYER
    ADD.W   #1, (SPWLAN)
    MOVE.W  (SPWLAN), D0 
    CMP.W   #1, (SPWLAN)
    BNE     .ISLAST
    MOVE.W  (A0), (SPWNXX)
.ISLAST
    MOVE.W  (PLYNBAL), D0
    CMP     (SPWLAN), D0
    BNE     .KILL
    JSR     SQRNWRND                    ; ADVANCE ONE ROUND
    MOVE.W  (TKNBON), D0
    ADD.W   D0, (PLYNBAL)
    JSR     SPWCLR
    MOVE.W  (SPWNXX), (PLYXPOS)
.KILL
    JSR     AGLKILL
.END
    MOVE.L  (A7)+, D0
    RTS

; -----------------------------------------------------------------------------
BALSQRCOL
; CHECK COLLISION WITH SQUARES
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVEM.L D0/A0-A1, -(A7)
    MOVE.L  A0, A1
    MOVE.W  #SQRTYPE, D0                ; LOOP THROUGH ALL SQUARES
    JSR     DMMFRSTO
.LOOP
    CMP.L   #0, A0
    BEQ     .END
    ; GET BALL HITBOX
    COLL_BALL_HITBOX (A1), 2(A1)
    MOVE.W  D1, (AUXVARONE)
    MOVE.W  D2, D5
    MOVE.W  D3, D6
    MOVE.W  D4, D7
    ; GET SQUARE HITBOT
    COLL_SQR_HITBOX 8(A0), 10(A0)
    MOVE.W  D1, D0
    MOVE.W  D2, D1
    MOVE.W  D3, D2
    MOVE.W  D4, D3
    MOVE.W  (AUXVARONE), D4
    ; ONCE WE HAVE OBJECTS HITBOX CHECK IF BOUNCE
    CMP.W   D5, D3
    BLT     .NEXT
    CMP.W   D7, D1
    BGT     .NEXT
    CMP.W   D4, D2
    BLT     .NEXT
    CMP.W   D6, D0
    BGT     .NEXT
    ; COLLISION WITH BOTTOM
    CLR.L   (AUXVARONE)
    CLR.L   (AUXVARTWO)
    MOVE.W  (A0), (AUXVARONE)
    MOVE.W  (A0), (AUXVARTWO)
    SUB.W   #BALZONE, (AUXVARONE)
    ADD.W   #BALZONE, (AUXVARTWO)
    CMP.W   D7, D1
    BGT     .TOP
    CMP.W   D3, D7
    BLT     .TOP
    CMP.W   (AUXVARONE), D6
    BGE     .BOUNCEY
    CMP.W   (AUXVARTWO), D4
    BLE     .BOUNCEY
    BRA     .BOUNCEX
.TOP
    CMP.W   D5, D3
    BLT     .SIDES
    CMP.W   D1, D5
    BGT     .SIDES
    CMP.W   (AUXVARONE), D6
    BGE     .BOUNCEY
    CMP.W   (AUXVARTWO), D4
    BLE     .BOUNCEY
.SIDES
.BOUNCEX
    NEG.W   4(A1)
    BRA .END
.BOUNCEY
    NEG.W   6(A1)
    BRA .END
.NEXT
    MOVE.W  #SQRTYPE, D0
    JSR     DMMNEXTO
    BRA     .LOOP
.END
    MOVEM.L (A7)+, D0/A0-A1
    RTS
; -----------------------------------------------------------------------------
BALPLOT
; PLOTS A BALL
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    DW_SET_PEN BALPENCL
    DW_SET_FILL BALFILCL
    MOVEM.W D1-D4,-(A7)
    COLL_BALL_HITBOX (A0), 2(A0)
    MOVE.B  #88,D0
    TRAP    #15
    MOVEM.W (A7)+,D1-D4
    RTS