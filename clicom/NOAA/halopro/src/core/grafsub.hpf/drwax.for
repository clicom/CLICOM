$STORAGE:2
      SUBROUTINE GETTIC(TICMAJ,NTIC,TICLOC,AXLOC,DTIC,TICORG,AXORG,
     +                  TICST,TICFIN)
C
C       ** OBJECTIVE:  GET X AND Y COORDINATES OF FIRST MAJOR TIC MARK 
C                      ALONG AXIS.  SAVE DISTANCE BETWEEN MAJOR TIC MARKS.
C
C       ** INPUT:
C             TICMAJ....ABSOLUTE VALUE IS DISTANCE BETWEEN MAJOR TIC
C                             MARKS.  0=NO TIC MARKS
C             TICORG....STARTING VALUE ALONG AXIS FROM WHICH ALL TIC 
C                       LOCATIONS ARE MEASURED (REFERENCE TIC POSITION)
C             AXORG.....LOCATION OF THE ENTIRE TIC AXIS IN TERMS OF THE
C                       OPPOSITE AXIS
C             TICST.....VALUE AT THE START OF THE AXIS
C             TICFIN....VALUE AT THE END OF THE AXIS
C       ** OUTPUT:
C             NTIC......NUMBER OF TIC MARKS ALONG AXIS
C             TICLOC....COORDINATE OF START OF FIRST TIC MARK ALONG THE AXIS
C             AXLOC.....COORDINATE OF START OF FIRST TIC MARK IN TERMS OF THE
C                       OPPOSITE AXIS
C             DTIC......DISTANCE BETWEEN MAJOR TIC MARKS
C
C       ** NOTE:  ALL VALUES ARE IN WORLD COORDINATES.  TIC MARKS ARE PLACED
C                 ALONG THE AXIS AT INTERVALS OF +/-  TICMAJ STARTING AT
C                 THE REFERENCE TIC POSITION.
C 
C
C       ** NO TIC MARKS IF TICMAJ=0             
C
      NTIC = 0
      TICLOC = 0
      AXLOC = 0
      DTIC = 0
      IF (TICMAJ.EQ.0) GO TO 100
C
      TICLOC = TICORG
      DTIC = ABS(TICMAJ)
      AXLOC = AXORG
C
C       ** CALCULATE NUMBER OF TICS BETWEEN ORIGIN AND AXIS END
C
      IF (TICFIN.GT.TICORG) THEN
         NTIC = NTIC + INT2((TICFIN-TICORG)/DTIC)
      ENDIF
C
C       ** CALCULATE NUMBER OF TICS BETWEEN AXIS START AND ORIGIN;
C          CALCULATE POSITION OF FIRST TIC                          
C
      IF (TICST.LT.TICORG) THEN
         NTIC = NTIC + INT2((TICORG-TICST)/DTIC)
         TICLOC = TICORG - FLOAT(NTIC)*DTIC
      ENDIF
      NTIC = NTIC + 1
  100 RETURN
      END         
      SUBROUTINE DRWXAX(ITICMX,TICLBX,NCHRX,XMAJOR,MINOR,XORGFLG,LABEL
     +                 ,TICSZNW,TLBSZNW,AXSFONT,ATXTASP,AXSCLR,AXSTHK)
C
C       ** OBJECTIVE:  DRAW X-AXIS, TIC MARKS, AND TIC MARK LABELS
C
C       ** INPUT:
C             ITICMX....ARRAY INDEX OF LAST TIC LABEL -- ARRAY BEGINS AT ZERO
C             TICLBX....TIC MARK LABELS -- THERE IS ALWAYS A POSITION FOR THE
C                       ORIGIN LABEL EVEN IF IT IS NOT USED
C             NCHRX.....NUMBER OF CHARACTERS IN TIC LABEL THAT WILL BE USED
C             XMAJOR....ABSOLUTE VALUE IS DISTANCE BETWEEN MAJOR TIC MARKS
C                       POSITIVE/NEGATIVE=TIC MARKS DRAWN ABOVE/BELOW AXIS
C                       ZERO=NO TIC MARKS 
C             MINOR..... 0=NO MINOR TIC MARKS
C                       +1=MINOR TIC MARKS INSERTED HALFWAY BETWEEN MAJOR
C                          TIC MARKS.  MINOR TICS ARE NOT LABELED
C             XORGFLG... 0=REFERENCE TIC POSITION AT XMIN
C                       +1=REFERENCE TIC POSITION AT ORIGIN
C             LABEL..... 0=NO TIC LABELS
C                       +1=TICS EXCLUDING ORIGIN ARE LABELED 
C                       -1=TICS INCLUDING ORIGIN ARE LABELED
C             TICSZNW...TIC LENGTH IN NORMALIZED WORLD COORDINATES
C             TLBSZNW...TIC LABEL SIZE IN NORMALIZED WORLD COORDINATES
C             AXSFONT...FONT ID USED FOR TIC LABELS
C             ATXTASP...ASPECT RATIO OF TIC LABEL CHARACTERS
C             AXSCLR....COLOR OF AXIS LINES, TIC LABELS, AND TIC MARKS
C
C       ** NOTE:  ALL POSITIONS ARE IN WORLD COORDINATES.  TIC MARKS ARE 
C                 PLACED ALONG THE AXIS AT INTERVALS OF XMAJOR STARTING AT
C                 THE REFERENCE TIC POSITION.
C 
C
$INCLUDE:  'PLTSPEC.INC'
C
      INTEGER XORGFLG,AXSFONT,AXSCLR,AXSTHK
      CHARACTER *(*) TICLBX(0:*) 
