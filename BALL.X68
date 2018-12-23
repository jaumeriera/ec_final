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
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
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
    CMP.W   #1, (SPWLAN)
    BNE     .END
    MOVE.W  (A0), (SPWNXX)
    MOVE.W  (PLYNBAL), D0
    CMP     (SPWLAN), D0
    BNE     .END
    ADD.W   #1, (PLYROUND)
    JSR     SPWCLR
    MOVE.W  (SPWNXX), (PLYXPOS)
    JSR     AGLKILL
.END
    MOVE.L  (A7)+, D0
    RTS

; -----------------------------------------------------------------------------
BALPLOT
; PLOTS AN ASTEROID
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            DW_SET_PEN BALPENCL
            DW_SET_FILL BALFILCL
            MOVEM.W D1-D4,-(A7)
            MOVE.W  (A0),D1
            SUB.W   #NORRADI/2, D1
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #NORRADI,D3
            ADD.W   #NORRADI,D4
            MOVE.B  #88,D0
            TRAP    #15
            MOVEM.W (A7)+,D1-D4
            RTS