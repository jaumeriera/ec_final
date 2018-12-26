; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAEMPTY
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAGOVRU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP, STAPLAYP, STAGOVRP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAPLAYI
; INIT PLAYER AND SPAWNER STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR PLRINIT AND SPWINIT
; -----------------------------------------------------------------------------
    CLR.B (KBDVAL)
    CLR.B (KBDEDGE)
    JSR PLRINIT
    JSR SPWINIT
    JSR SQRNWRND
    RTS

; -----------------------------------------------------------------------------
STAPLAYU
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    JSR SPWUPD
    JSR PLRUPD
    BRA AGLUPD

; -----------------------------------------------------------------------------
STAPLAYP
; PLAY STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     AGLPLOT
            BRA     PLRPLOT

; -----------------------------------------------------------------------------
STAINTRI    EQU     DMMINIT
; INTRO STATE INITIALIZATION.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR INTRINIT
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITST,(KBDEDGE) ; CAMBIAR CUANDO ESTE INTEGRACIÓN FINAL
            BEQ     .END
            MOVE.W  #STAPLAY,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAINTRP
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D1,-(A7)
            DW_POS_TEXT INTTITX,INTTITY
            DW_SET_PEN INTTITC
            DW_SET_FILL $00000000
            LEA     .TITSTR,A1
            MOVE.B  #14,D0
            TRAP    #15

            DW_POS_TEXT INTPRSX,INTPRSY
            DW_SET_PEN INTPRSC
            DW_SET_FILL $00000000
            LEA     .PRSSTR,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVEM.L (A7)+,A1/D0-D1
            RTS

.TITSTR     DC.B    'BBTAN 68000',0
.PRSSTR     DC.B    'PUSH "S" KEY TO START',0
            DS.W    0

; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITST,(KBDEDGE) ; CAMBIAR CUANDO ESTE INTEGRACIÓN FINAL
            BEQ     .END
            MOVE.W  #STAINTR,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D1,-(A7)
            DW_POS_TEXT GOVSTRX,GOVSTRY
            DW_SET_PEN GOVSTRC
            DW_SET_FILL $00000000
            LEA     .GOVSTR,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVEM.L (A7)+,A1/D0-D1
            RTS

.GOVSTR     DC.B    'GAME  OVER',0
            DS.W    0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
