echo off
FL /FPi /Od /c %1.FOR
IF ERRORLEVEL 1 GOTO EXIT
LIB C:\clicom\LIB\CORELIB -+%1;
:EXIT
