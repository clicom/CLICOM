$STORAGE:2

      SUBROUTINE SELPRT(RTNCODE)
C
C   ROUTINE TO ASK THR USER IF HE WANTS PRINT FILE OUTPUT DIRECTED TO
C   THE PRINTER OR A DISK FILE.  IF HE WANTS A DISK FILE IT ASKS FOR
C   THE NAME.  IT ALSO OPENS THE PRINT FILE AS FILE 50.
C
C      NORMAL END RTNCODE = '0', ELSE = '1'
C
      CHARACTER*1 RTNCODE
      CHARACTER*2 RTNFLAG
      CHARACTER*6 HLDTXT
      CHARACTER*22 OUTFIL   
      DATA OUTFIL /'           '/
C
      CALL POSLIN(IROW,ICOL)
C
   40 CONTINUE      
      CALL LOCATE(IROW,ICOL,IERR)
      CALL GETMNU('PRINT-OUTPUT','  ',ICHOICE)
      CALL CLRMSG(2)
      CALL CLRMSG(3)
      IF (ICHOICE.EQ.0) THEN
         RTNCODE = '1'
         RETURN
      ELSE IF (ICHOICE.EQ.1) THEN
         OUTFIL = 'PRN  '
      ELSE IF (ICHOICE.EQ.2) THEN
         JROW = IROW + 10
         CALL WRTMSG(25-JROW,309,14,0,0,' ',0)
         CALL LOCATE(JROW,58,IERR)
         CALL GETSTR(0,OUTFIL,22,15,1,RTNFLAG)
         DO 60 I1 = 1,22
            IF (OUTFIL(I1:I1).EQ.'/') THEN
               OUTFIL(I1:I1) = '\'
            END IF
   60    CONTINUE            
         IF (OUTFIL.EQ.'  '.OR.RTNFLAG.EQ.'4F') THEN
            GO TO 40
         END IF
      END IF
C
      OPEN(50,FILE=OUTFIL,STATUS='UNKNOWN',FORM='FORMATTED'
     +       ,IOSTAT=IOCHK)
      IF (IOCHK.NE.0) THEN
         CALL WRTMSG(3,157,12,1,0,' ',0)
         CALL LOCATE(23,0,IERR)
         CALL CLRMSG(2)
         CALL WRTSTR(OUTFIL,22,12,0)
         WRITE(HLDTXT,'(2X,I4)') IOCHK
         CALL WRTSTR(HLDTXT,6,12,0)
         GO TO 40
      ELSE
         RTNCODE = '0'
         RETURN
      END IF
      END