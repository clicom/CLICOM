$STORAGE:2
      SUBROUTINE DFSTNLST(NSELECT,STNSTAT,J2REC,MXRSTNG,J2RECD,MAXLST
     +                   ,RTNCODE)
C
C       ** INPUT:
C             NSELECT....NUMBER OF SELECTED STATIONS FOR THE CURRENT LIST
C             STNSTAT....HOLDS FLAGS FOR EACH RECORD IN STNGEOG.INF THAT HAS
C                        BEEN PROCESSED;  FLAGS INDICATE WHETHER A STATION HAS
C                        SLEECTED FOR THE PREDEFINED SELECTION LIST; NOTE THAT
C                        THE ARRAY POSITION IN STNSTAT CORRESPONDS TO THE
C                        RECORD NUMBER OF A STATION IN STNGEOG.INF.  POSITION
C                        NUMBER ONE DOES NOT REPRESENT A STATION SINCE RECORD
C                        ONE IS RESERVED FOR THE NUMBER OF STATIONS
C             J2REC......WORK ARRAY -- USED TO HOLD THE RECORD NUMBER IN 
C                        STNGEOG.INF FOR THE FIRST STATION IN EACH PAGE 
C                        OF THE SCREEN DISPLAY
C             MXRSTNG....DIMENSION OF STNSTAT; INDICATES THE MAXIMUM NUMBER OF 
C                        RECORDS IN STNGEOG.INF THAT CAN BE PROCESSED.  
C                        EACH STATION MUST BE FLAGGED AS SELECTED OR 
C                        NON-SELECTED.  THIS FLAG IS STORED IN STNSTAT.  
C                        MXRSTNG DETERMINES THE MAXIMUM NUMBER OF RECORDS THAT
C                        CAN BE CONSIDERED.  ANY ADDITIONAL STATIONS IN 
C                        STNGEOG.INF WILL BE IGNORED.
C             J2RECD.....DIMENSION OF J2REC
C             MAXLST.....MAXIMUM NUMBER OF STATIONS THAT CAN BE SELECTED FOR 
C                        THE CURRENT PLOT
C       ** OUTPUT:
C             NSELECT....NUMBER OF SELECTED STATIONS FOR THE CURRENT LIST
C             RTNCODE
C
C       .. ARGUMENTS
      INTEGER*2    MXRSTNG,J2RECD,NSELECT,J2REC(J2RECD)
      INTEGER*1    STNSTAT(MXRSTNG)
      CHARACTER*1  RTNCODE
C
C       .. LOCAL VARIABLES
C            J.......RECORD NUMBER FOR LAST RECORD READ FROM FILE
C            I.......NUMBER OF LINES DISPLAYED IN CURRENT PAGE -- HLDREC
C            ICRS....LINE NUMBER OF CURSOR ON CURRENT PAGE
C
      INTEGER*2 NCHRD,SRTBEG, SRTLEN,WINWIDTH,MAXLIN
      INTEGER*4 HLDNBR(24),INDXPG
      CHARACTER*2 INCHAR
      CHARACTER*3 DEVERS
      CHARACTER*5 CMAXLST
      CHARACTER*22 STNFILE
      CHARACTER*64 HELPFILE
      CHARACTER*80 INID,PREVID,HLDREC(24),INREC,PREVREC
      CHARACTER*80 MSGLN1,MSGLN2
      LOGICAL FOUND,FIRSTCALL,MSGON
C
      INTEGER*2 BUFFER(1300,2)
      COMMON /WINDOW/ BUFFER
C      
      DATA FIRSTCALL /.TRUE./, HELPFILE /'P:\HELP\DFSTNLST.HLP'/
      DATA IWINDOW /1/
      DATA MXI2NBR/32000/
      DATA STNFILE/'P:\DATA\STNGEOG.INF   '/
C
C   ON FIRST CALL TO THIS ROUTINE - READ MESSAGE TEXT
C
      IF (FIRSTCALL) THEN
         FIRSTCALL = .FALSE.
C         
         IDBEG     = 1
         IDLEN     = 8
         SRTBEG    = 17
         SRTLEN    = 24
         NCHRD     = 40
         WINWIDTH  = 50
         WINHGHT   =  23
         MAXLIN    = WINHGHT-3
         IWIDTH    = IDLEN + SRTLEN + 1
C         
         CALL GETMSG(100,MSGLN1)
         MSGLEN=LNG(MSGLN1)
         CALL GETDEASE(DEVERS)
         IF (DEVERS.EQ.'4.0') THEN
            NMSG=592
         ELSE
            NMSG=591
         ENDIF
         CALL GETMSG(NMSG,MSGLN2)
         CALL GETMSG(999,MSGLN2)
      END IF    
