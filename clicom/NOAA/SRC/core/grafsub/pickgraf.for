$STORAGE:2
 
      SUBROUTINE PICKGRAF(IGRAPH,NWRDIR,ITYPE,GRAFNAME,NELEM,RTNCODE)
C
C   ROUTINE TO ASK THE USER WHAT GRAPH CATEGORY THEY WOULD LIKE AND SET
C   OR REQUEST THE OBS-TYPE AS APPROPRIATE.  IT ALSO READS IN THE 
C   DEFINITION OF AN EXISTING GRAPH IF ONE HAS BEEN REQUESTED. 
C
C   ---> THIS ROUTINE IS ASSOCIATED WITH GRAFINIT <---
C
C   OUTPUT:
C     IGRAPH....CLICOM GRAPHICS TYPE (1-TIME, 2-AREA, 3-SKEW-T,
C                                     4-WIND ROSE)
C     NWRDIR....NUMBER OF WIND ROSE DIRECTIONS 
C     ITYPE.....CLICOM INTEGER OBS-TYPE (1-7)
C     GRAFNAME...NAME OF THE GRAPH SELECTED (CHAR*8)
C     NELEM......NUMBER OF ELEMENTS IN THE GRAPH SELECTED
C     RTNCODE....'0' SELECTION MADE OK, 
C                '1' IF NO SELECTION IS MADE
C                '2' IF DESCRIPTION FILE IS IN ERROR AND THE DESCRIPTION
C                    OF THIS GRAPH MUST BE REMOVED.
C                '2' CALL SLIDE DISPLAY ROUTINE
C
      INTEGER*2 IGRAPH,ITYPE,NELEM
      CHARACTER*64 HELPFILE
      CHARACTER*32 COLORS
      CHARACTER*8 GRAFNAME
      CHARACTER*1 RTNCODE      
      DATA HELPFILE /'P:\HELP\GRFINIT1.HLP'/
C      
50    CONTINUE
      ITYPE = 0
      GRAFNAME = ' '
      RTNCODE = '0'
      CALL CLS
      CALL LOCATE (1,1,IERR)
      CALL GETMNU('GRAPH-TYPE  ',HELPFILE,IGRAPH)
      IF (IGRAPH.EQ.0) THEN
         RTNCODE = '1'
      ELSE IF (IGRAPH.EQ.1.OR.IGRAPH.EQ.2) THEN
         CALL LOCATE (1,41,IERR)
         CALL GETMNU ('DATATYPES4  ','  ',ITYPE)
         IF (ITYPE.EQ.0) THEN
            GO TO 50
         END IF
      ELSE IF (IGRAPH.EQ.3) THEN
         ITYPE = 7
      ELSE IF (IGRAPH.EQ.4) THEN
C          .. WINDROSE
C             GET NUMBER OF DIRECTIONS
         NWRDIR=8
         CALL GTNWRDIR(NWRDIR,RTNCODE)
         IF (RTNCODE.EQ. '1') THEN
            GO TO 50
         ENDIF   
C          .. GET DATA TYPE 
         CALL LOCATE (1,41,IERR)
         CALL GETMNU ('DATATYPES3  ','  ',ITYPE)
         IF (ITYPE.EQ.0) THEN
            GO TO 50
         ELSE
            ITYPE = ITYPE + 2
         END IF
      ELSE IF (IGRAPH.EQ.5) THEN
         CALL GETGRAF (GRAFNAME,ITYPE,NELEM,RTNCODE)
         IF (GRAFNAME.EQ.' '.OR.RTNCODE.EQ.'1') THEN
            GO TO 50
         ELSE IF (RTNCODE.EQ.'2') THEN
            CALL WRTMSG(4,182,12,0,0,' ',0)
            CALL WRTMSG(3,183,12,1,1,' ',0)
            CALL DELGRAF(GRAFNAME)
            GO TO 50
         END IF
      ELSE IF (IGRAPH.EQ.6) THEN
         CALL GETGSCRN (GRAFNAME,COLORS,RTNCODE)
         IF (GRAFNAME.EQ.'     '.OR.RTNCODE.EQ.'1') THEN
            GO TO 50
         ELSE IF (RTNCODE.EQ.'2') THEN
            CALL WRTMSG(4,182,12,0,0,' ',0)
            CALL WRTMSG(3,183,12,1,1,' ',0)
            CALL DELSCRN(GRAFNAME)
            GO TO 50
         ELSE
C ----------------------------------------------------------------------
C   CODE TO OPEN AND BUILD A CONTROL FILE FOR A SLIDE DISPLAY ROUTINE
C   MUST BE WRITTEN AND INSERTED HERE.  THE BATCH FILE THAT CALLS
C   GRAFINIT CAN THEN CHECK FOR A CERTAIN ERRORLEVEL AND CALL THE SLIDE
C   ROUTINE IF THAT HAS BEEN REQUESTED.
C ---------------------------------------------------------------------- 
            OPEN(51,FILE='O:\DATA\SHOWSLID.PIC',STATUS='UNKNOWN')
            WRITE(51,500) GRAFNAME,(COLORS(LS:LS+1),LS=1,31,2)
  500       FORMAT('''GRAPH-SCREEN '',''',A8,'''',16(','A2)) 
            CLOSE (51)
            RTNCODE = '2'
         END IF
      END IF
      RETURN
      END
      