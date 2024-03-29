$STORAGE:2
      SUBROUTINE RDGRAF(GRAFNAME,ITYPE,NELEM,RTNCODE)
C
C       ** OBJECTIVE:  ROUTINE TO READ THE GRAPH DEFINITION FOR "GRAFNAME" 
C                      AND LOAD THE VALUES INTO THE GRAFVAR COMMON BLOCK
C
C       ** NOTE:  DO NOT CALL ANY ROUTINE THAT HAS GRAPHICS CALLS FROM THIS
C                 ROUTINE; GRAPHICS IS INITIALIZED AFTER THIS ROUTINE IS
C                 COMPLETED
C
C       ** INPUT:
C              GRAFNAME...NAME OF THE GRAPH WANTED (CHAR*8)
C          OUTPUT:
C              ITYPE......CLICOM INTEGER OBS-TYPE OF THE GRAPH
C              NELEM......THE NUMBER OF ELEMENTS DEFINED FOR THE GRAPH
C              RTNCODE....'0' IF DEFINITION READ OK, '2' DEFINITION NOT FOUND
C
      CHARACTER*20 GRAFFILE
      CHARACTER*8 GRAFNAME
      CHARACTER*1 RTNCODE
      INTEGER*2 ITYPE
C      
$INCLUDE: 'GRFPARM.INC'
$INCLUDE: 'GRAFVAR.INC'
C
      RTNCODE = '0'
C      
C       ** BUILD GDF FILE NAME AND OPEN IT
C
      GRAFFILE = 'O:\DATA\'//GRAFNAME
      DO 20 I1 = 20,1,-1
         IF (GRAFFILE(I1:I1).NE.' ') THEN
            GO TO 25
         END IF
   20 CONTINUE
   25 CONTINUE
      I1 = I1 + 1
      GRAFFILE(I1:I1+3) = '.GDF'         
      OPEN (11,FILE=GRAFFILE,STATUS='OLD',FORM='FORMATTED'
     +     ,MODE='READ',IOSTAT=ICHK)
      IF (ICHK.NE.0) THEN
         RTNCODE = '2'
         RETURN
      END IF
C
C       **  READ THE GDF FILE
C
C       ..  DETERMINE THE GRAPH AND OBS-TYPE
      READ(11,*) IGRAPH,IOBSTYP,NBRELEM,NROWDIM,NUMCOL,NUMPLT
     +          ,ITYPSET,NFRSET,OBSTYPE,GDFNAME
      NELEM = NBRELEM     
      ITYPE = IOBSTYP
C
      IF (IGRAPH.EQ.1) THEN
