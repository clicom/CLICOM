$STORAGE:2

      SUBROUTINE CBOX(INBOX,FGCOLOR,BGCOLOR)
C   
C   ROUTINE TO ASK THE USER FOR DEFINITION INFORMATION AND THEN
C   CALL DRWBOX TO DRAW A BOX ON THE SCREEN...
C
      INTEGER*2 ICOL,IROW,IBXCOL,IBXROW,FGCOLOR,BGCOLOR,BOXTYP
      LOGICAL INBOX
      CHARACTER*2 INCHAR,RTNFLAG,NOUP,NOLO,YESUP,YESLO
C
      CALL GETYN(1,2,YESUP,YESLO)
      CALL GETYN(2,2,NOUP,NOLO)
      IF (INBOX) THEN
         CALL POSLIN(IROW,ICOL)
         CALL ACTPAG(1,IERR)
         CALL CLS
         CALL LOCATE(15,0,IERR)
         CALL WRTMSG(10,214,14,0,0,' ',0)
         INCHAR = 'S'
  100    CONTINUE
         CALL LOCATE(15,50,IERR) 
         CALL GETSTR(0,INCHAR,1,15,1,RTNFLAG)
         IF (RTNFLAG.EQ.'4F') THEN
            INBOX = .FALSE.
            CALL ACTPAG(0,IERR)
            RETURN
         ELSE 
            IF (INCHAR.EQ.'S ') THEN
               BOXTYP = 1
            ELSE IF (INCHAR.EQ.'D ') THEN
               BOXTYP = 2
            ELSE IF (INCHAR.EQ.'O ') THEN
               BOXTYP = 3
            ELSE IF (INCHAR.EQ.'B ') THEN
               BOXTYP = 4
            ELSE
               CALL LOCATE(16,0,IERR)
               CALL WRTMSG(8,215,12,1,0,' ',0)
               GO TO 100
            END IF
            IF (ICOL.LT.IBXCOL) THEN
               ITEMP = ICOL
               ICOL = IBXCOL
               IBXCOL = ITEMP
            END IF
            IF (IROW.LT.IBXROW) THEN
               ITEMP = IROW
               IROW = IBXROW
               IBXROW = ITEMP
            END IF
            CALL ACTPAG(0,IERR)
            CALL DRWBOX(IBXCOL,IBXROW,ICOL,IROW,BOXTYP,FGCOLOR
     +           ,BGCOLOR)
            INBOX = .FALSE.
         END IF
      ELSE      
         CALL POSLIN(IBXROW,IBXCOL)
         CALL ACTPAG(1,IERR)
         CALL CLS 
         CALL LOCATE(15,0,IERR)
         CALL WRTMSG(10,434,14,0,0,' ',0)
         CALL WRTMSG(9,435,14,0,0,' ',0)
         CALL WRTMSG(8,436,14,0,0,' ',0)
         CALL LOCATE(17,52,IERR)
  200    CALL GETCHAR(0,INCHAR)
         IF (INCHAR.EQ.YESUP .OR. INCHAR.EQ.YESLO)  THEN
            INBOX = .TRUE.
         ELSE IF (INCHAR.EQ.NOUP .OR. INCHAR.EQ.NOLO) THEN
            INBOX = .FALSE.
         ELSE
            CALL BEEP
            GO TO 200
         END IF
         CALL ACTPAG(0,IERR)
      END IF
      RETURN
      END