C      
      RTNCODE = '0'        
C
C  OPEN THE STNGEOG.INF FILE AND INITIALIZE
C
   20  OPEN (35,FILE=STNFILE,STATUS='OLD',ACCESS='DIRECT',RECL=80,
     +          SHARE='DENYWR',MODE='READ',IOSTAT=IOCHK)
      IF (IOCHK.NE.0) THEN
         CALL OPENMSG(STNFILE,'GRAFINIT    ',IOCHK)
         GO TO 20
      END IF
C
C     DETERMINE WHERE THE WINDOW SHOULD BE OPENED
C
      CALL POSLIN(JROW,JCOL)
      IF (JCOL.LT.40) THEN
         ICBEG = 80 - WINWIDTH
      ELSE
         ICBEG = 0
      END IF
      ICEND = ICBEG + WINWIDTH - 1
      IRBEG = 0
      IREND = IRBEG + WINHGHT - 1
C
C       ** OPEN AND CLEAR THE SCREEN WINDOW
C
      CALL OPENWIN(IWINDOW,BUFFER(1,IWINDOW),IRBEG,ICBEG,IREND,ICEND)
C
C       ** INITIALIZE
C
C       .. RECORD #1 IN STNGEOG.INF IS THE NUMBER OF STATIONS IN THE FILE
C          RECORD #2 CONTAINS THE FIRST STATION ID      
      J = 1
C      
      WRITE(CMAXLST,'(I5)') MAXLST
      DO 22 I=1,J2RECD
         J2REC(I)=0
   22 CONTINUE         
      PREVID = '        '
      I      = 0
      ICRS   = 1
      IPAGE  = 0
      INDXPG = -999
      MXPAGE = MIN0(J2RECD,MXI2NBR)
      MSGON  = .FALSE.
C
C   READ ONE SCREEN OF INPUT RECORDS (MAXLIN ENTRIES)
C
100   CONTINUE
      NLNPRV = I
      I = 0
      IPAGE = IPAGE + 1
      J2REC(IPAGE) = J + 1
110   CONTINUE
      FOUND = .TRUE.
      J = J + 1
      IF (J.GT.MXRSTNG) GO TO 120
      READ(35,REC=J,ERR=120) (INREC(I3:I3),I3=1,NCHRD)
      INID = INREC(IDBEG:IDBEG+IDLEN-1)
      INJ = J
C      
C       .. IF MULTIPLE ENTRIES FOR THE ID SAVE THE LAST ONE
      IF (INID.NE.PREVID) THEN
         IF (PREVID.NE.'      ') THEN
            I = I + 1
            HLDREC(I) = PREVREC
            HLDNBR(I) = JPREV
         ELSE
            DO 115 I2 = 1,MAXLIN
               HLDREC(I2) = ' '
               HLDNBR(I2) = 0
115         CONTINUE
         END IF
      END IF
C
      PREVID = INID
      PREVREC = INID
      PREVREC(IDLEN+2:IDLEN+SRTLEN+1)=INREC(SRTBEG:SRTBEG+SRTLEN-1)
      JPREV=INJ
      IF (I.LT.MAXLIN) THEN
         GO TO 110
      ELSE IF (IPAGE.LT.INDXPG) THEN
         J=HLDNBR(I)
         PREVID = '        '
         GO TO 100
      END IF
      GO TO 130
C
C   GET HERE IF EOF ENCOUNTERED IN STNGEOG.INF OR IF THE MAXIMUM NUMBER OF
C   STATIONS HAVE BEEN PROCESSED.  EACH STATION MUST BE FLAGGED AS SELECTED
C   OR NON SELECTED.  THIS FLAG IS STORED IN STNSTAT.  MXRSTNG-1 DETERMINES
C   THE NUMBER OF STATIONS THAT CAN BE DISPLAYED.  ANY ADDITIONAL STATIONS
C   IN STNGEOG.INF WILL BE IGNORED
C
120   CONTINUE
      I = I + 1
      IF (PREVID.EQ.'        ') THEN
         FOUND = .FALSE.
      ELSE
         HLDREC(I) = PREVREC
         HLDNBR(I) = JPREV
         PREVID = ' '
      END IF
