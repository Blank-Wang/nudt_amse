@echo off&setlocal EnableDelayedExpansion 
set a=1 
for /f "delims=" %%i in ('dir /b *.tif') do ( 
if not "%%~ni"=="%~n0" ( 
 ren "%%i" "!a!.tif" 
set/a a+=1 
) 
)