C
      PARAMETER (MXCHR=10)      
      CHARACTER OUTLB*(MXCHR+2) 
C
C       ** DEFINE LINE ATTRIBUTES
C
      LNTYP = 1
      CALL DEFHLN(AXSCLR,LNTYP,AXSTHK)      
      CALL XSZNW2W(TICSZNW,XTICSZW,YTICSZW)
C
C       ** GET TIC MARK LOCATIONS
C
      IF (XORGFLG.EQ.1) THEN
         TICREF=XORG
      ELSE
         TICREF=XMIN
      ENDIF            
      CALL GETTIC(XMAJOR,NXTIC,XTXLOC,XTYLOC,DXTIC,TICREF,YORG,
     +            XMIN,XMAX)
      XLO  = XTXLOC
      YLOC = XTYLOC
      XHI = XLO + FLOAT(NXTIC-1)*DXTIC
C
C       ** DRAW X-AXIS      
C
      CALL MOVABS(XLO,YLOC)
      CALL LNABS(XHI,YLOC)      
C
C       ** CHECK IF TIC MARKS ARE REQUESTED
C
      IF (XMAJOR.EQ.0 .OR. NXTIC.EQ.0) GO TO 100
C
C       ** CALCULATE NUMBER OF TIC MARKS.  IF FLAG IS ON INCLUDE
C          MINOR TICS
C
      NTIC = NXTIC
      XDIST = ABS(XMAJOR)
      IF (MINOR.EQ.1) THEN
         NTIC = NTIC*2 - 1
         XDIST = .5*XDIST
      ENDIF
C
C       ** DRAW TIC MARKS ALONG X-AXIS
C
      DX = 0.
      DY = SIGN(YTICSZW,XMAJOR)
      Y = YLOC
      X = XLO - XDIST
      DO 20 N=1,NTIC
         X = X + XDIST
         CALL MOVABS(X,Y)
         CALL LNREL(DX,DY)
   20 CONTINUE
C
C       ** CHECK IF TIC LABELS ARE REQUESTED
C
      IF (LABEL.EQ.0 .OR. NCHRX.LE.0) GO TO 100
      ANG = 0.
      CALL DEFHST(AXSFONT,AXSCLR,ANG,ATXTASP,TLBSZNW,TLBSZW)
C
C       ** CALCULATE Y-POSITION OF LOWER LEFT CORNER OF LABEL 
C
      IF (XMAJOR.LT.0.) THEN
C
C          .. LABELS ABOVE AXIS      
         Y = YLOC + .5*TLBSZW
      ELSE
C
C          .. LABELS BELOW AXIS      
C         Y = YLOC - 2.*TLBSZW
         Y = YLOC - 1.5*TLBSZW
      ENDIF
C
C       ** SET CONTROLS FOR ORIGIN LABEL
C
      NA = 1
      NDIST = INT(DXTIC)
      IF (LABEL.EQ.1) THEN
C
C          .. NO ORIGIN LABEL      
         XLOC = XLO 
         NB = NXTIC - 1
         NLB = 0
      ELSE
C
C          .. LABEL ORIGIN      
         NB = NXTIC
         XLOC = XLO - DXTIC
         NLB =  -NDIST
      ENDIF            
C
C       ** LABEL MAJOR TIC MARKS ALONG X-AXIS -- STOP DRAWING LABELS IF
C          THE MAXIMUM NUMBER OF LABELS AVAILABLE IS EXCEEDED
C
      NCHR = MIN0(NCHRX,MXCHR)
