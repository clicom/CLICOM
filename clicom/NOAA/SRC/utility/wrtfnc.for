$STORAGE:2
      SUBROUTINE WRTFNC(ICODE)
C
C   ROUTINE TO WRITE THE FUNCTION DEFINITION LINE AT THE BOTTOM OF THE
C      SCREEN.  THIS ROUTINE HAS BEEN MODIFIED TO SUPPORT EITHER DATAEASE
C      VERSION 2.5 OR DATAEASE VERSION 4.0.
C
C   THE ROUTINE LEAVES THE CURSOR WHERE IT WAS PRIOR TO ITS CALL
C  
      PARAMETER (MAXMSG=36)
      INTEGER*2 ICODE,TXTLEN(MAXMSG) 
      CHARACTER*1 BLANK(80)
      CHARACTER*3 DEVER,SESCF4
      CHARACTER*4 ESCF4
      CHARACTER*14 MSGTXT(MAXMSG),HLDMSG(6)
      CHARACTER*78 MSGLIN
      LOGICAL FIRSTCL
      INTEGER*2 I15,I14,I4,I0,MSGNUM
      DATA I15,I14,I4,I0 /15,14,4,0/
      DATA BLANK/80*' '/, FIRSTCL/.TRUE./
C
C  ON THE FIRST CALL TO THIS ROUTINE READ THE TEXT FOR THE KEY LINES
C
      IF (FIRSTCL) THEN
         FIRSTCL = .FALSE.
         INDEX = 1
         DO 50 MSGNUM = 280,285
            CALL GETMSG(MSGNUM,MSGLIN)
            CALL PARSE1(MSGLIN,78,6,14,HLDMSG,RTNCODE)
            CALL STRIP(HLDMSG,MSGTXT,TXTLEN,INDEX)
            INDEX = INDEX + 6
50       CONTINUE
         CALL GETMSG(999,MSGLIN)
C
C      DETERMINE WHICH VERSION OF DATAEASE IS IN USE
C
         CALL GETDEASE(DEVER)
         IF (DEVER.EQ.'4.0') THEN
             ESCF4 = ' ESC'
             SESCF4 = 'ESC'
         ELSE
             ESCF4 = '  F4'
             SESCF4 = ' F4'
         END IF
      END IF
      
