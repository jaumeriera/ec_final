; =============================================================================
; GAME VARS
; =============================================================================

; --- PLAYER VARS -------------------------------------------------------------

PLYIDX      DS.B    1       ; INDEX FOR PLAYER ANGLE
            DS.W    0

PLYXPOS     DS.W    1       ; POSITION OF PLAYER IN X COORDINATE
PLYNBAL     DS.W    1       ; NUMBER OF PLAYER BALLS
PLYXANG     DS.B    1       ; ANGLE X COORDINATE
PLYYANG     DS.B    1       ; ANGLE Y COORDINATE
PLYENDX     DS.W    1       ; END X COORDINATE TO DRAW ANGLE
PLYENDY     DS.W    1       ; END Y COORDINATE TO DRAW ANGLE
PLYROUND    DS.W    1       ; GAME ROUND

; --- SPAWNER VARS -----------------------------------------------------------

SPWON       DS.B    1       ; 1 IF SPAWNER IS WORKING 0 IF SPAWNER IS PAUSED
            DS.W    0
SPWBAL      DS.W    1       ; NUMBER OF BALLS SHOTED
SPWLAN      DS.W    1       ; NUMBER OF BALLS ON LANDED 
SPWNXX      DS.W    1       ; NEXT PLAYER X COORDINATE

; --- STAT VARS --------------------------------------------------------------

STACUR      DS.W    1       ; CURRENT STATE
STANEXT     DS.W    1       ; NEXT STATE

; --- UTILITY VARIABLES ------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
            DS.W    0
AUXVARONE   DS.L    1                       ; AUXILIAR VARIABLE
AUXVARTWO   DS.L    1                       ; AUCILIAR VARIABLE