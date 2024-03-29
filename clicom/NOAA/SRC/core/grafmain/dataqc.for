$STORAGE:2
      PROGRAM DATAQC
C
C   THIS ROUTINE PROVIDES ACCESS TO THE DATAQC AND AREA QC MODULES
C      FIRST IT SOLICITS THE TYPE OF DATA TO USE, THEN IT ASKS FOR
C      THE PROCESSING CHOICE DESIRED
C
C------------------------------------------------------------------------
C   SPECIAL INSTRUCTIONS FOR LINKING THIS ROUTINE WITH ITS SUBROUTINES
C
C  THIS ROUTINE REQUIRES OVERLAY LINKING TO PRODUCE A MODULE THAT FITS
C  WITHIN CLICOM MEMORY LIMITS (330K).  THEREFORE, YOU MUST USE LINK 
C  BATCH FILE LDATAQC. SEE LDATAQC.BAT AND LDATAQC.LNK FOR MORE INFORMATION.
C------------------------------------------------------------------------
C
      CHARACTER*2 PROCTYPE,TBLPROC(3),HLDAUT
      CHARACTER*3 TBLRECTYP(7),RECTYPE,OLDTYP
      CHARACTER*4 INLVL
      CHARACTER*12 MENUNAME
      CHARACTER*21 IDKEY
      CHARACTER*64 HELPFILE
C
      INTEGER*2 RESULT,TBLNUMLINE(7),ITYPE,IELEM,ILINE,OLDDDS
$INCLUDE: 'VAL1.INC'
C
      DATA TBLRECTYP  /'MLY','10D','DLY','SYN','HLY','15M','U-A'/
     +    ,TBLNUMLINE /12,36,31,8,24,96,100/
     +    ,TBLPROC /'DE','ED','AC'/,OLDTYP /'AAA'/
      DATA HELPFILE /'P:\HELP\KE-QC-1.HLP'/
C
      CALL SETMOD(3,IERR)
C
C   DETERMINE THE LEVEL OF AUTHORITY FOR THE CURRENT USER
C
      CALL GETAUT(INLVL)
      IF (INLVL.EQ.'HI  '.OR.INLVL.EQ.'MED ') THEN
         HLDAUT = 'QC'
      ELSE
         HLDAUT = 'DE'        
      END IF   
C
C     DISPLAY THE DATA SET CHOICES
C
      IROW = 5
      IF (HLDAUT.EQ.'QC') THEN
         ICOL = 8
      ELSE
         ICOL = 22
      END IF      
 200  CONTINUE
      CALL CLS
      CALL LOCATE(IROW,ICOL,IERR)
      MENUNAME = 'DR-DATATYPES'
      CALL GETMNU(MENUNAME,'  ',ITYPE)
      IF (ITYPE.EQ.0)THEN
         CALL LOCATE(23,0,IERR)
         STOP ' '
      END IF
      RECTYPE = TBLRECTYP(ITYPE)
      NUMLINE = TBLNUMLINE(ITYPE)
      IF (RECTYPE.NE.OLDTYP) THEN
         OLDTYP = RECTYPE
         OLDDDS = -999
      END IF
C
C     DISPLAY PROCESSING TYPE CHOICES
C
      IF (HLDAUT.EQ.'QC') THEN   
         CALL LOCATE(IROW,48,IERR)
         MENUNAME = 'DR-PROC-OPTN'
         CALL GETMNU(MENUNAME,HELPFILE,RESULT)
         IF (RESULT.EQ.0) THEN
            GO TO 200
         END IF
         PROCTYPE = TBLPROC(RESULT)
      ELSE
         PROCTYPE = 'DE'
      END IF
C
C   CALL THE SELECTED PROCESSING MODULE
C
      IF (PROCTYPE.EQ.'DE') THEN
         PASSWD = 'DE'
      ELSE
         PASSWD = 'QC'
      END IF
C
      IF (PROCTYPE.NE.'AC')THEN
         IDKEY = ' '
         IELEM = 1
         ILINE = 1
         CALL EDIT(ITYPE,RECTYPE,IDKEY,IELEM,ILINE,OLDDDS)
      ELSE 
         CALL AREAQC(ITYPE,RECTYPE,OLDDDS)
      END IF
      GO TO 200
C
      END
