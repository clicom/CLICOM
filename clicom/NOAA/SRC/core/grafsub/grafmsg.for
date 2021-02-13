$STORAGE:2
      SUBROUTINE GRAFMSG(XWIN,YWIN,MSGN1,MSGN2,MSGTXT,LENMSG,FLDTYPE,
     +                  LNRESP,OUTTXT,LENOUT)
C------------------------------------------------------------------------------
C     DISPLAY A 2-LINE MESSAGE IN A GRAPHICS WINDOW.  TEXT MAY BE APPENDED
C     TO THE FIRST LINE OF THE MESSAGE. THE USER RESPONSE IS VALIDATED AS IT
C     IS BEING ENTERED BASED UPON THE FLDTYPE THAT IS PASSED TO GRAFMSG.
C     NUMERIC FIELDS REQUIRE +  - SIGNS TO BE THE 1ST CHARACTER IN THE FIELD.
C
C     INPUT ARGUMENTS: 
C
C     XWIN,YWIN    REAL   LOWER LEFT WINDOW CORNER (NORMALIZED DEVICE COORDS)
C     MSGN1,MSGN2  INT2   MESSAGE NUMBERS IN THE MESSAGES FILE TO DISPLAY
C     MSGTXT       CHAR   TEXT TO BE APPENDED TO MESSAGE 1
C     LENMSG       INT2   LENGTH OF MSGTXT:  0 = NO MESSAGE APPENDED
C     FLDTYPE      INT2   TYPE OF STRING TO ACCEPT FROM USER
C                         0 = ALPHA CHARACTER - CONVERT TO UPPER CASE
C                         1 = ALPHA CHARACTER - DO NOT CONVERT TO UPPER CASE
C                         3 = INTEGER NUMBER
C                         4 = REAL (FLOATING PT) NUMBER
C     LNRESP       INT2   LENGTH OF STRING TO ACCEPT FROM USER. 
C
C     OUTPUT ARGUMENTS:
C
C     OUTTXT       CHAR   USER RESPONSE TO MESSAGE, 75 CHARACTER MAXIMUM
C     LENOUT       INT2   ACTUAL LENGTH OF TEXT STRING IN OUTTXT
C------------------------------------------------------------------------------
C  ---> MAXIMUM OF 75 CHARACTERS FOR EACH LINE  <---
      PARAMETER (MAXMSG=75)
C
      INTEGER*2     MSGN1, MSGN2, LENMSG, FLDTYPE, LNRESP, LENOUT
      CHARACTER*(*) MSGTXT
      CHARACTER*(*) OUTTXT
C      
C       ** LOCAL COMMON TO SAVE SPACE IN D-GROUP
C
      INTEGER*2    LEN1, LEN2
      REAL         HEIGHT,WIDTH,XOLD,YOLD,XNOW,YNOW,XPOS,YPOS,XNOTE,
     +             YNOTE
      LOGICAL      DECMPT
      CHARACTER*45 RTNTEXT, TESTLINE
      CHARACTER*78 MESSAGE,TXTLINE(3)
      CHARACTER*3  TXTCHR
      CHARACTER*2  INCHAR, DUMCHR
      COMMON /GMSGSV/ LEN1,LEN2, HEIGHT,WIDTH,XPOS,YPOS,XOLD,YOLD,
     +                XNOW,YNOW,XNOTE,YNOTE, RTNTEXT,TESTLINE,MESSAGE,
     +                TXTLINE,TXTCHR,INCHAR
C     
      TXTCHR = '^ ^'
      TESTLINE = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
C
C   DETERMINE AND SAVE THE CURRENT VIEWPORT, COORDINATES,CROSS-HAIR
C   CURSOR LOCATION AND XOR MODE
C
      CALL INQVIE(XN1,YN1,XN2,YN2)
      CALL INQWOR(X1OLD,Y1OLD,X2OLD,Y2OLD)
      CALL INQHCU(XOLD,YOLD,IDUMMY)
      CALL INQXOR(IXOR)
      CALL SETXOR(0)
C
C   SET THE HALO DOT TEXT SIZE FOR THE HELP WINDOW AND POSITION OF GRAFNOTE
C
      CALL INQDRA(MAXX,MAXY)
      IF (MAXY.GT.350) THEN
         CALL SETTEX(2,1,0,1)
      ELSE
         CALL SETTEX(1,1,0,1)
      END IF

      IF (XWIN .GT. 0.5) THEN
         XNOTE = 0.1
      ELSE 
         XNOTE = 0.5
      ENDIF
      IF (YWIN .GT. 0.5) THEN
         YNOTE = 0.2
      ELSE
         YNOTE = 0.8
      ENDIF
