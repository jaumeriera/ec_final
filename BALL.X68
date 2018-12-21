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
;    MOVE.W  4(A0),D0                ; UPDATE COORDINATES
;    SUB.W   D0,(A0)
;    MOVE.W  6(A0),D0
;    ADD.W   D0,2(A0)
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