C      IF (NCHR.EQ.0) NCHR=MXCHR
      DO 40 N=NA,NB
         XLOC = XLOC + DXTIC
         NLB = NLB + NDIST
         IF (NLB.GT.ITICMX) GO TO 42
         CALL DELIMSTR(TICLBX(NLB)(1:NCHR),OUTLB)
         CALL INQSTS(OUTLB,HEIGHT,WIDTH,OFFSET)
         CALL MOVTCA(XLOC-.5*WIDTH,Y)
         CALL STEXT(OUTLB)
   40 CONTINUE
   42 CONTINUE
C
  100 RETURN
      END             
      SUBROUTINE DRWYAX(YMAJOR,MINOR,YORGFLG,LABEL,NDEC
     +                 ,TICSZNW,TLBSZNW,AXSFONT,ATXTASP,AXSCLR,AXSTHK)
C
C       ** OBJECTIVE:  DRAW Y-AXIS, TIC MARKS, AND TIC MARK LABELS
C
C       ** INPUT:
C             YMAJOR....ABSOLUTE VALUE IS DISTANCE BETWEEN MAJOR TIC MARKS
C                       POSITIVE/NEGATIVE=TIC MARKS DRAWN RIGHT/LEFT OF AXIS
C                       ZERO=NO TIC MARKS 
C             MINOR..... 0=NO MINOR TIC MARKS
C                       +1=MINOR TIC MARKS INSERTED HALFWAY BETWEEN MAJOR
C                          TIC MARKS.  MINOR TICS ARE NOT LABELED
C             YORGFLG... 0=REFERENCE TIC POSITION AT YMIN
C                       +1=REFERENCE TIC POSITION AT ORIGIN
C             LABEL..... 0=NO TIC LABELS
C                       +1=TICS EXCLUDING ORIGIN ARE LABELED 
C                       -1=TICS INCLUDING ORIGIN ARE LABELED
C             NDEC......NUMBER OF DECIMAL PLACES IN TIC LABEL
C             TICSZNW...TIC LENGTH IN NORMALIZED WORLD COORDINATES
C             TLBSZNW...TIC LABEL SIZE IN NORMALIZED WORLD COORDINATES
C             AXSFONT...FONT ID USED FOR AXIS LABELS
C             ATXTASP...ASPECT RATIO OF TIC LABEL CHARACTERS
C             AXSCLR....COLOR OF AXIS LINES, TIC LABELS, AND TIC MARKS
C
C       ** NOTE:  ALL POSITIONS ARE IN WORLD COORDINATES.  TIC MARKS ARE 
C                 PLACED ALONG THE AXIS AT INTERVALS OF YMAJOR STARTING AT
C                 THE REFERENCE TIC POSITION.
C 
C
$INCLUDE:  'PLTSPEC.INC'
C
      INTEGER YORGFLG,AXSFONT,AXSCLR,AXSTHK
      CHARACTER TICLB*15, CHRTMP*10, FMT*20 
      DATA MAXYFMT /10/
C
C       ** DEFINE LINE ATTRIBUTES
C
      LNTYP = 1
      CALL DEFHLN(AXSCLR,LNTYP,AXSTHK)      
      CALL XSZNW2W(TICSZNW,XTICSZW,YTICSZW)
C
C       ** GET TIC MARK LOCATIONS
C
      IF (YORGFLG.EQ.1) THEN
         TICREF=YORG
      ELSE
         TICREF=YMIN
      ENDIF            
      CALL GETTIC(YMAJOR,NYTIC,YTYLOC,YTXLOC,DYTIC,TICREF,XORG,
     +            YMIN,YMAX)
      YLO  = YTYLOC
      XLOC = YTXLOC
      YHI = YLO + FLOAT(NYTIC-1)*DYTIC
C
C       ** DRAW Y-AXIS      
C
      CALL MOVABS(XLOC,YLO)
      CALL LNABS(XLOC,YHI)      
C
C       ** CHECK IF TIC MARKS ARE REQUESTED
C
      IF (YMAJOR.EQ.0 .OR. NYTIC.EQ.0) GO TO 100
C
C       ** CALCULATE NUMBER OF TIC MARKS.  IF FLAG IS ON INCLUDE
C          MINOR TICS
C
      NTIC = NYTIC
      YDIST =ABS(YMAJOR)
      IF (MINOR.EQ.1) THEN
         NTIC = NTIC*2 - 1
         YDIST = .5*YDIST
      ENDIF
