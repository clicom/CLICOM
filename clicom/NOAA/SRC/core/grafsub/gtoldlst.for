$STORAGE:2
      SUBROUTINE GTOLDLST(STNSTAT,MXSTAT,LSTNAM,NSTNLST)
C
      INTEGER*2 MXSTAT,NSTNLST
      INTEGER*4 STNSTAT(MXSTAT)
      CHARACTER*8  LSTNAM
C
      CHARACTER*20 LSTFIL
      CHARACTER*24 LSTABRV
      CHARACTER*8  LSTID
      CHARACTER*1  RTNCODE
C
      IF (LSTNAM.NE.' ' .AND. LSTNAM.NE.'STNGEOG') THEN
         LSTFIL='O:\DATA\'//LSTNAM
         IC=LNG(LSTFIL)
         LSTFIL(IC+1:)='.LST'
         OPEN (51,FILE=LSTFIL,STATUS='OLD',ACCESS='DIRECT',RECL=36)
         CALL CKRECNBR(RTNCODE)
         IF (RTNCODE.NE.'0') THEN
            CALL GTRECNBR(RTNCODE)
         ENDIF   
         READ(51,REC=1) NRECL
         DO 45 IRECL=2,NRECL+1
            READ(51,REC=IRECL) IRECG,LSTID,LSTABRV
            STNSTAT(IRECG) = -1
   45    CONTINUE
         CLOSE(51)
         NSTNLST=NRECL
      ENDIF     
C
      RETURN
      END      
