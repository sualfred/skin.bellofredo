@echo off
setlocal enabledelayedexpansion
set tools_dir=%~dp0tools

echo ^<?xml version="1.0" encoding="UTF-8" standalone="yes"?^> > %~dp0addon.xml
echo ^<addons^> >> %~dp0addon.xml

if exist plugin.video.amazon\resources\cache rd /s /q plugin.video.amazon\resources\cache >nul 2>&1

for /f %%f in ('dir /b /a:d') do if exist %%f\addon.xml (
    del /q /s %%f\*.pyo >nul 2>&1
    del /q /s %%f\*.pyc >nul 2>&1
    set add=
    for /f "delims=" %%a in (%%f\addon.xml) do (
        set line=%%a
        if "!line:~0,6!"=="<addon" set add=1
        if not "!line!"=="!line:version=!" if "!add!"=="1" (
            set new=!line:version=ß!
            for /f "delims=ß tokens=2" %%n in ("!new!") do set new=%%n
            for /f "delims=^= " %%n in ("!new!") do set new=%%n
            set version=!new:^"=!
        )
        if "!line:~-1!"==">" set add=
        if not "!line:~0,5!"=="<?xml" echo %%a >> %~dp0addon.xml
    )
    IF not exist temp mkdir temp	
	IF not exist temp\%%f mkdir temp\%%f
	IF not exist temp\%%f\oldreleases mkdir temp\%%f\oldreleases	    
	if not exist %%f\%%f-!version!.zip (
        move "%%f\%%f*.zip" temp\%%f\oldreleases >nul 2>&1
		if exist %%f\media (
			echo Verschiebe Media zu Temp
			xcopy /k /r /e /i /s /c /h /o /x /y /d /q "%%f\media\*.*" "temp\%%f\media\*.*" >nul 2>&1
			rd /S /Q %%f\media
			mkdir %%f\media
			echo Erstelle Textures.xbt
			%tools_dir%\TexturePacker -input temp\%%f\media -output %%f\media\Textures.xbt >nul 2>&1       
			)
		if exist %%f\720p\script-skinshortcuts-includes.xml echo Entferne Skinshortcutsinclude Datei
		if exist %%f\720p\script-skinshortcuts-includes.xml del /q %%f\720p\script-skinshortcuts-includes.xml
		echo Packe %%f-!version!.zip
		%tools_dir%\7z a %%f\%%f-!version!.zip %%f -tzip -ax!%%f*.zip> nul
		if exist %%f\media\Textures.xbt (
			echo Stelle original Media Ordner wieder her
			rd /s /q %%f\media
			mkdir %%f\media
			xcopy /k /r /e /i /s /c /h /o /x /y /d /q "temp\%%f\media\*.*" "%%f\media\*.*" >nul 2>&1
			rd /s /q temp\%%f\media
		)
    ) else (
        echo %%f-!version!.zip bereits aktuell
    )
)

echo ^</addons^> >> %~dp0addon.xml
for /f "delims= " %%a in ('%tools_dir%\fciv -md5 %~dp0addon.xml') do echo %%a > %~dp0addon.xml.md5
pause