C
C       ** DRAW TIC MARKS ALONG Y-AXIS
C
      DX = SIGN(XTICSZW,YMAJOR)
      DY = 0.
      X = XLOC
      Y = YLO - YDIST
      DO 20 N=1,NTIC
         Y = Y + YDIST
         CALL MOVABS(X,Y)
         CALL LNREL(DX,DY)
   20 CONTINUE
C
C       ** CHECK IF TIC LABELS ARE REQUESTED
C
      IF (LABEL.EQ.0) GO TO 100           
      ANG = 0.
      CALL DEFHST(AXSFONT,AXSCLR,ANG,ATXTASP,TLBSZNW,TLBSZW)
C
C       ** GET MAXIMUM NUMBER OF CHARACTERS IN TIC LABEL AND
C          INDICES OF PRINTED CHARACTERS
C
      NTIC = NYTIC
      WRITE(FMT,510) NDEC
      YMAXC = AMAX1(ABS(YHI),ABS(YLO))
      YMAXC = SIGN(YMAXC,YLO)
      WRITE(CHRTMP,FMT) YMAXC
C
      IF (NDEC.GT.0) THEN
C
C          .. FLOATING POINT FORMAT      
         IBN = MAXYFMT
      ELSE
C
C          .. INTEGER FORMAT      
         IBN = MAXYFMT-1
      ENDIF
      DO 25 I=1,IBN
         IAN = I
         IF (CHRTMP(I:I).NE.' ') GO TO 27
   25 CONTINUE            
   27 CONTINUE
C
C       ** SET VARIABLES FOR LABEL POSITION RELATIVE TO AXIS
C      
      IF (YMAJOR.GE.0.) THEN
C
C          .. LABELS TO THE LEFT OF AXIS -- BLANK IS ADDED AT THE END OF
C             THE MAXIMUM VALUE TO SPACE FROM AXIS.  ACTUAL TIC LABELS
C             WILL BE PLACED IN VARIABLE TICLB STARTING AT POSITION 2 (IAL)
         WRITE(TICLB,530) CHRTMP(IAN:IBN)
         IAL = 2
         FAC = 1.
      ELSE
C
C          .. LABELS TO THE RIGHT OF AXIS -- BLANK IS ADDED BEFORE THE START OF
C             THE MAXIMUM VALUE TO SPACE FROM AXIS.  ACTUAL TIC LABELS
C             WILL BE PLACED IN VARIABLE TICLB STARTING AT POSITION 3 (IAL)
         WRITE(TICLB,535) CHRTMP(IAN:IBN)
         IAL = 3
         FAC = 0.
      ENDIF
      IBL = IAL + IBN-IAN      
C
C       ** GET OFFSET THAT CENTERS LABEL HEIGHT WITH TIC MARK POSITION
C          GET X-POSITION OF LEFT SIDE OF TIC LABEL
C
      CALL INQSTS(TICLB,HEIGHT,TICLBW,OFFSET)
      YOFF = .5*HEIGHT
      X = XLOC - FAC*TICLBW
C
C       ** SET CONTROLS FOR ORIGIN LABEL
C
      NTIC = NYTIC
      NA = 1
      KLOOP=1
      IF (LABEL.EQ.1) THEN
C
C          .. NO ORIGIN LABEL      
         YLOC = YLO - DYTIC
         DO 30 I=1,NTIC
            NB=I
            YLOC = YLOC + DYTIC
            IF (YLOC.EQ.YORG) GO TO 32
   30    CONTINUE
   32    CONTINUE        
         NB=NB-1
         IF (NB.LT.NA) THEN
            NA=NB+2
            NB=NTIC
         ELSE IF (NB+2.LT.NTIC) THEN
            KLOOP=2
         ENDIF      
      ELSE
C
C          .. LABEL ORIGIN      
         NB=NTIC
      ENDIF            
C
C       ** LABEL MAJOR TIC MARKS ALONG Y-AXIS
C
      DO 45 K=1,KLOOP
         IF (K.EQ.2) THEN
            NA=NB+2
            NB=NTIC
         ENDIF
         DO 40 N=NA,NB
            YLOC = YLO + FLOAT(N-1)*DYTIC
            WRITE(CHRTMP,FMT) YLOC
            TICLB(IAL:IBL) = CHRTMP(IAN:IBN)
            CALL MOVTCA(X,YLOC-YOFF)
            CALL STEXT(TICLB)
   40    CONTINUE
   45 CONTINUE
C
  100 RETURN
C
C       ** FORMAT STMTS
C
  510 FORMAT('(F10.',I3,')')      
  530 FORMAT('&',A,' &')
  535 FORMAT('& ',A,'&')
C  
      END             