C
C   READ THE MESSAGES TO BE PRINTED INTO TXTLINE 
C
      MESSAGE = '   '
      CALL GETMSG(MSGN1,MESSAGE)
      LEN1 = LNG(MESSAGE)
      IF (LENMSG.GT.0) THEN
         ICHR = MIN0(LEN1+1,MAXMSG-LENMSG+1)
         MESSAGE(ICHR:)=MSGTXT(1:LENMSG)
         LEN1=MIN0(LEN1+LENMSG,MAXMSG)
      ENDIF   
      CALL DELIMSTR(MESSAGE,TXTLINE(1))
      MESSAGE = '   '
      CALL GETMSG(MSGN2,MESSAGE)
      LEN2 = LNG(MESSAGE) 
      MESSAGE = MESSAGE(1:LEN2) // TESTLINE(1:LNRESP)
      LEN2 = LEN2 + LNRESP
      CALL DELIMSTR(MESSAGE,TXTLINE(2))
      CALL DELIMSTR(TESTLINE(1:LNRESP),TXTLINE(3))
      CALL GETMSG(999,TESTLINE)
C
C  DETERMINE HOW MUCH SPACE IS REQUIRED FOR THIS MENU IN THE CURRENT
C  WORLD COORD SYSTEM AND DEFINE WINDOW BIG ENOUGH TO HOLD IT.
C  ADD 2% OF SCREEN TO WINDOW SIZE TO ACCOUNT FOR WINDOW BORDER AND SHADOWS.
C
C       .. IN ORDER TO OPEN THE VIEWPORT TO THE ENTIRE SCREEN, A MAX VALUE
C          EQUAL TO .999 MUST BE USED.  A VALUE OF 1.0 IS A SPECIAL SIGNAL FOR
C          HALO TO 'TURN OFF' THE VIEWPORT WHICH DOES NOT RESET ASPECT RATIOS
      CALL SETVIE(0.,0.,0.999,0.999,-1,-1)
      CALL SETWOR(X1OLD,Y1OLD,X2OLD,Y2OLD)
      CALL MOVHCA(XOLD,YOLD)

      IF (LEN1 .GT. LEN2) THEN
         CALL INQTSI(TXTLINE(1),HEIGHT,WIDTH)
      ELSE
         CALL INQTSI(TXTLINE(2),HEIGHT,WIDTH)
      ENDIF
      XWORLD = WIDTH + X1OLD 
      YWORLD = HEIGHT*2. + Y1OLD
      CALL MAPWTN(XWORLD,YWORLD,XWIN2,YWIN1)
      XWIN2 = XWIN2 + .02
      YWIN2 = 1.03 - YWIN1 
C
C   OPEN THE TEXT WINDOW 
C
      XWIN1 = XWIN
      XWIN2 = XWIN1 + XWIN2
      YWIN1 = YWIN - YWIN2
      YWIN2 = YWIN
      CALL GRAFWIN(1,XWIN1,YWIN1,XWIN2,YWIN2)
C
C   FIND TEXT HEIGHT IN WINDOW COORDS.
C
      CALL INQTSI(TXTLINE(1),HEIGHT,WIDTH)
C
C  DISPLAY THE MESSAGES IN THE WINDOW 
C
      CALL INQWOR(XLOW,YLOW,XHIGH,YHIGH)
      I1 = 0
      ISTRT = 1
      IEND  = 2
      CALL SETCOL(3)
      CALL CLR
      CALL SETTCL(1,3)
      XPOS = XLOW
      DO 100 I = ISTRT,IEND
         I1 = I1 + 1
         YPOS = YHIGH - I1*HEIGHT
         CALL MOVTCA(XPOS,YPOS)
         CALL TEXT(TXTLINE(I))
 100  CONTINUE
      CALL INQTCU(XPOS,YPOS,KLR)
      CALL DELTCU 
C
C  DRAW A BAR ON 2ND LINE WITH NEW COLOR FOR LNRESP NBR OF CHARACTERS
C
      CALL INQTSI(TXTLINE(3),HEIGHT,WIDTH)
      CALL MOVTCR(-WIDTH,0)
      CALL INQTCU(XNOW,YNOW,KLR)
C-------WARNING!!! ABOVE STMT YIELDS BAD VALUE FOR YNOW. DON'T KNOW WHY...
      CALL SETCOL(2)
      CALL BAR(XNOW,YPOS,XNOW+WIDTH,YPOS+HEIGHT)
      CALL MOVTCA(XNOW,YPOS)
      XHIGH = XNOW + WIDTH + 0.02
      CALL SETTCL(1,2)
      LPOS = 1
      CALL INQTSI(TXTCHR,HEIGHT,WIDTH)
C
C  GET A KEYBOARD RESPONSE AND PROCESS IT
C
      RTNTEXT = '  '
      DECMPT  = .FALSE.
 200  CONTINUE
      CALL GETCHAR(FLDTYPE,INCHAR)
