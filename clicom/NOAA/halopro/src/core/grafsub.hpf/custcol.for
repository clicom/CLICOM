$STORAGE:2
      SUBROUTINE CUSTCOL(XNPOS,YNPOS,PALETTE,PALDEF)
C------------------------------------------------------------------------------
C     ROUTINE TO ALLOW THE USER TO ADJUST THE RED/GREEN/BLUE (RGB) COLOR
C     VALUES FOR ANY COLOR.  THE USER PICKS THE COLOR TO BE ADJUSTED
C     WITH PICKCOL AND THEN ADJUSTS IT BY INCREASING OR DECREASING THE
C     HEIGHT OF COLOR BARS REPRESENTING THE VALUES OF THE CONTRIBUTION OF
C     RGB TO THAT COLOR INDEX.
C
C     INPUT ARGUMENTS:
C
C     XNPOS,YNPOS  REAL       LOWER LEFT CORNER (NORMALIZED DEVICE COORDS) OF 
C                             COLOR BAR MENU 
C     PALETTE      INT2       CURRENT PALETTE NUMBER
C     PALDEF       INT2 ARRAY CURRENT DEFINITION OF ALL 12 POSSIBLE PALETTES
C
C     OUTPUT ARGUMENTS:
C
C     PALETTE      INT2       CUSTOM PALETTE NUMBER (12)
C     PALDEF       INT2 ARRAY REVISED DEFINITION OF ALL 12 POSSIBLE PALETTES
C------------------------------------------------------------------------------
      REAL      CURSSTEP,MOUSSTEP
      INTEGER*2 ICOLOR(3),OLDCLR(3),PREVGUN,PREVCLR,PALETTE
     +         ,PALDEF(16,12)
      CHARACTER*2 INCHAR
      CHARACTER*1 RTNCODE
      LOGICAL CHANGE
C
C   ALLOW THE USER TO PICK THE COLOR THEY WANT TO ADJUST
C
      INDEX = 4
50    CALL PICKCOL(INDEX,XNPOS,YNPOS,1,16,PALETTE,PALDEF,3)
      IF (INDEX .LT. 0) THEN
         GO TO 180
      ENDIF         
      IF (INDEX .LT. 4) THEN
         CALL GRAFNOTE(0.1,0.8,536,202,' ',0,INCHAR)
         GO TO 170
      ENDIF
C
C   DETERMINE WHERE TO OPEN THE NEXT WINDOW TO KEEP BOTH ON SCREEN.
C   REMEMBER THE PICKCOL WINDOW IS 10% OF X AND 40% OF Y.
C
      IF (XNPOS.LT.0.7) THEN
         XWIN1 = XNPOS + .15
      ELSE
         XWIN1 = XNPOS - .25
      END IF 
C
C   SET UP WINDOW FOR DISPLAY OF COLOR BARS.  POP IT UP AT THE 
C   NORMALIZED DEVICE COORDS WANTED AND HAVE IT TAKE AN AREA OF
C   20% OF X AND 20% OF Y. 
C    
      XWIN2 = XWIN1 + .2
      YWIN1 = YNPOS - .2
      CALL GRAFWIN(1,XWIN1,YWIN1,XWIN2,YNPOS)
C
C   FIND CURRENT WORLD COORDS AND SET VERTICAL SENSITIVITY VALUES FOR CURSOR 
C   AND MOUSE.  THEY DETERMINE IF THE MOVEMENT OF THE CURSOR OR MOUSE IS 
C   SUFFICIENT TO TRIGGER A CHANGE. SINCE CURSOR MOVEMENT IS FIXED AT 1/200TH 
C   OF THE WORLD BY RDLOC, THE CURSTEP VALUE IS SET TO A VALUE WHICH ALWAYS
C   TRIGGERS MOVEMENT EVERY TIME A CURSOR KEY IS PRESSED.
C
      CALL INQWOR(XLOW,YLOW,XHIGH,YHIGH)
      CURSSTEP = (YHIGH - YLOW) / 1000.
      MOUSSTEP = (YHIGH - YLOW) / 30.
      XSTEP = (XHIGH - XLOW) / 1000.
C
C   SET MOUSE AND CURSOR LOCATIONS TO CENTER OF WORLD AND ASK HALO FOR
C   RGB VALUES OF THE CURRENT COLOR INDEX.
C
      XPREV = XHIGH / 2.
      YPREV = YHIGH / 2.
      IGUN = 3