C
C   DISPLAY THE SCREEN OF DATA
C
130   CONTINUE
      INDXPG = -999  
      IROW = 0
      ICOL = 0
      IF (FOUND) THEN
         CALL CLRWIN(IWINDOW)
         DO 150 I2 = 1,I
            INDX=HLDNBR(I2)
            ICOLOR=STNSTAT(INDX)
            CALL DSPREC(I2,ICBEG+1,ICOLOR,HLDREC(I2),IWIDTH)
150      CONTINUE
         CALL WTTALLY(NSELECT,IPAGE,MAXLST,WINWIDTH,IREND,ICBEG)
      END IF
C   
C       .. WRITE FUNCTION LINE      
      CALL LOCATE(IREND,ICBEG+1,IERR)
      CALL WRTSTR(MSGLN2,48,0,3)
C
C   HIGHLIGHT THE CURRENT LINE AND READ THE USER INPUT
C
180   CONTINUE
      IF (FOUND) THEN
         ICOLOR=1
         ILEN=8
         CALL DSPREC(ICRS,ICBEG+1,ICOLOR,HLDREC(ICRS),ILEN)
      ELSE
         IF (IPAGE.EQ.1) THEN
C             .. EOF ON FIRST RECORD OF PAGE 1; NO RECORDS FOUND IN THE FILE
            CALL CLRWIN(IWINDOW)
            CALL LOCATE(IRBEG+2,ICBEG+2,IERR)
            CALL WRTSTR(MSGLN1,38,15,3)
            PREVID = ' '
         ELSE
C             .. EOF ON FIRST RECORD OF A PAGE >1; PREVIOUS PAGE IS STILL 
C                DISPLAYED IN WINDOW; SET CURSOR TO LAST LINE OF PREVIOUS PAGE
            J=J2REC(IPAGE)-1
            IPAGE=IPAGE-1
            I=NLNPRV
            ICRS=I
            FOUND = .TRUE.
            ICOLOR=1
            ILEN=8
            CALL DSPREC(ICRS,ICBEG+1,ICOLOR,HLDREC(ICRS),ILEN)
            CALL BEEP
         ENDIF   
      END IF
      CALL GETCHAR(0,INCHAR)
      IF (MSGON) THEN
         MSGON = .FALSE.
         CALL CLRMSG(2)
      ENDIF   
C
C   IF HELP WANTED, DISPLAY IT AND ASK FOR NEXT USER INPUT.
C   OTHERWISE, REMOVE HIGHLIGHT ON THIS LINE IN ANTICIPATION OF MOVING
C   TO ANOTHER LINE.
C      
      IF (INCHAR.EQ.'1F') THEN
         CALL DSPWIN(HELPFILE)
         GO TO 180
      ELSE IF (FOUND) THEN
         INDX=HLDNBR(ICRS)
         ICOLOR=STNSTAT(INDX)
         CALL DSPREC(ICRS,ICBEG+1,ICOLOR,HLDREC(ICRS),IWIDTH)
      END IF
C
C   OTHERWISE, CHECK FOR PAGE, CURSOR, OR OTHER FUNCTION KEYS AND
C   TAKE THE APPROPRIATE ACTION.
C 
      IF (INCHAR.EQ.'DP') THEN
         ICRS = I + 1
      ELSE IF (INCHAR.EQ.'UP') THEN
         ICRS = 0
      ELSE IF (INCHAR.EQ.'HO') THEN
         ICRS = 1
      ELSE IF (INCHAR.EQ.'EN') THEN
         ICRS = I
      ELSE IF (INCHAR.EQ.'DA') THEN
         ICRS = ICRS + 1
      ELSE IF (INCHAR.EQ.'UA') THEN
         ICRS = ICRS - 1
      ELSE IF (INCHAR.EQ.'RE') THEN
         INDX=HLDNBR(ICRS)
         IF (STNSTAT(INDX).EQ.0) THEN
            IF (NSELECT.EQ.MAXLST) THEN
               CALL WRTMSG(2,593,12,1,0,CMAXLST,5)
               MSGON = .TRUE.
            ELSE   
               STNSTAT(INDX) = -1
               NSELECT=NSELECT+1
            ENDIF
         ELSE
            STNSTAT(INDX) = 0   
            NSELECT=NSELECT-1
         ENDIF   
         IF (FOUND) THEN
            CALL WTTALLY(NSELECT,IPAGE,MAXLST,WINWIDTH,IREND,ICBEG)
            INDX=HLDNBR(ICRS)
            ICOLOR=STNSTAT(INDX)
            CALL DSPREC(ICRS,ICBEG+1,ICOLOR,HLDREC(ICRS),IWIDTH)
         END IF
      ELSE IF (INCHAR.EQ.'2F') THEN
         IF (NSELECT.GT.0) THEN
            RTNCODE='0'
            GO TO 300
         ELSE   
            CALL WRTMSG(2,613,12,1,0,' ',0)
            MSGON = .TRUE.
         ENDIF   
      ELSE IF (INCHAR.EQ.'4F') THEN
         RTNCODE='1'
         GO TO 300
      ELSE IF (INCHAR.EQ.'3F' .AND. FOUND) THEN
         PREVID = ' '
         CALL GETMSG(612,PREVID)
         CALL LOCATE(IREND-1,ICBEG+1,IERR)
         CALL WRTSTR(PREVID,WINWIDTH-2,4,3)
         LENSTR = 5
         IC=MIN0((LNG(PREVID)+ICBEG+3),ICEND-LENSTR)
         CALL LOCATE(IREND-1,IC,IER)
         PREVID = ' '
         CALL GETSTR(3,PREVID,LENSTR,4,7,INCHAR)
         MSGON = .TRUE.
         CALL WTTALLY(NSELECT,IPAGE,MAXLST,WINWIDTH,IREND,ICBEG)
         IF (INCHAR.EQ.'4F') THEN
            PREVID = ' '
            GO TO 180
         ELSE
            READ(PREVID,'(I5)') INDXPG
            INDXPG = MIN0(MAX0(INDXPG,1),MXPAGE)
         ENDIF   
         PREVID = ' '
      ELSE
         CALL BEEP
         GO TO 180   
      END IF
