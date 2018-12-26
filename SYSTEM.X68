; =============================================================================
; SYSTEM MANAGEMENT (SYSTEM CODE)
; =============================================================================

;PARA SABER CUAL HA CAMBIADO KDRREAD KBDVAL NOT DE UNO AND CON EL OTRO

; -----------------------------------------------------------------------------
SYSINIT
; INITIALIZES THE SYSTEM
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVE.L  (A7)+,A0                ; GET RETURN ADDRESS
    JSR     KBDINIT                 ; INIT KEYBOARD
    JSR     SCRINIT                 ; INIT SCREEN
    JSR     DMMINIT                 ; INIT DYNAMIC MEMORY
    ANDI.W  #$DFFF,SR               ; SWITCH TO USER
    MOVE.L  A0,-(A7)                ; PUT RETURN ADDRESS
    RTS

; =============================================================================
; SCREEN MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
SCRINIT
; INITIALIZES THE SCREEN, SCREEN-RELATED INTERRUPT AND VARS.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - D0,D1,D2,D3
; -----------------------------------------------------------------------------
    MOVEM.L D0-D3,-(A7)
    ; - DISABLE ALL AUTO-IRQ
    INT_DIS_AUTO_IRQ
    ; - DISABLE INTS (SET INT BITS IN SR TO 111)
    INT_SET_LEVEL 7
    ; - INSTALL SCRUPD INTO TRAP SCRTRAP
    MOVE.L  #SCRUPD,($80+SCRTRAP*4)
    ; - SET RESOLUTION TO SCRWIDTH X SCRHEIGHT
    SC_SET_RES SCRWIDTH, SCRHEIGH
    ; - SET WINDOWED MODE
    SC_SET_WINDOWED
    ; - CLEAR VISIBLE BUFFER
    SC_CLEAR
    ; - ENABLE DOUBLE BUFFER
    SC_ENABLE_DB
    ; - CLEAR HIDDEN BUFFER
    SC_SWAP_DB
    SC_CLEAR
    SC_SWAP_DB
    ; - INSTALL SCRISR FOR IRQ SCRIRQ (IRQ INTERRUPT VECTOR BEGINS
    ;   AT $60. INSTALLATION IS SIMILAR TO TRAP INSTALLATION)
    MOVE.L  #SCRISR,($60+SCRIRQ*4)
    MOVE.B  #32, D0
    MOVE.B  #6, D1
    MOVE.B  #$81, D2
    MOVE.L  #SCRTIM, D3
    TRAP    #15
    ; - CLEAR SCRINTCT AND SCRCYCCT
    CLR.B   (SCRINTCT)
    CLR.B   (SCRCYCCT)
    ; - ENABLE ALL AUTO IRQ
    ;INT_ENA_AUTO_IRQ
    ; - ENABLE INTS (SET INT BITS IN SR TO 000)
    INT_SET_LEVEL 0
    MOVEM.L (A7)+, D0-D3
    RTS

; -----------------------------------------------------------------------------
SCRISR
; SCREEN TIMER ISR. INCREASES THE INTERRUPT COUNTER AND UPDATES DOUBLE BUFFER.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    ADDQ.B  #1,(SCRINTCT)           ; UPDATE INT FLAG/COUNTER
    ADDQ.B  #1,(SCRCYCCT)           ; UPDATE CYCLE COUNTER
    RTE

; -----------------------------------------------------------------------------
SCRUPD
; TRAP SERVICE ROUTINE IN CHARGE OF VISUALIZING CURRENT FRAME AND CLEARING
; BUFFER FOR THE NEXT ONE.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    ; UPDATE DOUBLE BUFFER AND CLEAR HIDDEN BUFFER
    SC_SWAP_DB
    SC_CLEAR
    RTE

; =============================================================================
; KEYBOARD MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
KBDINIT
; INITIALIZES THE SYSTEM VARIABLES KBDSYS AND KBDVAL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    CLR.B   (KBDVAL)                 ; INIT VARS
    CLR.B   (KBDEDGE)
    MOVE.L  #KBDREAD,($80+KBDTRAP*4) ; INSTALL
    RTS

