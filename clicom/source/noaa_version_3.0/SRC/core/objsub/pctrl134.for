$STORAGE:2
      SUBROUTINE PCTRL(IOPT,RTNCODE)
C
C       ** OBJECTIVE:  DRAW THE GRAPH USING THE CURRENT VALUES IN THE
C                      DEFINITION FILE.  Routines stop drawing
C                      and return if user presses ESC.
C
C       ** NOTE:       THIS VERSION OF ROUTINE PCTRL IS CONTAINED IN FILE
C                      PCTRL134. IT IS USED IN GRFMN134.EXE TO PLOT 
C                      TIMESERIES, SKEWT, AND WINDROSE. 
C       ** INPUT:
C            IOPT......GRAPH OPTION FLAG THAT CONTROLS SELECTION OF DATA
C                      THAT WILL BE PLOTTED AND PLOT CONTROLS
C                      0=REDRAW CURRENT PLOT
C                      1=NEXT PLOT IN CURRENT DATA FRAME 
C                      2=NEW DATA FRAME
C                      3=REDRAW CURRENT PLOT -- NO PAUSE -- SKEWT ONLY
C                      4=REDRAW CURRENT SCREEN FOR PRINTING
C       ** OUTPUT:
C            RTNCODE...ONE CHARACTER ERROR FLAG
C                      '0'=NORMAL EXIT
C                      '1'=EXIT USING ESC OR F4
C                      '2'=NO MORE PLOTS IN FRAME
C                      '3'=RESERVED FOR PCTRL2 (MAP)
C                      '4'=PCTRL134 CALLED WHEN PLOT WAS MAP
C                      '5'=NO DATA AVAILABLE FOR CURRENT PLOT
C                      '6'=FILE WROSPOKE.DEF NOT AVAILABLE TO WINDROSE 
C                      '7'=PRESSURE AND/OR HEIGHT VALUES ARE OUT OF SORT
C                          SKEWT COULD NOT DRAW HEIGHT LABELS
C
      INTEGER*2 IOPT
      CHARACTER*1 RTNCODE
C
$INCLUDE: 'GRFPARM.INC'
$INCLUDE: 'GRAFVAR.INC'
$INCLUDE: 'DATAVAL.INC'
$INCLUDE:  'FRMPOS.INC'
$INCLUDE:  'CURRPLT.INC'
C
      LOGICAL MOVFLG,REPLTSKT
      CHARACTER*1 DUMFLG
C
C      
      IF (IGRAPH.EQ.3) THEN
C
C          .. PLOT SKEWT      
         MOVFLG = .TRUE.
         IF (IOPT.EQ.1 .OR. IOPT.EQ.2) ZOOMED=.FALSE.
   20    CALL INITPV(VPNDLF,VPNDRT,VPNDBT,VPNDTP,PALETTE,BKGNCLR)
         IF (IOPT.EQ.4) THEN
            RTNCODE='P'
         ELSE
            RTNCODE='G'
         ENDIF   
         CALL SKTDIM2(RVAL,MXDATROW,NPLTROW,DUMFLG,RTNCODE)
         IF (IOPT.EQ.3 .OR. IOPT.EQ.4) THEN
            REPLTSKT=.FALSE.
         ELSE   
            CALL SETZOOM(MOVFLG,ZOOMED,REPLTSKT)
         ENDIF   
         IF (REPLTSKT) GO TO 20
      ELSE   
         CALL INITPV(VPNDLF,VPNDRT,VPNDBT,VPNDTP,PALETTE,BKGNCLR)
         IF (IGRAPH.EQ.1) THEN
C
C             .. PLOT TIMESERIES  
C            IF (ITYPSET.EQ.0) THEN
C               IDX=LOWROW
C            ELSE   
C               IDX=LORFRM
C            ENDIF 
C **DEBUG PREV LINES COMMENTED; 1 LINE ADDED
            IDX=LORFRM
            CALL TIMESER(IOPT,CVAL(IDX),RVAL(IDX),MXDATROW,NPLTROW,
     +                   I1VAL,RTNCODE)
         ELSE IF (IGRAPH.EQ.4) THEN
C
C             .. PLOT WINDROSE -- DOES NOT CONSIDER PLOT OPTIONS; SAME PLOT
C                                 PROCEDURE FOR ALL OPTIONS
            CALL WINDROSE(RVAL,MXDATROW,RTNCODE)
         ELSE 
C
C             .. ERROR: MAP WAS REQUESTED
            RTNCODE = '4'
         END IF
      END IF
C
      RETURN
      END      
