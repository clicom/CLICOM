$STORAGE:2
      SUBROUTINE OPENFILES(IRDWRT)
C
C  THIS ROUTINE OPEN THE INDEX (IDX) AND DATA (TWF) FILES USED IN THE 
C     EDIT/QC MODULES.
C
C     IRDWRT IS A CONTROL VARIABLE. IF IT = 1 THE FILES ARE OPENED READ
C          ONLY.  IF IT = 2 THE FILES ARE OPENED FOR WRITE. 
C     
C     PROVISIONS HAVE BEEN MADE FOR OPENING THE FILES IN SHARED MODE
C
      INTEGER*2 OPNCNT,IRDWRT
      CHARACTER*22 MSGTXT
      CHARACTER*22 ERRFIL
C      
$INCLUDE: 'INDEX.INC'
C
      OPNCNT = 0
   10 CONTINUE
      IF (IRDWRT.EQ.1) THEN
         OPEN (19,FILE=IDXNAM,STATUS='OLD',ACCESS='DIRECT',
     +         MODE='READ',SHARE='DENYWR',     
     +         FORM='UNFORMATTED',RECL=25,IOSTAT=IOCHK)
      ELSE IF (IRDWRT.EQ.2) THEN
         OPEN (19,FILE=IDXNAM,STATUS='OLD',ACCESS='DIRECT',
     +         MODE='READWRITE',SHARE='DENYWR',     
     +         FORM='UNFORMATTED',RECL=25,IOSTAT=IOCHK)
      END IF
      IF(IOCHK.GE.6410.AND.IOCHK.LE.6414) THEN
         ERRFIL = IDXNAM
         CALL OPENMSG(ERRFIL,'OPENFILES   ',IOCHK)
         GO TO 10
      ELSE IF (IOCHK.NE.0) THEN
         WRITE(MSGTXT,'(A18,I4)') IDXNAM,IOCHK
         CALL WRTMSG(4,157,12,1,0,MSGTXT,22)
         STOP 2            
      END IF   
C
      OPNCNT = 0
   20 CONTINUE
      IF (IRDWRT.EQ.1) THEN
         OPEN (20,FILE=FILNAM,STATUS='OLD',ACCESS='DIRECT',
     +         MODE='READ',SHARE='DENYWR',     
     +         FORM='UNFORMATTED',RECL=RLNGTH,IOSTAT=IOCHK)
      ELSE IF (IRDWRT.EQ.2) THEN
         OPEN (20,FILE=FILNAM,STATUS='OLD',ACCESS='DIRECT',
     +         MODE='READWRITE',SHARE='DENYWR',     
     +         FORM='UNFORMATTED',RECL=RLNGTH,IOSTAT=IOCHK)
      END IF
      IF(IOCHK.GE.6410.AND.IOCHK.LE.6414) THEN
         ERRFIL = FILNAM
         CALL OPENMSG(ERRFIL,'OPENFILES   ',IOCHK)
         GO TO 20
      ELSE IF (IOCHK.NE.0) THEN
         WRITE(MSGTXT,'(A18,I4)') FILNAM,IOCHK
         CALL WRTMSG(4,157,12,1,0,MSGTXT,22)
         STOP 2            
      END IF   
C
      RETURN
      END