C       .. GET RED, GREEN, BLUE COMPONENTS NORMALIZED TO 255      
      CALL INQRGB(INDEX,ICOLOR(1),ICOLOR(2),ICOLOR(3))
C **DEBUG            
C            WRITE(*,*)'AFT INQRGB IDX,IC=',INDEX,(ICOLOR(I),I=1,3)
C       .. CONVERT RED, GREEN, BLUE (NORMALIZED TO 255) TO 0-3 RANGE
      DO 20 I = 1,3
         ICOLOR(I) = ICOLOR(I) / 85.0
         OLDCLR(I) = ICOLOR(I)
20    CONTINUE
      PREVGUN = IGUN
      PREVCLR = ICOLOR(IGUN)
C
C   DISPLAY COLOR ADJUSTMENT PICTURE WITH CURRENT VALUES
C
      CALL ADJRGB(IGUN,ICOLOR)
C
C   SET LOCATOR POSITION AND READ IT BACK TO ACCOUNT FOR ROUND OFF
C
      CALL ORGLOC(XPREV,YPREV)
      CALL RDLOC(XPREV,YPREV,INCHAR,RTNCODE)
      XPOS = XPREV
      YPOS = YPREV
      CHANGE = .FALSE.
C
C   READ MOUSE/CURSOR POSITION AND TAKE ACTION REQUIRED
C
120   CONTINUE
         CALL RDLOC(XPOS,YPOS,INCHAR,RTNCODE)
         CALL DELHCU( )
         IF (INCHAR.EQ.'RE') THEN
            RTNCODE = '0'
            GO TO 150
         ELSE IF(INCHAR.EQ.'4F'.OR.INCHAR.EQ.'ES') THEN
            RTNCODE = '1'
            GO TO 150
         END IF         
         IF (RTNCODE.EQ.'1') THEN
            YFACTOR = MOUSSTEP
            XFACTOR = XSTEP * 100.0
         ELSE
            IF (INCHAR.EQ.'YY') THEN
               XPOS = XPREV
               YPOS = YPREV
               CALL ORGLOC(XPREV,YPREV)
               GO TO 120
            ENDIF
            YFACTOR = CURSSTEP
            XFACTOR = XSTEP
         END IF
C
C     SELECT COLOR GUN (RGB) TO WORK ON
C
         IF (XPOS.GT.XPREV+XFACTOR) THEN
            CHANGE = .TRUE.
            IGUN = IGUN + 1
         ELSE IF (XPOS.LT.XPREV-XFACTOR) THEN
            CHANGE = .TRUE.
            IGUN = IGUN - 1
         END IF
         IF (IGUN.GT.3) THEN
            IGUN = 3
         ELSE IF (IGUN.LT.1) THEN
            IGUN = 1
         END IF
C
C     ADJUST INTENSITY OF CURRENT COLOR
C
         IF (YPOS.GT.YPREV+YFACTOR) THEN
            CHANGE = .TRUE.
            ICOLOR(IGUN) = ICOLOR(IGUN) + 1
         ELSE IF (YPOS.LT.YPREV-YFACTOR) THEN
            CHANGE = .TRUE.
            ICOLOR(IGUN) = ICOLOR(IGUN) - 1
         END IF
         IF (ICOLOR(IGUN).GT.3) THEN
            ICOLOR(IGUN) = 3
         ELSE IF (ICOLOR(IGUN).LT.0) THEN
            ICOLOR(IGUN) = 0
         END IF
C
C      MODIFY COLOR ADJUSTMENT PICTURE IF VALUES HAVE CHANGED
C
         IF (IGUN.NE.PREVGUN.OR.ICOLOR(IGUN).NE.PREVCLR) THEN
            CALL ADJRGB(IGUN,ICOLOR)
            PREVGUN = IGUN
            PREVCLR = ICOLOR(IGUN)
C **DEBUG            
C            WRITE(*,*)'BEF DEFCLR IDX,IC=',INDEX,(ICOLOR(I),I=1,3)
            CALL DEFCLR(INDEX,ICOLOR,'SCR')
         END IF
         IF (CHANGE) THEN
            CHANGE = .FALSE.
            XPOS = XPREV
            YPOS = YPREV
            CALL ORGLOC(XPREV,YPREV)
         END IF
         GO TO 120
