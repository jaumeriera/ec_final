; =============================================================================
; TITLE    : BBTAM 68000
; AUTHOR   : JAUME RIERA GENOVAR
; V1.0     : 26/12/2018
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------
            
            INCLUDE "UTIL.X68"              ; UTILITY MACRO AND SUBROUTINES
            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; USER CONSTANTS    
            INCLUDE "PLAYER.X68"            ; PLAYER MANAGEMENT
            INCLUDE "SPAWNER.X68"           ; SPAWNER MANAGEMENT
            INCLUDE "AGENTLST.X68"          ; AGENT LIST MANAGEMENT
            INCLUDE "STATES.X68"            ; GAME STATES MANAGEMENT
            INCLUDE "BALL.X68"              ; BALL MANAGEMENT
            INCLUDE "SQUARE.X68"            ; SQUARE MANAGEMENT
            INCLUDE "BONUS.X68"             ; BONUS MANAGEMENT

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT
            JSR     STAINIT

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     STAUPD

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            JSR     STAPLOT
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
