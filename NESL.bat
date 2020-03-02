:: Never Ending Server Launcher (Delete cache & start server)
@echo off
title [NESL] Never Ending Server Launcher
CALL:ECHOTITLE "[NESL] Never Ending Server Launcher"
:ECHOTITLE
%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Red %1
echo [NESL] Version 2.0 by chrono for Never Ending Roleplay
echo -------------------------------------------------------------------------------------
:: Folder name to delete, in this case "cache"
echo [NESL] TASK START: Looking for cache and deleting it...
@RD /S /Q "cache"
set time=3
echo [NESL] TASK START: Looking for duplicated instances and killing them...
echo -------------------------------------------------------------------------------------
taskkill /F /FI "WINDOWTITLE eq [NESL] - StartServer.cmd" /T
echo -------------------------------------------------------------------------------------
:loop1
set /a time=%time%-1
if %time%==0 goto end1
ping localhost -n 2 > nul
goto loop1
:end1
echo [NESL] TASK COMPLETE: Cache deleted...
echo -------------------------------------------------------------------------------------

set time=3
:loop2
set /a time=%time%-1
if %time%==0 goto end2
ping localhost -n 2 > nul
goto loop2
:end2
echo [NESL] TASK START: Launching server...

:: File to start, in this case "StartServer.cmd"
cd C:\1383
START "[NESL]" StartServer.cmd

set time=3
:loop3
set /a time=%time%-1
if %time%==0 goto end3
ping localhost -n 2 > nul
goto loop3
:end3
echo [NESL] TASK COMPLETE: Server launched...
echo -------------------------------------------------------------------------------------
echo [NESL] TASK START: Preparing to shut down launcher..

set time=15
:loop5
set /a time=%time%-1
if %time%==0 goto end5
ping localhost -n 2 > nul
goto loop5
:end5

echo [NESL] TASK COMPLETE: Shutting down launcher...
set time=15
set /a time=%time%-1
if %time%==0 goto end4
ping localhost -n 1 > nul
:end4

set time=15
:loop5
set /a time=%time%-1
if %time%==0 goto end6
ping localhost -n 2 > nul
exit