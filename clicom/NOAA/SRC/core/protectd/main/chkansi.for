$STORAGE:2
       PROGRAM CHKANSI
C
C
C     ROUTINE TO CHECK THE USER'S CONFIG.SYS FILE AND MAKE SURE THAT THE
C     ANSI.SYS DEVICE DRIVER IS INCLUDED IN CONFIG.SYS FILE.
C     IF THE ANSI.SYS IS NOT FOUND IN CONFIG.SYS FILE OR THE CONFIG.SYS FILE
C     DOES NOT EXIST THE ROUTINE WILL SET ERRORLEVEL VALUE IS SET TO 4.  
C     OTHERWISE, IT SET ERRORLEVEL TO 0.
C
      CHARACTER*79 LINE
      CHARACTER*8 TEXT
      CHARACTER*3 REMARK

      DATA TEXT /'ANSI.SYS'/, REMARK /'REM'/

C
C     OPEN THE EXISTING CONFIG.SYS FILE.
C
      OPEN (75,FILE='C:\CONFIG.SYS',STATUS='OLD',FORM='FORMATTED'
     +      ,IOSTAT=IOCHK)
      IF (IOCHK.NE.0) THEN
C
C        NO EXISTING CONFIG.SYS FILE FOUND. SET RETURN CODE = 4
C        
         STOP 4
      ENDIF
C
C     IF A CONFIG.SYS FILE ALREADY EXISTS THEN CONVERT TO UPPER CASE LETTER 
C
         DO 100 I = 1,100
            READ(75,'(A79)',END=120) LINE
            CALL LOW2UP(LINE)
C
C     CHECK THE EXISTING LINES ONE BY ONE AND LOOK FOR THE COMMAND STATEMENT
C     ANSI.SYS IN CONFIG.SYS FILE.  IF THE COMMAND IS FOUND IT WILL RETURN
C     CODE 0.  OTHERWISE, IT WILL RETURN CODE 4.  
C
C     SCAN THE INPUT LINE FOR A MATCH WITH THE TEXT WANTED.
C     IF THE REM IS FOUND IN CONFIG.SYS FILE THEN SKIP THE SEARCH FOR COMMAND
C     ANSI.SYS IN THAT LINE.
C
      DO 110 J = 1,72
         IF (LINE(J:J+2).EQ.REMARK(1:3)) THEN
            GOTO 100
         ELSE
            IF (LINE(J:J+7).EQ.TEXT(1:8)) THEN
                STOP ' '
            ENDIF
         ENDIF
  110 CONTINUE
  100 CONTINUE
  120 CONTINUE
      STOP 4
      END
