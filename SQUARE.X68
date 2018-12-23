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