$STORAGE:2

      SUBROUTINE SETCFON(IFONT)
C
C   ROUTINE TO SET THE HALO STROKE TEXT FONT TO ONE OF THE FONTS SUPPORTED
C   BY CLICOM.
C
C    IFONT...CLICOM STROKE TEXT FONT NUMBER (1-9)
C
      CHARACTER*3 HFONT(9)
      CHARACTER*24 FILNAME
      DATA FILNAME /'&P:\HALO\HALO000.FNT&'/
      DATA HFONT /'104','105','106','107','202','203','201','204','109'/
C
      FILNAME(14:16) = HFONT(IFONT)
      CALL SETFON(FILNAME)
      RETURN
      END
      