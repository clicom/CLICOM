$STORAGE:2
C     PROGRAM FDFRESET
C
C   PROGRAM RESETS THE DATAEASE FORMS DIRECTORY FILE WITH THE NUMBER OF
C       RECORDS AND DELETED RECORDS APPROPRIATE FOR THE CLIMATE DATA
C       NOW ON DISC.  IT READS THE NUMBERS FROM THE FILES WRITTEN BY 
C       THE "TRANSFER" PROGRAM.  THIS PROGRAM HAS BEEN MODIFIED TO USE 
C       EITHER DATAEASE VERSION 2.5 OR DATAEASE VERSION 4.0 AND ALDO
C       DATAEASE 5.0
C       IT RESETS THE NUMBERS BY RE-WRITING THE RDRRAAAA.DBM FILE - 
C   
C      THE DATA TYPE MUST BE PASSED TO THIS ROUTINE VIA THE COMMAND
C      LINE AS MLY,10D,DLY,SYN,HLY,15M OR U-A, HML, H10, HDL, HSY,
C      HHL, H15, HUA.
C
      INTERFACE TO SUBROUTINE CMDLIN(ADDRES,LENGTH,RESULT)
      INTEGER*4 ADDRES[VALUE],LENGTH[VALUE]
      CHARACTER*1 RESULT
      END
C
      PROGRAM FDFRESET
      CHARACTER*1 INREC(51),INREC4(55),INREC5(74)
      CHARACTER*2 INNUM,INDEL
      CHARACTER*3 RECTYPE,DEVER
      CHARACTER*4 CNREC,INNUM4,INDEL4,INNUM5,INDEL5
      CHARACTER*14 FILE,FILE4,FILE5
      CHARACTER*20 FDNREC
      CHARACTER*22 FDFFIL
      CHARACTER*24 INFORM,INFRM4,INFRM5
      CHARACTER*78 MSGLN
      INTEGER*2 RECNUM
      INTEGER*4 NREC,NDEL

      EQUIVALENCE (INFORM,INREC(3)),(INNUM,INREC(30))
     +           ,(INDEL,INREC(32)),(FILE,INREC(34))
      EQUIVALENCE (INFRM4,INREC4(3)),(INNUM4,INREC4(30))
     +           ,(INDEL4,INREC4(34)),(FILE4,INREC4(38))
      EQUIVALENCE (INFRM5,INREC5(4)),(INNUM5,INREC5(31))
     +           ,(INDEL5,INREC5(35)),(FILE5,INREC5(41))
      EQUIVALENCE (NREC,CNREC)
C
      INTEGER*4 PSP,PSPNCHR,OFFSET
C
C  FOLLOWING STATEMENT REQUIRED FOR FORTRAN 3.3  - NOT ALLOWED IN FTN 4
c      EXTERNAL FDFRESET
C
C   LOCATE SEGMENTED ADDRESS OF THE BEGINNING OF THIS PROGRAM
C
      OFFSET = #00100000
      PSP = LOCFAR(FDFRESET)