C
C          .. READ DEFINITION FOR A TIME-SERIES (X-Y) PLOT
         MXNVAL = MIN0(NUMCOL,MXELEM)        
         READ(11,*) (GRAFELEM(I1),I1=1,NBRELEM)
         READ(11,*) LOWROW,LOWCOL,HIROW,HICOL
     +             ,LEGEND,PLTWID,NGRFSCR
         READ(11,*) VPNDLF,VPNDRT,VPNDBT,VPNDTP
     +             ,GANWLF,GANWRT,GANWBT,GANWTP
         READ(11,*) ((LFTSCALE(I1,J1),I1=1,2),J1=1,MXNVAL)
         READ(11,*) (( RTSCALE(I1,J1),I1=1,2),J1=1,MXNVAL)
         READ(11,*)    BTSCALE(1),BTSCALE(2)
         READ(11,*) GRTITLE,GRSUBTITLE
         DO 40 I1=1,MXNVAL
            READ(11,*) LFTTXT(I1),RTTXT(I1)
   40    CONTINUE            
         READ(11,*)  BOTTXT
         READ(11,*)    FTXT
         READ(11,*) BKGNCLR
         READ(11,*)
     +            TLCLR,  TLFONT  ,TLSIZE,  TLASP,  TLLOC(1),  TLLOC(2) 
     +         , STLCLR, STLFONT, STLSIZE, STLASP, STLLOC(1), STLLOC(2)
     +         ,LTXTCLR,LTXTFONT,LTXTSIZE,LTXTASP,LTXTLOC(1),LTXTLOC(2)
     +         ,RTXTCLR,RTXTFONT,RTXTSIZE,RTXTASP,RTXTLOC(1),RTXTLOC(2)
     +         ,BTXTCLR,BTXTFONT,BTXTSIZE,BTXTASP,BTXTLOC(1),BTXTLOC(2)
     +         ,FTXTCLR,FTXTFONT,FTXTSIZE,FTXTASP,FTXTLOC(1),FTXTLOC(2)
     +         , LEGCLR, LEGFONT, LEGSIZE, LEGASP, LEGLOC(1), LEGLOC(2)
         READ(11,*) AXSCLR,AXSFONT,AXSTHK,ATXTSIZE,ATXTASP,TICSIZE
         READ(11,*) NCHRBT,(NDECLF(I1),I1=1,MXNVAL)
     +                    ,(NDECRT(I1),I1=1,MXNVAL)
         READ(11,*) XMAJBT,(YMAJLFT(I1),I1=1,MXNVAL)
         READ(11,*)         (YMAJRT(I1),I1=1,MXNVAL)
         READ(11,*) XMINBT,(YMINLFT(I1),I1=1,MXNVAL)
         READ(11,*)         (YMINRT(I1),I1=1,MXNVAL)
         READ(11,*) XGRDCLR,XGRDTHK,YGRDCLR,YGRDTHK
         READ(11,*) (XGRDTYP(I1),I1=1,MXNVAL),
     +              (YGRDTYP(I1),I1=1,MXNVAL)
         READ(11,*) PALETTE,((PALDEF(I1,J1),I1=1,16),J1=1,12)
         DO 50 I1 = 1,MXNVAL
            READ(11,*) COLTYPE(I1),COLAXIS(I1),COLTHK(I1)
     +                ,COL1CLR(I1),COL2CLR(I1)
   50    CONTINUE     
C
      ELSE IF (IGRAPH.EQ.2) THEN
C
C          .. READ DEFINITION FOR A MAP
         MXNVAL = MIN0(NUMCOL,MXELEM) - 2       
         READ(11,*) LOWLAT,HILAT,LOWLON,HILON
         READ(11,*) (GRAFELEM(I1),I1=1,NBRELEM)
         READ(11,*) LOWROW,LOWCOL,HIROW,HICOL
     +             ,LEGEND,PLTWID,NGRFSCR
         READ(11,*) VPNDLF,VPNDRT,VPNDBT,VPNDTP
     +             ,GANWLF,GANWRT,GANWBT,GANWTP
         READ(11,*) LFTSCALE(1,1),LFTSCALE(2,1)
         READ(11,*)  BTSCALE(1),   BTSCALE(2)
         READ(11,*) GRTITLE,GRSUBTITLE
         DO 140 I1=1,MXNVAL
            READ(11,*) LFTTXT(I1)
  140    CONTINUE            
         READ(11,*)  BOTTXT
         READ(11,*)  FTXT
         READ(11,*) BKGNCLR
         READ(11,*)
     +         TLCLR,  TLFONT  ,TLSIZE,  TLASP,  TLLOC(1),  TLLOC(2) 
     +      , STLCLR, STLFONT, STLSIZE, STLASP, STLLOC(1), STLLOC(2)
     +      ,LTXTCLR,LTXTFONT,LTXTSIZE,LTXTASP,LTXTLOC(1),LTXTLOC(2)
     +      ,BTXTCLR,BTXTFONT,BTXTSIZE,BTXTASP,BTXTLOC(1),BTXTLOC(2)
     +      ,FTXTCLR,FTXTFONT,FTXTSIZE,FTXTASP,FTXTLOC(1),FTXTLOC(2)
     +      , LEGCLR, LEGFONT, LEGSIZE, LEGASP, LEGLOC(1), LEGLOC(2)
         READ(11,*) AXSCLR,AXSFONT,AXSTHK,ATXTSIZE,ATXTASP,TICSIZE
         READ(11,*) NDECRT(3),YMAJRT(1),YMAJRT(2)
         READ(11,*) RTXTFONT,RTXTSIZE,RTXTASP
         READ(11,*) NDECRT(1)
         READ(11,*) XMAJBT,YMAJLFT(1)
         READ(11,*) XMINBT,YMINLFT(1)
         READ(11,*) XGRDCLR,XGRDTHK,(XGRDTYP(I1),I1=1,MXNVAL)
         READ(11,*) YGRDTHK,YGRDTYP(1)
         READ(11,*) PALETTE,((PALDEF(I1,J1),I1=1,16),J1=1,12)
         DO 150 I1=1,MXNVAL
            READ(11,*) COLTYPE(I1),COLTHK(I1),COL1CLR(I1)
  150    CONTINUE   
         DO 160 I1 = 1,MXNVAL
            READ(11,*) COLAXIS(I1),COL2CLR(I1)
  160    CONTINUE     
         READ(11,*) NDECRT(4),(MPCODE(I1),I1=1,5)
         READ(11,*) (CONINCR(I1),I1=1,MXNVAL)
         READ(11,*) NCONLEV,NDECRT(2)
         READ(11,*) (CONLEV(I1),I1=1,MXCONLEV)
