$STORAGE:2
C     PROGRAM BLDQCINF
C
C   THIS ROUTINE (BUILD-QC-INFO) READS THE DATAEASE STN HISTORY FILES
C       AND BUILDS THE 3 QC FILES WHICH CONTAIN STATION INFORMATION.
C       THE THREE QC FILES CREATED ARE STNGEOG.INF,STNELEM.INF, AND 
C       ELEM.LIM
C       IT ALSO REBUILDS THE ELEMENT DEFINITION FILE (ELEM.DEF) IF
C       THE ELEMENT DEFINITION FILE HAS BEEN MODIFIED.
C
C  DEFINE THE INTERFACE TO THE SYSTEM FUNCTIONS TO DO DIR
C
$INCLUDE: 'SYSINT.INC'      
************************************************************************
      PROGRAM BLDQCINF
      CHARACTER*78 MSGLN5,MSGLN6
      CHARACTER*2 RDISK
      CHARACTER*22 FILNAME,FLNAM2,BATFIL
      CHARACTER*16 DDISK
      INTEGER*2 FLEN,MATCH,EFLAG
      INTEGER*4 NUMREC
C
C   READ THE MESSAGE LINES TO BE PRINTED
C
      CALL GETMSG(205,MSGLN5)
      CALL GETMSG(208,MSGLN6)
      CALL GETMSG(999,MSGLN6)
C
C   FIND THE DISK DRIVE LETTERS FOR THE RAMDISK AND ALTERNATE HARD
C   DISK DRIVES - IF PRESENT
C
      ILEN = 2
      CALL GETDSC(RDISK,DDISK,ILEN)
      BATFIL = '  \DATA\BATCTRL. '
      BATFIL(1:2) = RDISK
C
C   READ AND CHECK THE FILE INFORMATION FOR GEOGRAPHIC DATA
C
      CALL CLS
      CALL LOCATE(1,0,IERR)
C
C   FIND THE NAME OF THE DATAEASE STN GEOGRAPHY FILE
C
      CALL FNDFIL('STN GEOGRAPHY           ',FILNAME,NUMREC)
      IF (FILNAME.EQ.'      ') THEN
         STOP
      END IF
      
      FLEN = 0
      DO 30 I = 1,22
          IF (FILNAME(I:I).NE.' ') THEN
              FLEN = FLEN + 1
          ELSE
              GOTO 35
          END IF
   30 CONTINUE
   35 FLEN = FLEN + 1
      FILNAME(FLEN:FLEN) = CHAR (0)       
   
      FLNAM2 = 'P:\DATA\STNGEOG.INF'
      FLNAM2(20:20) = CHAR(0)
      
      MATCH = 0
C
      OPEN(35,FILE=FLNAM2,STATUS='OLD',FORM='BINARY',IOSTAT=IOCHK)
      IF (IOCHK.EQ.0) THEN
         CLOSE (35)
         CALL MATFIL(FILNAME,FLNAM2,MATCH,EFLAG)
      ENDIF
      IF (MATCH.EQ.0) THEN
         BATFIL(17:17) = '1'
         OPEN(61,FILE=BATFIL,STATUS='UNKNOWN')
         CLOSE(61)
      END IF 
C
C   READ AND CHECK THE FILE INFORMATION FOR STN ELEMENT DATA
C
      CALL FNDFIL('STN ELEMENT             ',FILNAME,NUMREC)
      IF (FILNAME.EQ.'      ') THEN
         STOP
      END IF

      FLEN = 0
      DO 40 I = 1,22
          IF (FILNAME(I:I).NE.' ') THEN
              FLEN = FLEN + 1
          ELSE
              GOTO 45
          END IF
   40 CONTINUE
   45 FLEN = FLEN + 1
      FILNAME(FLEN:FLEN) = CHAR (0)       
   
      FLNAM2 = 'P:\DATA\STNELEM.INF'
      FLNAM2(20:20) = CHAR(0)
      
      MATCH = 0
C
      OPEN(32,FILE=FLNAM2,STATUS='OLD',FORM='BINARY',IOSTAT=IOCHK)
      IF (IOCHK.EQ.0) THEN
         CLOSE (32)
         CALL MATFIL(FILNAME,FLNAM2,MATCH,EFLAG)
      ENDIF
      IF (MATCH.EQ.0) THEN
         BATFIL(17:17) = '2'
         OPEN(61,FILE=BATFIL,STATUS='UNKNOWN')
         CLOSE(61)
      END IF 