C
C   COMPUTE THE BEGINNING OF THE PROGRAM SEGMENT PREFIX (PSP)
C
      PSP = (PSP - MOD(PSP,#10000)) - OFFSET 
C
C   LOCATE POSITION OF COMMAND PARAMTERS WITHIN THE PSP
C
      PSPNCHR = PSP + #80
      PSP = PSP + #81
C
C   PASS THE ADDRESS OF THE COMMAND PARAMETERS TO CMDLIN WHICH DECODES
C      THE COMMAND AND RETURNS IT AS RECTYPE.
C
      CALL CMDLIN(PSP,PSPNCHR,RECTYPE)
      
      
C 
C    DETERMINE WHICH VERSION OF DATAEASE IS IN USE
C
      CALL GETDEASE(DEVER)
      IF (DEVER.EQ.'4.0') THEN
         GOTO 500
      END IF
      IF (DEVER.EQ.'5.0') THEN
         GOTO 600
      END IF
C *****************************************************************************
C *                     CODE FOR DATAEASE 2.5
C *****************************************************************************

C
C   FIND THE RDRRAAAA ENTRY FOR THE RECTYPE SPECIFIED ON THE CMD LINE
C
      CALL RDRREC(RECTYPE,RECNUM)
      IF (RECNUM.EQ.0) THEN
         STOP 
      ELSE
C
C   READ THE FILE NAME FROM THAT RECORD AND BUILD THE FDN FILE NAME
C
         READ(22,REC=RECNUM) INREC
         FDFFIL = FILE
         FDFFIL(12:14) = 'FDN'
         OPEN (72,FILE=FDFFIL,STATUS='OLD',FORM='FORMATTED'
     +          ,IOSTAT=IOCHK)
C
C   READ THE NUMBER OF RECORDS IN THE FILE FROM THE FDN FILE
C   NREC IS INTEGER*4 (EQUIVALENCED TO CNREC CHAR*4)
C
         IF (IOCHK.EQ.0) THEN
            READ(72,'(A20)') FDNREC
            IF (FDNREC(13:20).EQ.'        ') THEN
C                 .. ARCHIVED UNDER DEASE 2.5 -- UNARCHIVED UNDER DEASE 2.5
                READ(FDNREC(1:6),'(I6)') NREC
                READ(FDNREC(7:12),'(I6)') NDEL
            ELSE
C                 .. ARCHIVED UNDER DEASE 4.X -- UNARCHIVED UNDER DEASE 2.5
C                    INDEX FILES MUST BE REBUILT
                READ(FDNREC(1:10),'(I10)') NREC
                READ(FDNREC(11:20),'(I10)') NDEL
                OPEN (61,FILE='P:\BATCH\INDXARC2.BAT',STATUS='NEW',
     +                  FORM='FORMATTED',IOSTAT=IOCHK)
                CALL GETMSG(242,MSGLN)
                WRITE(61,'(A)') MSGLN
                CALL GETMSG(231,MSGLN)
                CALL GETMSG(999,MSGLN)
                WRITE(61,'(A)') MSGLN
                CLOSE (61)
            END IF
         ELSE
            CALL WRTMSG(2,56,12,1,1,RECTYPE,3)
            STOP
         END IF
C
         CLOSE (72)
C
C   CONVERT THE INTEGER*4 VALUE TO INTEGER*2  AND WRITE THE NEW RECORD
C
         INNUM = CNREC(1:2)
         INDEL(1:2) = NDEL
         WRITE(22,REC=RECNUM) INREC
         CLOSE(22)
c
         CALL GETMSG(277,MSGLN)
         CALL GETMSG(999,MSGLN)
         WRITE(*,'(/,4X,I6,A4,A64,/)') NREC,RECTYPE,MSGLN
      END IF
      GOTO 999
      
C *****************************************************************************
C *                     CODE FOR DATAEASE 4.0
C *****************************************************************************



C
C   FIND THE RDRRAAAA ENTRY FOR THE RECTYPE SPECIFIED ON THE CMD LINE
C
 500  CALL RDRREC(RECTYPE,RECNUM)
      IF (RECNUM.EQ.0) THEN
         STOP 
      ELSE
C
C   READ THE FILE NAME FROM THAT RECORD AND BUILD THE FDN FILE NAME
C
         READ(22,REC=RECNUM) INREC4
         FDFFIL = FILE4
         FDFFIL(12:14) = 'FDN'
         OPEN (72,FILE=FDFFIL,STATUS='OLD',FORM='FORMATTED'
     +          ,IOSTAT=IOCHK)
C
C   READ THE NUMBER OF RECORDS IN THE FILE FROM THE FDN FILE
C   NREC IS INTEGER*4 (EQUIVALENCED TO CNREC CHAR*4)
C
         IF (IOCHK.EQ.0) THEN
            READ(72,'(A20)') FDNREC
            IF (FDNREC(13:20).EQ.'        ') THEN
C                 .. ARCHIVED UNDER DEASE 2.5 -- UNARCHIVED UNDER DEASE 4.X
C                    INDEX FILES MUST BE REBUILT
                READ(FDNREC(1:6),'(I6)') NREC
                READ(FDNREC(7:12),'(I6)') NDEL
                OPEN (61,FILE='P:\BATCH\INDXARC4.BAT',STATUS='NEW',
     +                  FORM='FORMATTED',IOSTAT=IOCHK)
                CALL GETMSG(241,MSGLN)
                WRITE(61,'(A)') MSGLN
                CALL GETMSG(231,MSGLN)
                CALL GETMSG(999,MSGLN)
                WRITE(61,'(A)') MSGLN
                CLOSE (61)
            ELSE
C                 .. ARCHIVED UNDER DEASE 4.X -- UNARCHIVED UNDER DEASE 4.X
                READ(FDNREC(1:10),'(I10)') NREC
                READ(FDNREC(11:20),'(I10)') NDEL
            END IF
         ELSE
            CALL WRTMSG(2,56,12,1,1,RECTYPE,3)
            STOP
         END IF
C
         CLOSE (72)
C
C   CONVERT THE INTEGER*4 VALUE TO INTEGER*2  AND WRITE THE NEW RECORD
C
         INNUM4 = NREC
         INDEL4 = NDEL
         WRITE(22,REC=RECNUM) INREC4
         CLOSE(22)
c
         CALL GETMSG(277,MSGLN)
         CALL GETMSG(999,MSGLN)
         WRITE(*,'(/,4X,I6,A4,A64,/)') NREC,RECTYPE,MSGLN
      END IF


      STOP ' '
     GOTO 999
      
C *****************************************************************************
C *                     CODE FOR DATAEASE 5.0
C *****************************************************************************
C
C   FIND THE RDRRAAAA ENTRY FOR THE RECTYPE SPECIFIED ON THE CMD LINE
C
 600  CALL RDRREC(RECTYPE,RECNUM)
      IF (RECNUM.EQ.0) THEN
         STOP 
      ELSE
C
C   READ THE FILE NAME FROM THAT RECORD AND BUILD THE FDN FILE NAME
C
         READ(22,REC=RECNUM) INREC5
         FDFFIL = FILE5
         FDFFIL(12:14) = 'FDN'
         OPEN (72,FILE=FDFFIL,STATUS='OLD',FORM='FORMATTED'
     +          ,IOSTAT=IOCHK)
C
C   READ THE NUMBER OF RECORDS IN THE FILE FROM THE FDN FILE
C   NREC IS INTEGER*4 (EQUIVALENCED TO CNREC CHAR*4)
C
         IF (IOCHK.EQ.0) THEN
            READ(72,'(A20)') FDNREC
            IF (FDNREC(13:20).EQ.'        ') THEN
C                 .. ARCHIVED UNDER DEASE 2.5 -- UNARCHIVED UNDER DEASE 4.X
C                    INDEX FILES MUST BE REBUILT
                READ(FDNREC(1:6),'(I6)') NREC
                READ(FDNREC(7:12),'(I6)') NDEL
                OPEN (61,FILE='P:\BATCH\INDXARC4.BAT',STATUS='NEW',
     +                  FORM='FORMATTED',IOSTAT=IOCHK)
                CALL GETMSG(241,MSGLN)
                WRITE(61,'(A)') MSGLN
                CALL GETMSG(231,MSGLN)
                CALL GETMSG(999,MSGLN)
                WRITE(61,'(A)') MSGLN
                CLOSE (61)
            ELSE
C                 .. ARCHIVED UNDER DEASE 4.X -- UNARCHIVED UNDER DEASE 4.X
                READ(FDNREC(1:10),'(I10)') NREC
                READ(FDNREC(11:20),'(I10)') NDEL
            END IF
         ELSE
            CALL WRTMSG(2,56,12,1,1,RECTYPE,3)
            STOP
         END IF
C
         CLOSE (72)
C
C   CONVERT THE INTEGER*4 VALUE TO INTEGER*2  AND WRITE THE NEW RECORD
C
         INNUM5 = NREC
         INDEL5 = NDEL
         WRITE(22,REC=RECNUM) INREC5
         CLOSE(22)
c
         CALL GETMSG(277,MSGLN)
         CALL GETMSG(999,MSGLN)
         WRITE(*,'(/,4X,I6,A4,A64,/)') NREC,RECTYPE,MSGLN
      END IF


      STOP ' '
 999  END
