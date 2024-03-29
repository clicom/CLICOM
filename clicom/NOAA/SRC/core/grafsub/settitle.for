$STORAGE:2
      SUBROUTINE SETTITLE(ITYPE,PREVID,MONNAME,TITLE,SUBTITLE)
C
C   ROUTINE TO SET THE TITLE AND SUBTITLE FIELDS FOR NON-MAP GRAPHICS
C
      CHARACTER*18 PREVID
      CHARACTER*28 TITLE,SUBTITLE
      CHARACTER*24 STNABRV
      CHARACTER*20 DISTRICT
      CHARACTER*12 MONNAME(13)
      CHARACTER*10 STRTTIME
      CHARACTER*8 LON
      CHARACTER*7 LAT
      CHARACTER*1 RTNCODE
      INTEGER*4 NAMDATE
      REAL ELEV
C      
      READ(PREVID,'(8X,I6)') NAMDATE
      NAMDATE = NAMDATE*10 + 01
      CALL RDGEOG(PREVID,NAMDATE,STNABRV,DISTRICT,LAT,LON,ELEV
     +     ,RTNCODE)
      IF (RTNCODE.GT.'1') THEN
         TITLE = PREVID(1:8)
      ELSE
         TITLE = STNABRV
      END IF
      STRTTIME = PREVID(9:18)
      IF (ITYPE.EQ.7) THEN
C          .. USE MOST DETAILED DATE FORMAT FOR UPPER AIR DATA      
         ISPAN=0
      ELSE
C          .. USE LESS DETAILED DATE FORMAT FOR OTHER DATA TYPES      
         ISPAN=1
      ENDIF      
      CALL SPELDATE(ITYPE,ISPAN,STRTTIME,MONNAME,SUBTITLE,28)
      RETURN
      END