C         
      ELSE IF (IGRAPH.EQ.3) THEN
C
C          .. READ DEFINITION FOR A SOUNDING
         READ(11,*) LOWROW,LOWCOL,HIROW,HICOL
     +             ,LEGEND,PLTWID,NGRFSCR
         READ(11,*) VPNDLF,VPNDRT,VPNDBT,VPNDTP
     +             ,GANWLF,GANWRT,GANWBT,GANWTP
         READ(11,*) LFTSCALE(1,1),LFTSCALE(2,1),LFTSCALE(2,2)
         READ(11,*)  BTSCALE(1),   BTSCALE(2)
         READ(11,*) GRTITLE,GRSUBTITLE
         READ(11,*) FTXT
         READ(11,*) BKGNCLR
         READ(11,*)
     +         TLCLR,  TLFONT  ,TLSIZE,  TLASP,  TLLOC(1),  TLLOC(2) 
     +      , STLCLR, STLFONT, STLSIZE, STLASP, STLLOC(1), STLLOC(2)
     +      ,FTXTCLR,FTXTFONT,FTXTSIZE,FTXTASP,FTXTLOC(1),FTXTLOC(2)
     +      , LEGCLR, LEGFONT, LEGSIZE, LEGASP, LEGLOC(1), LEGLOC(2)
         READ(11,*) PALETTE,((PALDEF(I1,J1),I1=1,16),J1=1,12)
         DO 240 I1 = 1,2
            READ(11,*) COLTYPE(I1),COLTHK(I1),COL1CLR(I1)
  240    CONTINUE     
C    
      ELSE IF (IGRAPH.EQ.4) THEN
C
C          .. READ DEFINITION FOR A WIND ROSE
         MXNVAL = MXWRCAT
         READ(11,*) (GRAFELEM(I1),I1=1,NBRELEM)
         READ(11,*) LOWROW,LOWCOL,HIROW,HICOL
     +             ,LEGEND,PLTWID,NGRFSCR
         READ(11,*) VPNDLF,VPNDRT,VPNDBT,VPNDTP
     +             ,GANWLF,GANWRT,GANWBT,GANWTP
         READ(11,*) LFTSCALE(1,1),LFTSCALE(2,1)
         READ(11,*)  BTSCALE(1),   BTSCALE(2)
         READ(11,*) GRTITLE,GRSUBTITLE
         READ(11,*) FTXT
         READ(11,*) BKGNCLR
         READ(11,*)
     +         TLCLR,  TLFONT  ,TLSIZE,  TLASP,  TLLOC(1),  TLLOC(2) 
     +      , STLCLR, STLFONT, STLSIZE, STLASP, STLLOC(1), STLLOC(2)
     +      ,FTXTCLR,FTXTFONT,FTXTSIZE,FTXTASP,FTXTLOC(1),FTXTLOC(2)
     +      , LEGCLR, LEGFONT, LEGSIZE, LEGASP, LEGLOC(1), LEGLOC(2)
         READ(11,*) NCHRBT,(NDECLF(I),I=1,5)
         READ(11,*) PALETTE,((PALDEF(I1,J1),I1=1,16),J1=1,12)
         DO 340 I1=1,MXNVAL
            READ(11,*) COL1CLR(I1),COLTYPE(I1)
  340    CONTINUE
      END IF
C
      CLOSE(11)
C
      RETURN
C
      END      