C
C  IF SELECTED LINE IS OFF THE PAGE, SCROLL PAGE
C
      IF (INDXPG.NE.-999) THEN
         IF (INDXPG.LT.IPAGE) THEN
            IPAGE = INDXPG-1
            J = J2REC(INDXPG) - 1
            ICRS = 1
            PREVID = '        '
            GO TO 100
         ELSE IF (INDXPG.GT.IPAGE .AND. FOUND .AND. IPAGE.LT.MXPAGE)THEN
            ICRS = 1
            J=HLDNBR(I)
            PREVID = '        '
            GO TO 100
         ELSE   
            ICRS   = 1
            INDXPG = -999
         ENDIF
      ELSE IF (ICRS.GT.I) THEN
         IF (I.EQ.MAXLIN .AND. FOUND .AND. IPAGE.LT.MXPAGE) THEN
            ICRS = 1
            J=HLDNBR(I)
            PREVID = '        '
            GO TO 100
         ELSE
            ICRS = I
            CALL BEEP
         END IF
      ELSE IF (ICRS.LT.1) THEN
         IF (IPAGE.GT.1) THEN
            J = J2REC(IPAGE-1) - 1
            IPAGE = IPAGE - 2
            ICRS = MAXLIN
            PREVID = '        '
            GO TO 100
         ELSE
            ICRS = 1
            CALL BEEP
         END IF
      END IF
      GO TO 180  

  300 CONTINUE
C
C   CLOSE WINDOW, RESTORE SCREEN AND RETURN
C
      CALL CLOSWIN(IWINDOW,BUFFER(1,IWINDOW))
C
  350 RETURN
      END      

      SUBROUTINE WTTALLY(NSELECT,IPAGE,MAXLST,WINWIDTH,IREND,ICBEG)
      INTEGER*2    INDX(3),WINWIDTH
      CHARACTER*80 MSGLIN
      LOGICAL FRSTCALL
      DATA FRSTCALL/.TRUE./
C
      IF (FRSTCALL) THEN
         FRSTCALL = .FALSE.
         CALL GETMSG(583,MSGLIN)
         CALL GETMSG(999,MSGLIN)
         KNT = 0
         DO 15 I=1,WINWIDTH-3
          IF (MSGLIN(I:I).EQ.'=') THEN
             KNT = KNT + 1
             INDX(KNT) = I+1
             IF (KNT.EQ.3) GO TO 17
          ENDIF   
   15    CONTINUE          
         INDX(1) = 4 
         INDX(2) = 12
         INDX(3) = 20
   17    CONTINUE          
         MSGLEN=INDX(3)+5
      END IF    
C 
      WRITE(MSGLIN(INDX(1):INDX(1)+3),'(I4)') NSELECT
      WRITE(MSGLIN(INDX(2):INDX(2)+3),'(I4)') MAXLST-NSELECT
      WRITE(MSGLIN(INDX(3):INDX(3)+4),'(I5)') IPAGE
      CALL LOCATE(IREND-1,ICBEG+1,IERR)
      CALL WRTSTR(MSGLIN,MSGLEN,4,3)
C
      RETURN
      END      
      