$STORAGE:2
      SUBROUTINE TXT2MSGS
C
C   ROUTINE TO CONVERT THE TEXT MESSAGE FILE (P:\DATA\MESSAGES.TXT) TO 
C   THE DIRECT FORTRAN FILE P:\DATA\MESSAGES.FTN THAT IS USED BY THE
C   CLICOM PROGRAMS.
C
      CHARACTER*78 MSGLIN, MSGLN1, MSGLN2, BLANK
      CHARACTER*4 ERRLIN
      CHARACTER*2 INCHAR
      DATA BLANK/'     '/
C
C   OPEN THE TEXT MESSAGE FILE AND MAKE SURE THE MESSAGES ARE IN PROPER
C   ORDER
C
   40 CONTINUE      
      OPEN (17,FILE='P:\DATA\MESSAGES.TXT',STATUS='OLD',
     +      FORM='FORMATTED',IOSTAT=IOCHK)
      IF (IOCHK.NE.0) THEN
         IF (IOCHK.EQ.6416) THEN
            CALL WRTMSG(3,303,12,1,1,' ',0)            
            RETURN
         ELSE
            CALL OPENMSG('P:\DATA\MESSAGES.TXT  ','TXT2MSGS    ',IOCHK)
            GO TO 40
         END IF            
      END IF
      DO 50 I = 1,9999
         MSGLIN = BLANK
         READ(17,'(I4,1X,A78)',END=60,ERR=250) ILINE,MSGLIN
         IF (ILINE.NE.I) THEN
            GO TO 200
         END IF
  50  CONTINUE
  60  CONTINUE
C
C   MESSAGES ARE IN ORDER - CREATE THE NEW FORTRAN MESSAGE FILE AND
C   DELETE THE TEXT FILE.
C
      REWIND (17)  
      CALL LOCATE(19,0,IERR)
C
   80 CONTINUE      
C
C     ** GET MESSAGE NUMBER 290 FROM FORTRAN MESSAGE FILE AND DELETE IT.
C
      OPEN (18,FILE='P:\DATA\MESSAGES.FTN',STATUS='OLD',ACCESS='DIRECT'
     +    ,RECL=78,IOSTAT=IOCHK)
      IF (IOCHK.NE.0) THEN
         CALL OPENMSG('P:\DATA\MESSAGES.FTN  ','TXT2MSGS    ',IOCHK)
         GO TO 80
      END IF 
      READ(18,REC=290) MSGLN1
      WRITE(*,*) MSGLN1
      CLOSE(18,STATUS='DELETE')
C
C     ** OPEN THE NEW FORTRAN MESSAGES FILE 'P:\DATA\MESSAGES.FTN'.  THAT WAY
C        THE FORTRAN MESSAGE FILE WILL NOT CONTAIN THE OLD MESSAGES.
C 
      OPEN (18,FILE='P:\DATA\MESSAGES.FTN',STATUS='UNKNOWN',
     +     ACCESS='DIRECT',RECL=78)
c
      DO 100 I = 1,9999
         READ(17,'(5X,A78)',END=120) MSGLIN
         WRITE(18,REC=I) MSGLIN
         IEND = I
  100 CONTINUE         
  120 CONTINUE
      READ(18,REC=202) MSGLN2
      READ(18,REC=289) MSGLN1
      CLOSE(18)
      CLOSE(17)
      WRITE(MSGLIN,130) IEND,MSGLN1
  130 FORMAT(I3,1X,A65)
      WRITE(*,*) MSGLIN
      WRITE(*,*) MSGLN2
      CALL GETCHAR(0,INCHAR)
      RETURN
C
C   GET HERE IF MESSAGE FILE IS NOT IN PROPER ORDER OR CONTAINS BAD LINE
C   NUMBERS
C      
  200 CONTINUE
      WRITE(ERRLIN,'(BN,I4)') I
      CALL CLS
      CALL WRTMSG(12,146,12,1,0,' ',0)
      CALL WRTMSG(11,147,12,1,0,ERRLIN,4)
      CALL WRTMSG(10,148,12,0,1,' ',0)
      CLOSE(17)
      RETURN
  250 CONTINUE
      WRITE(ERRLIN,'(BN,I4)') I
      CALL CLS
      CALL WRTMSG(12,149,12,1,0,' ',0)
      CALL WRTMSG(11,150,12,1,0,ERRLIN,4)
      CALL WRTMSG(10,148,12,0,1,' ',0)
      CLOSE(17)
      RETURN
      END