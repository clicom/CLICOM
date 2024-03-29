$STORAGE:2
      SUBROUTINE AXMAN(XWIN,YWIN,PALETTE,PALDEF,VPNDLF,VPNDRT,
     +                 AXSCLR,AXSTHK,TICSIZE)
C
C       ** INPUT:
C             XWIN
C             YWIN
C             PALETTE
C             PALDEF
C             VPNDLF
C             VPNDRT
C       ** OUTPUT:            
C             AXSCLR
C             AXSTHK
C             TICSIZE
C
      INTEGER *2 PALETTE,PALDEF(16,*),AXSCLR,AXSTHK
      REAL*4     XWIN(*),YWIN(*),TICSIZE
C
      INTEGER*2 WINSTAT,HELPLVL        
      CHARACTER *2 INCHAR
C
C       ** INITIAL WINDOW CONTROL VARIABLES;  WINSTAT IS SET TO DRAW MENU,
C          AND GET CHOICE; SCREEN IS NOT SAVED
C
      WINSTAT = 2
      MENUNUM = 16
      HELPLVL = 16
C
C       ** LOOP TO DISPLAY AND PROCESS MENU CHOICES
C      
   70 CALL GRAFMNU(WINSTAT,MENUNUM,XWIN(1),YWIN(1),HELPLVL,INCHAR)
      IF (INCHAR.EQ.'ES') THEN
C
C          .. ESC EXITS FROM THIS MENU 
         GO TO 100
      ELSE IF (INCHAR.EQ.'1 ') THEN
C
C          .. CHOOSE AXIS COLOR
         ICNTRL = 0
         NBRPICK = 16
         IPAL = PALETTE
         IPICK = 2
         ICLR = AXSCLR
         CALL PICKCOL(ICLR,XWIN(2),YWIN(2),ICNTRL,NBRPICK,IPAL,PALDEF,
     +                IPICK)
         IF (ICLR.NE.-1) AXSCLR=ICLR
      ELSE IF (INCHAR.EQ.'2 ') THEN
C
C          .. CHOOSE AXIS LINE THICKNESS
         ICNTRL = 1
         CALL LNATRIB(ICNTRL,XWIN(2),YWIN(2),AXSTHK)
      ELSE IF (INCHAR.EQ.'3 ') THEN
C
C          .. CHOOSE LENGTH OF TIC MARKS      
         CALL CHNGTIC(XWIN(2),YWIN(2),TICSIZE,AXSTHK,VPNDLF,VPNDRT)
      ENDIF
C
C       ** RETURN TO GET ANOTHER MENU CHOICE; MENU WILL NOT BE REDRAWN
C      
      WINSTAT = 3
      GO TO 70     
C
C       ** END OF THIS MENU; REMOVE MENU FROM SCREEN
C      
  100 CONTINUE
      WINSTAT = 0
      CALL GRAFMNU(WINSTAT,MENUNUM,XWIN(1),YWIN(1),HELPLVL,INCHAR)
      RETURN
      END
            