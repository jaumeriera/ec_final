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
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
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
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    RTS

; -----------------------------------------------------------------------------
SQRUPDRW
; UPDATES ALL SQUARE ROWS
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    RTS

; -----------------------------------------------------------------------------
SQRUPD
; UPDATES A SQUARE
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    RTS