C
C   READ AND CHECK THE FILE INFORMATION FOR STN ELEMENT EXTREMES
C
      CALL FNDFIL('STN ELEMENT EXTREMES    ',FILNAME,NUMREC)
      IF (FILNAME.EQ.'      ') THEN
         STOP
      END IF

      FLEN = 0
      DO 50 I = 1,22
          IF (FILNAME(I:I).NE.' ') THEN
              FLEN = FLEN + 1
          ELSE
              GOTO 55
          END IF
   50 CONTINUE
   55 FLEN = FLEN + 1
      FILNAME(FLEN:FLEN) = CHAR (0)       
   
      FLNAM2 = 'P:\DATA\ELEM.LIM'
      FLNAM2(17:17) = CHAR(0)
      
      MATCH = 0
C
      OPEN(31,FILE=FLNAM2,STATUS='OLD',FORM='BINARY',IOSTAT=IOCHK)
      IF (IOCHK.EQ.0) THEN
         CLOSE (31)
         CALL MATFIL(FILNAME,FLNAM2,MATCH,EFLAG)
      ENDIF
      IF (MATCH.EQ.0) THEN
         BATFIL(17:17) = '3'
         OPEN(61,FILE=BATFIL,STATUS='UNKNOWN')
         CLOSE(61)
      END IF 
C
C   READ AND CHECK THE FILE INFORMATION FOR ELEMENT DEFINITIONS
C
      CALL FNDFIL('ELEMENT DEFINITION      ',FILNAME,NUMREC)
      IF (FILNAME.EQ.'      ') THEN
         STOP
      END IF
      
      FLEN = 0
      DO 60 I = 1,22
          IF (FILNAME(I:I).NE.' ') THEN
              FLEN = FLEN + 1
          ELSE
              GOTO 65
          END IF
   60 CONTINUE
   65 FLEN = FLEN + 1
      FILNAME(FLEN:FLEN) = CHAR (0)       
   
      FLNAM2 = 'P:\DATA\ELEM.DEF'
      FLNAM2(17:17) = CHAR(0)
      
      MATCH = 0
C
      OPEN(30,FILE=FLNAM2,STATUS='OLD',FORM='BINARY',IOSTAT=IOCHK)
      IF (IOCHK.EQ.0) THEN
         CLOSE (30)
         CALL MATFIL(FILNAME,FLNAM2,MATCH,EFLAG)
      ENDIF
      IF (MATCH.EQ.0) THEN 
         CALL BLDELDEF(FILNAME,MSGLN5,MSGLN6)
      END IF 
      STOP ' '
      END
$PAGE
***********************************************************************
      SUBROUTINE BLDELDEF(FILNAME,MSGLN1,MSGLN2)
C
C    THIS SUBROUTINE READS THE DATAEASE ELEMENT DEFINITION FILE
C       AND WRITES THE INFORMATION TO TO A DIRECT FILE FOR USE BY
C       THE CLICOM QC ROUTINES.
C       THE INPUT DATA IS READ AS AN UNFORMATTED BINARY FILE,
C       READING ALL INPUT INTO THE CHARACTER ARRAY INREC.  THE 
C       VARIABLES WITHIN THE RECORD ARE EQUIVALENCED TO THE 
C       APPROPRIATE POSITION WITHIN INREC.
C
      CHARACTER*1 INREC(97),RTNCODE,INUNITS
      CHARACTER*1 ELABRV(6),ELNAME(16),ELDEFN(60),NULL
      CHARACTER*3 ELEM
      CHARACTER*8 INSCALE,CHRSCALE
      CHARACTER*22 FILNAME,HLDNAME
      CHARACTER*20 ELUNITS, UNITDEF(99)
      CHARACTER*78 MSGLN1, MSGLN2
      INTEGER*2 IUNITS,IELEM
      REAL*8 SCALE8
      REAL*4 SCALE4 
      INTEGER*2 HEADER(2)
C
C    EQUIVALENCE THE INPUT VARIABLES TO THE INPUT RECORD STRING
C
      EQUIVALENCE (HEADER,INREC(1)),(ELEM,INREC(4)),
     +            (ELNAME,INREC(7)),(ELABRV,INREC(23)),
     +            (ELDEFN,INREC(29)),(INUNITS,INREC(89)),
     +            (INSCALE,INREC(90))
      EQUIVALENCE (CHRSCALE,SCALE8)
C
      DATA UNITDEF/99*'                    '/
      NULL = CHAR(0)
C
C   READ THE MESSAGES TO BE PRINTED FROM THE MESSAGE FILE AND PRINT'EM
C
      WRITE(*,*) MSGLN1
      WRITE(*,*) MSGLN2
      WRITE(*,*)
C     
C   GET THE ELEMENT UNITS 
C
      HLDNAME = FILNAME
      CALL GETDEF(UNITDEF,HLDNAME,RTNCODE)
      IF (RTNCODE.NE.'0') THEN
         RETURN
      END IF
C      
C   OPEN THE FILES AND BUILD THE OUTPUT FILE
C
   20 CONTINUE
      OPEN (29,FILE=FILNAME,STATUS='OLD',FORM='BINARY',IOSTAT=IOCHK)
      IF(IOCHK.NE.0) THEN
         CALL OPENMSG(FILNAME,'BLDQCINF    ',IOCHK)
         GO TO 20
      END IF   
