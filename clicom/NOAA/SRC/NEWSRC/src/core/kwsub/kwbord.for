C
C
C
       SUBROUTINE  KWBORD
       COMMON /KWLIM/    XLF,XRT,YBT,YTP 
C
       CALL KIQDST(JMPSAV,DST)
       IJMP = 0
       CALL KSTDST(IJMP,DST)
C
       IP3 = 3
       IP2 = 2
       CALL KWDEV (XLF,YBT,IP3)
       CALL KWDEV (XLF,YTP,IP2)
       CALL KWDEV (XRT,YTP,IP2)
       CALL KWDEV (XRT,YBT,IP2)
       CALL KWDEV (XLF,YBT,IP2)
C
       CALL KSTDST(JMPSAV,DST)
C
       RETURN
       END
