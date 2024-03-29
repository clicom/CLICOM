$storage:2

      SUBROUTINE CHKPAS(LEVEL)
C
C   ROUTINE TO ACCEPT A USERID AND CHECK IT AGAINST THE SYSTEM PASSWORD
C   THAT HAS BEEN SET IN THE ENVIRONMENT
C
      CHARACTER*3  LEVEL,HLDLVL(3)
      CHARACTER*2 RTNFLAG
      CHARACTER*12 USER,PASWRD
      DATA HLDLVL /'LO','MED','HI'/
C
      OPEN (4,FILE='P:\DATA\USERS.DAT',STATUS='OLD',FORM='UNFORMATTED')
C
C  READ THE NAME OF THE CURRENT USER
C
      CALL CLS
   20 CONTINUE
      USER = ' '
      CALL WRTMSG(15,425,14,0,0,' ',0)
      CALL DRWBOX(13,8,53,12,2,11,0)      
      CALL LOCATE(10,40,IERR)
      CALL GETSTR(9,USER,12,15,1,RTNFLAG)
      IF (RTNFLAG.EQ.'4F') THEN
         CLOSE(4)
         STOP ' '
      END IF
C
C   CHECK THE NAME AGAINST VALID PASSWORDS (THEY ARE ENCRYPTED BY ADDING
C   99 TO EACH CHARACTER AND STORING THEM AS UNFORMATTED NUMBERS.  TO
C   MAKE IT MORE DIFFICULT TO BREAK SPACES = 237)
C
      DO 100 I = 1,99
         CALL RDUSER(PASWRD,ILEVEL,IEOF)
         IF (IEOF.NE.0) THEN
            GO TO 120
         END IF 
         IF (USER.EQ.PASWRD) THEN
            LEVEL = HLDLVL(ILEVEL)
            CLOSE(4)
            RETURN
            ELSE
         END IF
  100 CONTINUE
  120 CONTINUE
      CALL WRTMSG(13,139,12,1,0,' ',0)
      REWIND (4)
      GO TO 20
      END         
C
      SUBROUTINE RDUSER(PASWRD,ILEVEL,IEOF)
C
C     ROUTINE TO READ AND DECODE THE USER NAME AND LEVEL
C
      CHARACTER*12 PASWRD
      INTEGER*2 ICHR(12)
C
      READ(4,END=120) (ICHR(I),I=1,12),ILEVEL
      DO 50 J = 1,12
         IF (ICHR(J).EQ.237) THEN
            PASWRD(J:J) = ' '
         ELSE
            PASWRD(J:J) = CHAR(ICHR(J)-99) 
         END IF
   50 CONTINUE
      IEOF = 0
      RETURN                
  120 CONTINUE
      IEOF = 1
      RETURN
      END
C----------------------------------------------------------------------
      SUBROUTINE WRTUSER(PASWRD,ILEVEL)
C
C     ROUTINE TO ENCODE AND WRITE THE USER NAME AND LEVEL
C
      CHARACTER*12 PASWRD
      INTEGER*2 ICHR(12)
C
      DO 50 J = 1,12
         IF (PASWRD(J:J).EQ.' ') THEN
            ICHR(J) = 237
         ELSE
            ICHR(J) = ICHAR(PASWRD(J:J)) + 99
         END IF
   50 CONTINUE
      WRITE(4) (ICHR(J),J=1,12),ILEVEL
      IEOF = 0
      RETURN                
  120 CONTINUE
      IEOF = 1
      RETURN
      END
      