echo off
DEL %1.OBJ
FL /FPi /Od /c %1.FOR 
IF ERRORLEVEL 1 GOTO EXIT
LIB C:\clicom\LIB\PLTUTIL -+%1;
IF EXIST %1.OBJ COPY %1.OBJ ..\GRAFMAIN
:EXIT
