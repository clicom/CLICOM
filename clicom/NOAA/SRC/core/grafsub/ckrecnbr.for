$STORAGE:2
      SUBROUTINE CKRECNBR(RTNCODE)
C
      CHARACTER*1 RTNCODE
C      
      CHARACTER*24 STNABRV,LSTABRV
      CHARACTER*20 COUNTRY
      CHARACTER*8  STNID,LSTID
      CHARACTER*8 INLON
      CHARACTER*7 INLAT
      INTEGER*4 BDATE,EDATE,NRECG
C
C  OPEN THE STNGEOG.INF FILE AND INITIALIZE
C
20    OPEN (35,FILE='P:\DATA\STNGEOG.INF',STATUS='OLD',
     +      ACCESS='DIRECT',RECL=80,SHARE='DENYWR',MODE='READ'
     +      ,IOSTAT=IOCHK)
      IF (IOCHK.NE.0) THEN
         CALL OPENMSG('P:\DATA\STNGEOG.INF   ','GRAFINIT    ',IOCHK)
         GO TO 20
      END IF
      READ(35,REC=1) NRECG
C
      READ(51,REC=1) NRECL      
C      
      RTNCODE='1'      
      DO 30 IRECL=2,NRECL+1
         READ(51,REC=IRECL) LSTREC,LSTID,LSTABRV
         READ(35,REC=LSTREC) STNID,BDATE,EDATE,STNABRV,COUNTRY,
     +                       INLAT,INLON
         IF (STNID.NE.LSTID) GO TO 40
   30 CONTINUE
      RTNCODE='0'      
   40 CONTINUE
C
      CLOSE (35)
      RETURN
      END   