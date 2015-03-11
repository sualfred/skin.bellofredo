@echo off
echo.
echo. [ SVN Committer ]
:: The two lines below should be changed to suit your system.
set SOURCE=E:\github\Bello-Kodi-15.x-Nightlies\
set SVN=C:\Program Files\TortoiseSVN\bin
echo.
echo. Committing %SOURCE% to SVN...
"%SVN%\TortoiseProc.exe" /command:commit /path:"%SOURCE%" /closeonend:3
echo. done.
echo.
echo. Operation complete.