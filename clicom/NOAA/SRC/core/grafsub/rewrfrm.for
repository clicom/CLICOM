$STORAGE:2
      SUBROUTINE REWRFRM(CVAL,RVAL,MXDATROW,NDATROW,IGRAPH,NUMCOL,
     +                   COLHDR,FRMTITLE,FRMSUB,RTNCODE)
C
C       ** INPUT:
C             CVAL.......
C             RVAL.......
C             MXDATROW...MAXIMUM NUMBER OF DATA ROWS -- ARRAY DIMENSION
C             NDATROW....NUMBER OF DATA VALUES IN FRAME
C             NUMCOL.....
C             COLHDR.....
C             FRMTITLE...
C             FRMSUB.....
C       ** OUTPUT:
C             RTNCODE....FLAG TO INDICATE ERROR STATUS
C                        '0'=NO ERROR
C                        '3'=ERROR IN READING FILE
C
      CHARACTER *(*) CVAL(*)
      CHARACTER *(*) FRMTITLE,FRMSUB
      CHARACTER *(*) COLHDR(*)
      REAL*4         RVAL(MXDATROW,*)
      INTEGER*2      NUMCOL
      CHARACTER *1   RTNCODE
C      
$INCLUDE:  'GRFPARM.INC'
C
      CHARACTER*(MXRECL) INREC,BLCRLF
      CHARACTER*1 CHRRTN,LNFEED
C      
      CHRRTN = CHAR(13)
      LNFEED = CHAR(10)
      CALL GTRECL(IGRAPH,NUMCOL,NRECL,NCOLCHR)
      MXCWRT = NRECL-2
      BLCRLF = ' '
      BLCRLF(MXCWRT+1:MXCWRT+2) = CHRRTN//LNFEED
C      
      RTNCODE = '0'
C
C       **  READ FILE POSITION RECORD
C      
      READ(17,REC=1,ERR=910) INREC(1:NRECL)
      READ(INREC,505) NOWFRM
C
C          ** SET FILE TO CURRENT POSITION 
C
      READ(17,REC=NOWFRM) INREC(1:NRECL)
      READ(INREC,505) LSTFRM,NXTFRM,NCURREC
C         
C       ** WRITE TITLE, SUBTITLE, COLUMN HEADERS
C
      IREC = NOWFRM
      INREC = BLCRLF
      IREC=IREC+1
      WRITE(INREC(1:MXCWRT),500) FRMTITLE
      WRITE(17,REC=IREC) INREC(1:NRECL)
C      
      INREC = BLCRLF
      IREC=IREC+1
      WRITE(INREC(1:MXCWRT),500) FRMSUB
      WRITE(17,REC=IREC) INREC(1:NRECL)
C      
      INREC = BLCRLF
      IREC=IREC+1
      WRITE(INREC(1:MXCWRT),510) (COLHDR(I)(1:NCOLCHR),I=1,NUMCOL)
      WRITE(17,REC=IREC) INREC(1:NRECL)
C
C       ** WRITE ONE FRAME OF DATA
C
      NROW = MIN0(NDATROW,NCURREC-3)
      DO 26 I=1,NROW
         INREC = BLCRLF
         IREC=IREC+1
         WRITE(INREC(1:MXCWRT),515) I,CVAL(I),(RVAL(I,J),J=1,NUMCOL)
         WRITE(17,REC=IREC) INREC(1:NRECL)
   26 CONTINUE  
C   
  100 RETURN
C
C       ** ERROR PROCESSING      
C
C       .. ERROR IN READING FILE
  910 CONTINUE
         RTNCODE = '3'
  990 CONTINUE       
      RETURN  
C
C       ** FORMAT STMTS
C
  500 FORMAT(A)
  505 FORMAT(I5,1X,I5,1X,I5)
  510 FORMAT(16X,36(1X,A:))
  515 FORMAT(I3,1X,A12,36(1X,F9.2:))
C
      END        
      