C
C     SINGLE CHARACTER. PUT IN STRING AND ECHO TO SCREEN IF SPACE IN WINDOW
C       
      IF (INCHAR(2:2) .EQ. ' ') THEN
         IF (FLDTYPE.EQ.3.OR.FLDTYPE.EQ.4) THEN
C
C----       CHECK FOR DIGITS 0-9, +, - CHARACTERS FOR A NUMERIC FIELD
C
            IF (INCHAR(1:1).LT.'0'.OR.INCHAR(1:1).GT.'9') THEN
               IF (INCHAR(1:1).EQ.'-'.OR.INCHAR(1:1).EQ.'+') THEN
                  IF (LPOS.GT.1.OR.LNRESP.LT.2) THEN
                     CALL BEEP
                     CALL INQTCU(XPOS,YPOS,KLR)
                     CALL GRAFNOTE(XNOTE,YNOTE,67,202,' ',0,DUMCHR)
                     CALL MOVTCA(XPOS,YPOS)
                     GO TO 200
                  ENDIF
               ELSE 
C
C----       NOT 0-9, +, - CHARACTER.  CHECK FOR ONE DECIMAL POINT IN A REAL
C----       NUMBER FIELD.  ALL OTHER CHARACTERS ARE IN ERROR
C
                  IF(FLDTYPE.EQ.3) THEN
                     CALL BEEP
                     CALL INQTCU(XPOS,YPOS,KLR)
                     CALL GRAFNOTE(XNOTE,YNOTE,69,202,' ',0,DUMCHR)
                     CALL MOVTCA(XPOS,YPOS)
                     GO TO 200
                  ELSE
                     IF (DECMPT .OR. INCHAR(1:1).NE.'.') THEN
                        CALL BEEP
                        CALL INQTCU(XPOS,YPOS,KLR)
                        CALL GRAFNOTE(XNOTE,YNOTE,69,202,' ',0,DUMCHR)
                        CALL MOVTCA(XPOS,YPOS)
                        GO TO 200
                     ELSE
                        DECMPT = .TRUE.
                     ENDIF
                  ENDIF   
               ENDIF
            ENDIF
         ENDIF 

         CALL INQTCU(XNOW,YNOW,KLR)
         IF ((XNOW + WIDTH) .LT. XHIGH) THEN
            RTNTEXT(LPOS:LPOS) = INCHAR(1:1)
            TXTCHR(2:2)        = INCHAR(1:1)
            CALL TEXT(TXTCHR)
            LPOS = LPOS + 1  
         ELSE
            CALL BEEP
         ENDIF
      ELSE 
C
C---  BACK-SPACE OVER PREVIOUS CHARACTER AND CLEAR POSITION ON SCREEN
C
         IF (INCHAR. EQ. 'BS' .OR. INCHAR .EQ .'LA') THEN
            LPOS = LPOS - 1
            IF (LPOS .GT. 0) THEN
               TXTCHR(2:2) = RTNTEXT(LPOS:LPOS)
               IF (TXTCHR(2:2) .EQ. '.') THEN
                  DECMPT = .FALSE.
               ENDIF
               CALL INQTSI(TXTCHR,HEIGHT,WIDTH)
               CALL INQTCU(XNOW,YNOW,KLR)
               CALL MOVTCA(XNOW-WIDTH,YNOW)
               RTNTEXT(LPOS:LPOS) = ' '
               TXTCHR(2:2)        = ' '
               CALL TEXT(TXTCHR)
               CALL INQTSI(TXTCHR,HEIGHT,WIDTH)
               CALL INQTCU(XNOW,YNOW,KLR)
               CALL MOVTCA(XNOW-WIDTH,YNOW)
            ELSE            
               LPOS = LPOS + 1
               CALL BEEP
            ENDIF
         ELSE
C
C        PROCESS RETURN, F4, ESCAPE KEYS. ALL OTHER CONTROL KEYS NOT VALID
C
            IF (INCHAR.EQ.'RE') THEN
               LPOS = LPOS-1
               GO TO 900   
            ELSE 
               IF (INCHAR.EQ.'4F'.OR.INCHAR.EQ.'ES') THEN
                  RTNTEXT = 'ES'
                  LPOS    = 0
                  GO TO 900
               ELSE   
                  CALL BEEP
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      GO TO 200  
C
C   RESTORE THE WINDOW AND EXIT.
C
  900 CONTINUE
      MAXCHR=MIN0(LEN(OUTTXT),LEN(RTNTEXT))
      OUTTXT=RTNTEXT(1:MAXCHR)
      LENOUT=MIN0(LPOS,MAXCHR)
      CALL GRAFWIN(0,XWIN1,YWIN1,XWIN2,YWIN2)
      CALL SETVIE(XN1,YN1,XN2,YN2,-1,-1)
      CALL SETWOR(X1OLD,Y1OLD,X2OLD,Y2OLD)
      CALL MOVHCA(XOLD,YOLD)
      CALL SETXOR(IXOR)
      RETURN
      END
