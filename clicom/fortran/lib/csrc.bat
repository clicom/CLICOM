FL /Od /4Nb /c %1.FOR 
IF ERRORLEVEL 2 GOTO DONE
link %1+C:\fortran\lib\HALODVXX/SEG:250/NOE/EXEPACK,,%1.MAP,HALOF+CORELIB+KWLIB+ASM+UTILITY+PLTUTIL;
:DONE