C
C  WRITE THE FUNCTION KEY LINE WANTED
C
      CALL POSLIN(IROW,ICOL)
      CALL LOCATE(24,I0,IERR)
      CALL WRTSTR(BLANK,79,I14,I0)
      CALL LOCATE(24,I0,IERR)

      IF (ICODE.EQ.I0) THEN
         CALL WRTSTR('    ',4,I14,I0)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
      ELSE IF (ICODE.EQ.1) THEN
         CALL WRTSTR(' F2',3,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR('  F5',I4,I14,I0)
         CALL WRTSTR(MSGTXT(4),TXTLEN(4),I15,I4)
         CALL WRTSTR('  F6',I4,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
      ELSE IF (ICODE.EQ.2) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(' F2',3,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(6),TXTLEN(6),I15,I4)
         CALL WRTSTR(' F5',3,I14,I0)
         CALL WRTSTR(MSGTXT(4),TXTLEN(4),I15,I4)
         CALL WRTSTR(' F6',3,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
         CALL WRTSTR(' F7',3,I14,I0)
         CALL WRTSTR(MSGTXT(7),TXTLEN(7),I15,I4)
         CALL WRTSTR(' F8',3,I14,I0)
         CALL WRTSTR(MSGTXT(8),TXTLEN(8),I15,I4) 
      ELSE IF (ICODE.EQ.3) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(' F2',3,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(' F3',3,I14,I0)
         CALL WRTSTR(MSGTXT(9),TXTLEN(9),I15,I4)
         CALL WRTSTR(SESCF4,3,I14,I0)
         CALL WRTSTR(MSGTXT(11),TXTLEN(11),I15,I4)
         CALL WRTSTR(' F5',3,I14,I0)
         CALL WRTSTR(MSGTXT(12),TXTLEN(12),I15,I4)
         CALL WRTSTR(' F7',3,I14,I0)
         CALL WRTSTR(MSGTXT(13),TXTLEN(13),I15,I4)
         CALL WRTSTR(' F8',3,I14,I0)
         CALL WRTSTR(MSGTXT(I14),TXTLEN(I14),I15,I4) 
         CALL WRTSTR(' F9',3,I14,I0)
         CALL WRTSTR(MSGTXT(I15),TXTLEN(I15),I15,I4) 
         CALL WRTSTR(' F10',I4,I14,I0)
         CALL WRTSTR(MSGTXT(16),TXTLEN(16),I15,I4) 
      ELSE IF (ICODE.EQ.4) THEN
         CALL WRTSTR(' F2',3,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(11),TXTLEN(11),I15,I4)
         CALL WRTSTR('  F8',I4,I14,I0)
         CALL WRTSTR(MSGTXT(17),TXTLEN(17),I15,I4) 
      ELSE IF (ICODE.EQ.5) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(' sF1',I4,I14,I0)
         CALL WRTSTR(MSGTXT(18),TXTLEN(18),I15,I4)
         CALL WRTSTR(' F2',3,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(SESCF4,3,I14,I0)
         CALL WRTSTR(MSGTXT(6),TXTLEN(6),I15,I4)
         CALL WRTSTR(' F5',3,I14,I0)
         CALL WRTSTR(MSGTXT(19),TXTLEN(19),I15,I4)
         CALL WRTSTR(' F6',3,I14,I0)
         CALL WRTSTR(MSGTXT(20),TXTLEN(20),I15,I4)
         CALL WRTSTR(' F7',3,I14,I0)
         CALL WRTSTR(MSGTXT(21),TXTLEN(21),I15,I4)
         CALL WRTSTR(' F8',3,I14,I0)
         CALL WRTSTR(MSGTXT(I14),TXTLEN(I14),I15,I4) 
         CALL WRTSTR(' F9',3,I14,I0)
         CALL WRTSTR(MSGTXT(22),TXTLEN(22),I15,I4)
      ELSE IF (ICODE.EQ.6) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(' sF1',I4,I14,I0)
         CALL WRTSTR(MSGTXT(10),TXTLEN(10),I15,I4)
         CALL WRTSTR(' F2',3,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR('  F3',I4,I14,I0)
         CALL WRTSTR(MSGTXT(23),TXTLEN(23),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR('  F5',I4,I14,I0)
         CALL WRTSTR(MSGTXT(4),TXTLEN(4),I15,I4)
         CALL WRTSTR('  F6',I4,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
      ELSE IF (ICODE.EQ.7) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR('  F2',I4,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR('  F5',I4,I14,I0)
         CALL WRTSTR(MSGTXT(4),TXTLEN(4),I15,I4)
         CALL WRTSTR('  F6',I4,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
      ELSE IF (ICODE.EQ.8) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
      ELSE IF (ICODE.EQ.9) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(' sF1',I4,I14,I0)
         CALL WRTSTR(MSGTXT(10),TXTLEN(10),I15,I4)
         CALL WRTSTR('  F2',I4,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR('  F5',I4,I14,I0)
         CALL WRTSTR(MSGTXT(4),TXTLEN(4),I15,I4)
         CALL WRTSTR('  F6',I4,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
      ELSE IF (ICODE.EQ.10) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(' F2',3,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(' F3',3,I14,I0)
         CALL WRTSTR(MSGTXT(24),TXTLEN(24),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(11),TXTLEN(11),I15,I4)
         CALL WRTSTR(' F7',3,I14,I0)
         CALL WRTSTR(MSGTXT(27),TXTLEN(27),I15,I4)
         CALL WRTSTR(' PgUp',5,I14,I0)
         CALL WRTSTR(MSGTXT(25),TXTLEN(25),I15,I4)
         CALL WRTSTR(' PgDn',5,I14,I0)
         CALL WRTSTR(MSGTXT(26),TXTLEN(26),I15,I4)
      ELSE IF (ICODE.EQ.11) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(' sF1',I4,I14,I0)
         CALL WRTSTR(MSGTXT(10),TXTLEN(10),I15,I4)
         CALL WRTSTR('  F2',I4,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR('  F6',I4,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
      ELSE IF (ICODE.EQ.12) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR('  F2',I4,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR('  F5',I4,I14,I0)
         CALL WRTSTR(MSGTXT(4),TXTLEN(4),I15,I4)
         CALL WRTSTR('  F6',I4,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
         CALL WRTSTR(' PgDn',5,I14,I0)
         CALL WRTSTR(MSGTXT(29),TXTLEN(29),I15,I4)
      ELSE IF (ICODE.EQ.13) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR('  F2',I4,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR('  F5',I4,I14,I0)
         CALL WRTSTR(MSGTXT(4),TXTLEN(4),I15,I4)
         CALL WRTSTR('  F6',I4,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
         CALL WRTSTR(' PgUp',5,I14,I0)
         CALL WRTSTR(MSGTXT(30),TXTLEN(30),I15,I4)
      ELSE IF (ICODE.EQ.14) THEN
         CALL WRTSTR(' F2',3,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
      ELSE IF (ICODE.EQ.15) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR('  F2',I4,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR('  F3',I4,I14,I0)
         CALL WRTSTR(MSGTXT(23),TXTLEN(23),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR(' F6',3,I14,I0)
         CALL WRTSTR(MSGTXT(20),TXTLEN(20),I15,I4)
      ELSE IF (ICODE.EQ.16) THEN
         CALL WRTSTR(' F1',3,I14,I0)
         CALL WRTSTR(MSGTXT(1),TXTLEN(1),I15,I4)
         CALL WRTSTR(' sF1',I4,I14,I0)
         CALL WRTSTR(MSGTXT(10),TXTLEN(10),I15,I4)
         CALL WRTSTR('  F2',I4,I14,I0)
         CALL WRTSTR(MSGTXT(2),TXTLEN(2),I15,I4)
         CALL WRTSTR(' sF2',I4,I14,I0)
         CALL WRTSTR(MSGTXT(31),TXTLEN(31),I15,I4)
         CALL WRTSTR(ESCF4,4,I14,I0)
         CALL WRTSTR(MSGTXT(3),TXTLEN(3),I15,I4)
         CALL WRTSTR('  F6',I4,I14,I0)
         CALL WRTSTR(MSGTXT(5),TXTLEN(5),I15,I4)
      ELSE
         CALL WRTMSG(1,53,12,1,I0,' ',I0)
      END IF
      CALL LOCATE(IROW,ICOL,IERR)
      RETURN
      END
$PAGE
************************************************************************
      SUBROUTINE STRIP(HLDMSG,MSGTXT,TXTLEN,ISTRT)
C
C   ROUTINE TO STRIP QUOTATION MARKS FROM TEXT STRINGS
C
      CHARACTER*14 HLDMSG(6),MSGTXT(30)
      INTEGER*2 TXTLEN(30)
      LOGICAL FIRST
C
      DO 150 J = 1,6
         J1 = ISTRT + J - 1
         MSGTXT(J1) = ' '
         I1 = 0
         FIRST = .TRUE.
         DO 100 I = 1,14
            IF (HLDMSG(J)(I:I).EQ.'''') THEN
               IF (.NOT.FIRST) THEN
                  GO TO 120
               ELSE 
                  FIRST = .FALSE.
               END IF
            ELSE
               I1 = I1 + 1
               MSGTXT(J1)(I1:I1) = HLDMSG(J)(I:I)
            END IF
  100    CONTINUE
  120    CONTINUE
         TXTLEN(J1) = I1
  150 CONTINUE    
      RETURN
      END