; -----------------------------------------------------------------------------
KBDREAD
; TRAP SERVICE ROUTINE.
; UPDATES THE SYSTEM VARIABLES KBDEDGE AND KBDVAL ACCORDING TO THE BITFIELD
; DESCRIBED IN SYSCONST. KBDVAL HOLDS THE CURRENT VALUES AND KBDEFGE HOLDS
; RISING EDGES FROM PREVIOUS CALL TO THE CURRENT ONE.
; INPUT    - NONE
; OUTPUT   - (KBDVAL) AND (KBDEDGE)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    MOVEM.L D0-D7, -(A7)
    
    ; LOAD MOVEMENT KEYS         
    KBD_LOAD_KEYS KBDLEFT, KBDRIGHT, KBDUP, KBDDOWN
    ; UPDATE KBDVAL AND KBDEDGE DEPENDING ON KEY STATE
    KBD_UPDT_VARS 24, KBDMSKLF
    KBD_UPDT_VARS 16, KBDMSKRT
    KBD_UPDT_VARS 8, KBDMSKUP
    KBD_UPDT_VARS 0, KBDMSKDN

    ; LOAD OTHER KEYS
    KBD_LOAD_KEYS KBDFIRE1, KBDFIRE2, KBDFIRE3, KBDPAUSE
    ; UPDATE KBDVAL AND KBDEDGE DEPENDING ON KEY STATE
    KBD_UPDT_VARS 24, KBDMSKF1
    KBD_UPDT_VARS 16, KBDMSKF2
    KBD_UPDT_VARS 8, KBDMSKF3
    KBD_UPDT_VARS 0, KBDMSKPS

    MOVEM.L (A7)+, D0-D7
    RTE

; =============================================================================
; DYNAMIC MEMORY MANAGEMENT (SYSTEM CODE)
; DYNAMIC MEMORY IS A SET OF DMMBNUM SLOTS OF DMMBSIZE BYTES EACH ONE.
; DMMBSIZE MUST BE POWER OF TWO. A SLOT HAS:
; - HEADER - 1 WORD. SPECIFIES THE OWNER (0 MEANS OWNED BY SYSTEM)
; - DATA   - DMMBSIZE - 2 BYTES. MAY CONTAIN VARS AND ANY KIND OF DATA RELATED
;            THE THE OWNER. IF OWNER==0, DATA IS MEANINGLESS.
; =============================================================================

; -----------------------------------------------------------------------------
DMMINIT
; INITIALIZES THE DYNAMIC MEMORY TO ALL OWNED BY SYSTEM.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            LEA     DMMDATA,A0
            MOVE.W  #DMMBNUM-1,D0
.LOOP       MOVE.W  #DMMSYSID,(A0)
            ADD.L   #DMMBSIZE,A0
            DBRA.W  D0,.LOOP
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
DMMFIRST
; SEARCHES THE FIRST MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - NONE
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFRLOP    TST.W   (A0)+
            BNE     DMMFRFND
            ADD.L   #DMMBSIZE-2,A0
DMMFRCOM    CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFRLOP
            MOVE.L  #0,A0
DMMFRFND    RTS

; -----------------------------------------------------------------------------
DMMNEXT
; SEARCHES THE NEXT MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFRCOM

; -----------------------------------------------------------------------------
DMMFRSTO
; SEARCHES THE FIRST MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFLOOP    CMP.W   (A0)+,D0
            BEQ     DMMFFND
            ADD.L   #DMMBSIZE-2,A0
DMMFCOM     CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFLOOP
            MOVE.L  #0,A0
DMMFFND     RTS

; -----------------------------------------------------------------------------
DMMNEXTO
; SEARCHES THE NEXT MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
;            A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFCOM

; -----------------------------------------------------------------------------
DMMALLOC
; SEARCHES THE FIRST FREE (SYS OWNED) SLOT, ASSIGNS TO THE SPECIFIED OWNER
; AND RETURNS A POINTER TO THE CORRESPONDING DATA (SLOT ADDRESS + 2)
; INPUT    - D0.W : ID TO ASSIGN
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FREE SPACE
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            CLR.W   D0
            JSR     DMMFRSTO
            MOVE.W  (A7)+,D0
            CMP.L   #0,A0
            BEQ     .END
            MOVE.W  D0,-2(A0)
.END        RTS

; -----------------------------------------------------------------------------
DMMFREE
; FREES THE SLOT TO WHICH THE PROVIDED POINTER BELONGS BY SETTING ITS OWNED TO
; SYSTEM (0)
; INPUT    - A0   : POINTER BELONGING TO THE SLOT TO FREE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            MOVE.L  D0,A0
            CLR.W   (A0)
            MOVEM.L (A7)+,D0/A0
            RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
