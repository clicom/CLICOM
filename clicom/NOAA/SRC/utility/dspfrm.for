$STORAGE:2

      SUBROUTINE DSPFRM(FORMNAME,FRMHT,FRMWID,BORDER,STRTROW,STRTCOL
     +       ,RTNCODE)
C
C   ROUTINE TO READ A DATA ENTRY FORM FROM DISK AND DISPLAY IT
C
      CHARACTER*22 FILENAME
      CHARACTER*8 FORMNAME
      CHARACTER*1 RTNCODE
      INTEGER*2 FRMWID,FRMHT,NCHAR(80,23),FGCOLOR(80,23),BGCOLOR(80,23)
     +         ,STRTROW,STRTCOL
      LOGICAL BORDER
      COMMON /LOCFRM/ NCHAR,FGCOLOR,BGCOLOR
      FILENAME = 'P:\FORM\AAAAAAAA.FRM  '
      RTNCODE = '0'
C
C   DETERMINE AND SET THE NAME OF THE FORM DEFINITION FILE
C
      DO 50 I = 1,8
         IF (FORMNAME(I:I).EQ.' ') THEN
            GO TO 60
         END IF
         NAMLEN = I
   50 CONTINUE
   60 CONTINUE
      FILENAME(9:9+NAMLEN-1) = FORMNAME(1:NAMLEN)
C
C  WRITE THE FORM ON DISK TO THE SCREEN 
C
      OPEN (15,FILE=FILENAME,STATUS='OLD',FORM='UNFORMATTED'
     +      ,SHARE='DENYWR',MODE='READ'
     +      ,IOSTAT=IOCHK)
       IF (IOCHK.NE.0) THEN
          MSGNUM = 52
          CALL WRTMSG(2,MSGNUM,12,1,1,FORMNAME,8)
          RTNCODE = '1'
          RETURN
      END IF
      READ(15) FRMHT,FRMWID,BORDER
      READ(15) ((NCHAR(I,J),BGCOLOR(I,J),FGCOLOR(I,J),J=1,FRMHT),
     +         I=1,FRMWID)
C
C  SCROLL UP THE SCREEN IF NECESSARY - ALSO CHECK WIDTH VS COLUMN POS
C
      CALL SCRLUP(FRMHT,NUMSCR)
      IF (STRTROW.GE.NUMSCR) THEN
         STRTROW = STRTROW - NUMSCR
      END IF
      IF (STRTCOL+FRMWID.GT.80) THEN
         CALL WRTMSG(2,49,12,1,1,' ',0)
         STRTCOL = 80 - FRMWID
      END IF
      DO 100 J = 0,FRMHT-1
         DO 100 I = 0,FRMWID-1
            CALL LOCATE(STRTROW+J,STRTCOL+I,IERR)
            CALL CHRWRT(NCHAR(I+1,J+1),BGCOLOR(I+1,J+1)
     +           ,FGCOLOR(I+1,J+1),1)
  100 CONTINUE
      RETURN
      END