C
      OPEN (30,FILE='P:\DATA\ELEM.DEF',STATUS='OLD',
     +         ACCESS='DIRECT',RECL=110,IOSTAT=IOCHK)
      IF (IOCHK.EQ.0) THEN
C          .. DELETE FILE IF IT EXISTS
         CLOSE(30,STATUS='DELETE')
      ELSE IF (IOCHK.NE.6416) THEN
C          .. EXIT PROGRAM IF ERROR IS ANYTHING EXCEPT 'FILE NOT FOUND'
         CALL OPENMSG('P:\DATA\ELEM.DEF','BLDQCINF     ',IOCHK)
         STOP ' '
      END IF
C       .. START WITH AN EMPTY FILE      
      OPEN (30,FILE='P:\DATA\ELEM.DEF',STATUS='NEW',
     +         ACCESS='DIRECT',RECL=110)
C
      NCOUNT = 0
      DO 100 I1 = 1,9999
   40    CONTINUE
         READ(29,END=200) INREC
         IF (HEADER(1).EQ.13 .OR. HEADER(1).EQ.15) GO TO 40
         READ(ELEM,'(I3)') IELEM
         IUNITS = ICHAR(INUNITS)
         ELUNITS = UNITDEF(IUNITS)
         CHRSCALE = INSCALE
         SCALE4 = SCALE8 
         DO 50 I2 = 1,16
            IF (ELNAME(I2).EQ.NULL) THEN
               ELNAME(I2) = ' '
            END IF
   50    CONTINUE
         DO 60 I2 = 1,6
            IF (ELABRV(I2).EQ.NULL) THEN
               ELABRV(I2) = ' '
            END IF
   60    CONTINUE
         DO 70 I2 = 1,60
            IF (ELDEFN(I2).EQ.NULL) THEN
               ELDEFN(I2) = ' '
            END IF
   70    CONTINUE
         NCOUNT = NCOUNT + 1
         WRITE(30,REC=IELEM) ELEM,ELNAME,ELABRV,ELDEFN,ELUNITS,SCALE4
  100 CONTINUE
  200 CONTINUE
      CLOSE(29)
      CLOSE(30)
      WRITE(*,250) NCOUNT
  250 FORMAT(I5,' Element Definition Records Written',//)
      RETURN
      END
$PAGE         
***********************************************************************

      SUBROUTINE GETDEF(UNITDEF,FILNAME,RTNCODE)
C
C   SUBROUTINE TO READ THE FORM DEFINITION FILE OF THE ELEMENT
C       DEFINITION FORM TO DETERMINE THE VALUES OF THE CHOICE FIELD
C       "UNIT-CODES"
C
      CHARACTER*20 UNITDEF(99)
      CHARACTER*22 FILNAME
      CHARACTER*10 UNITCODES
      CHARACTER*1 NULL,INCHAR,RTNCODE
C
      DATA UNITCODES/'UNIT-CODES'/
      NULL = CHAR(0)
      RTNCODE = '0'
      FILNAME(14:14) = 'A'
   20 CONTINUE
      OPEN (23,FILE=FILNAME,STATUS='OLD',FORM='BINARY',
     +  IOSTAT=IOCHK)
      IF(IOCHK.NE.0) THEN
         CALL OPENMSG(FILNAME,'BLDQCINF    ',IOCHK)
         GO TO 20
      END IF   
C
C   FIRST FIND THE BEGINNING OF THE UNIT-CODES CHOICE FIELD DEFINITIONS
C
      DO 100 I=1,9999
         READ(23,END=400) INCHAR
         IF (INCHAR.EQ.'U') THEN
            DO 50 I1 = 2,10
               READ(23,END=400) INCHAR
               IF (INCHAR.NE.UNITCODES(I1:I1)) THEN
                  GO TO 100
               END IF
   50       CONTINUE
            GO TO 110
         END IF
  100 CONTINUE
      CALL WRTMSG(4,106,12,1,1,' ',0)
      RTNCODE = '1'
      GO TO 600
  110 CONTINUE
C
C  THE DEFINITIONS HAVE BEEN FOUND - FIND OUT HOW MANY THERE ARE
C     AND LOAD THEM INTO UNITDEF 
C
      CALL RDDEFS(23,'UNIT-CODES    ',UNITDEF,RTNCODE)
      GO TO 600
C
C   GET HERE IF AN UNEXPECTED EOF IS READ
C
  400 CONTINUE 
      CALL WRTMSG(4,107,12,1,1,' ',0)
      RTNCODE = '1'
C
C    DONE - CLOSE FILE AND RETURN
C
  600 CONTINUE
      CLOSE(23)
      RETURN
      END
