$STORAGE:2

      SUBROUTINE OPENQC (ITYPE,RECTYPE,RTNFLAG)
C
C   ROUTINE TO OPEN THE KEY ENTRY/QC FILE FOR THE RECTYPE SPECIFIED.
C   IT REQUESTS THE DATASET-ID NEEDED FROM THE USER.
C
C   Input:  
C           ITYPE.....1 - 7 WHERE 1 = MLY, 2 = 10D, ETC
C           RECTYPE...'MLY','DLY',etc
C   Output: RTNFLAG...'4F' If user pressed F4 when asked for the
C                     DATASET-ID - No file opened.
C
$INCLUDE: 'INDEX.INC'
$INCLUDE: 'VAL1.INC'
      CHARACTER*3 RECTYPE,DDSID
      CHARACTER*2 RTNFLAG,HOURLBL(24)
      CHARACTER*1 RTNCODE
      INTEGER*2 ITYPE,DSETID
C
      CALL POSLIN(IROW,ICOL)
      JROW = IROW + 9
20    CONTINUE
      CALL LOCATE(JROW,13,IERR)
      CALL WRTSTR('Dataset-Id: ',12,14,0)
      CALL GETSTR(3,DDSID,3,15,1,RTNFLAG)
      IF (DDSID.EQ.'  '.OR.RTNFLAG.EQ.'4F') THEN
         RETURN
      END IF
C
C   LOAD THE SETUP FILE, LOAD THE ELEMENT CODES AND COLUMN HEADERS, AND
C   NAME THE DATA AND INDEX FILES.
C
      READ(DDSID,'(I3)') DSETID
      CALL GETSET(DSETID,ITYPE,RECTYPE,HOURLBL,RTNCODE)
      IF (RTNCODE.NE.'0') THEN
         GO TO 20      
      END IF
C
C   OPEN THE DATA AND INDEX FILES 
C
      CALL OPENFILES(1)
      RETURN
      END
