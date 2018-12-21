; =============================================================================
; SPAWNER MANAGEMENT.
; =============================================================================

; -----------------------------------------------------------------------------
SPWINIT
; INICIALIZES THE SPAWNER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    CLR.B (SPWON)
    CLR.W (SPWBAL)
    CLR.W (SPWLAN)
    RTS

; -----------------------------------------------------------------------------
SPWUPD
; UPDATES THE SPAWNER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L  D0/A1-A3,-(A7)
            MOVE.B  (SPWON), D0
            CMP.B   #1, D0
            BNE     .END
            MOVE.W  (PLYNBAL), D0
            CMP.W   (SPWBAL), D0
            BEQ     .END
            MOVE.B  (SCRCYCCT),D0
            AND     #SPWCYCLE,D0
            BNE     .END                    ; CREATE A NEW BALL
            ADD     #1, (SPWBAL)            ; UPDATE NUMBER OF BALLS THROWED
            LEA     BALINIT, A1
            LEA     BALUPD, A2
            LEA     BALPLOT, A3
            MOVE.W  #BALTYPE, D0
            JSR     AGLADD
.END        MOVEM.L (A7)+,D0/A1-A3
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~