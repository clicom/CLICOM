$STORAGE:2
C
      SUBROUTINE GENRH1(DB,DP,RH)
C
C  CALCULATE RELATIVE HUMIDITY - DRY BULB TEMP AND DEW POINT TEMP
C  ARE REQUIRED
C  DB, DP = TEMPS = DEG C.
C  RH = REL HUM IN WHOLE PERCENT
C
C  CALCULATE RH FROM DB AND DP
C
      RH = ((112.0 - .1*DB + DP)/
     +      (112 + .9 * DB))**8
      RH = RH * 100.0
C
      RETURN
      END
C