C
C   RESTORE THE WINDOW 
C
150   CONTINUE
      CALL GRAFWIN(0,XWIN1,YWIN1,XWIN2,YNPOS)
C
C   IF NEW COLOR SELECTED, SET CUSTOM PALETTE TO THE MODIFIED CURRENT
C   PALETTE AND SET PALETTE NUMBER TO 12 (CUSTOM)
C
      IF (RTNCODE.EQ.'1') THEN
         ICOLOR(1) = OLDCLR(1)  
         ICOLOR(2) = OLDCLR(2)  
         ICOLOR(3) = OLDCLR(3)  
      ELSE IF (PALETTE.NE.12) THEN
         DO 160 I1 = 1,16
            PALDEF(I1,12) = PALDEF(I1,PALETTE)
160      CONTINUE
         PALETTE = 12
      END IF
C
C   TRANSLATE RGB VALUES TO EGA/VGA INTEGER COLOR VALUE AND SET COLOR
C   WITH HALO.
C
      CALL RGB2INT(ICOLOR,JCOLOR)
      PALDEF(INDEX+1,PALETTE) = JCOLOR
      CALL DEFPAL(PALDEF(1,PALETTE))
170   CALL PICKCOL(INDEX,XNPOS,YNPOS,2,16,PALETTE,PALDEF,2)
      GO TO 50
C
C   CLOSE THE COLOR SELECTION WINDOW
C
180   CONTINUE
      CALL PICKCOL(INDEX,XNPOS,YNPOS,2,16,PALETTE,PALDEF,2)
      RETURN
      END
***********************************************************************

      SUBROUTINE ADJRGB(IGUN,ICOLOR)
C------------------------------------------------------------------------------
C     ROUTINE TO DISPLAY THE COLOR ADJUSTMENT PICTURE WHICH SHOWS
C     THE CURRENT RGB VALUES AS A BAR CHART.
C
C     INPUT AND OUTPUT ARGUMENTS:
C
C     IGUN     INT2  RED/GREEN/BLUE (1-3) COMPONENT WHOSE INTENSITY IS CHANGING
C     ICOLOR   INT2  INTENSITY VALUE FOR IGUN
C------------------------------------------------------------------------------
      REAL WIDTH,HEIGHT,BARSTEP,YBASE,BWIDTH
      INTEGER*2 ICOLOR(3)
      CHARACTER*3 RGB(3)
      DATA RGB /'^R^','^G^','^B^'/
C
C   DETERMINE WIDTH OF DOT TEXT CHARACTERS, CONVERT TO WORLD COORD
C
      CALL INQWOR(XLOW,YLOW,XHIGH,YHIGH)
      CALL INQTSI(RGB(1),INHEIGHT,WIDTH)
C
C   CLEAR WINDOW
C
      CALL SETHAT(1)
      CALL SETCOL(3)
      CALL BAR(XLOW,YLOW,XHIGH,YHIGH)
C
C   SET BAR COORDINATE LIMITS AND WRITE BARS AND RGB LEGEND TEXT
C
      HEIGHT = (YHIGH - YLOW)*.95
      BARSTEP = HEIGHT * .20
      YBASE = YLOW + BARSTEP + (HEIGHT / 6.)
      XWIDTH = XHIGH - XLOW
      BWIDTH = XWIDTH / 12.0
      CALL SETTEX(1,1,0,0)
      CALL SETCOL(0)
      CALL SETTCL(0,3)
      DO 50 J = 1,3
         XSTART = XLOW + FLOAT(J-1) * XWIDTH / 3.0
         XPOS = XSTART + XWIDTH/6.0 - (BWIDTH/2.0) 
         YTOP = YBASE + BARSTEP*FLOAT(ICOLOR(J))
         XCHAR = XSTART + XWIDTH/6.0 - (WIDTH/2.0)
         CALL BAR(XPOS,YBASE,XPOS+BWIDTH,YTOP)
         YPOS = YBASE - INHEIGHT*1.5
         CALL MOVTCA(XCHAR,YLOW+(HEIGHT/6.0))
         CALL DELTCU
         CALL BTEXT(RGB(J))
50    CONTINUE
      XSTART = XLOW + FLOAT(IGUN-1) * XWIDTH / 3.0
      CALL BOX(XSTART+BWIDTH,YLOW,XSTART-BWIDTH+XWIDTH/3.0
     +        ,YLOW+HEIGHT)
      CALL SETTCL(IFG,IBG)
      RETURN
      END
