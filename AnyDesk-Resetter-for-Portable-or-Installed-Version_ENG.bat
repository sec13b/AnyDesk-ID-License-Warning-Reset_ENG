::---------------------------------------------------
:: Admin Authorization code HEAD
@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
:: Admin Authorization code SONU

@echo off & setlocal enableextensions
title Reset AnyDesk
reg query HKEY_USERS\S-1-5-19 >NUL || (echo Please Run as administrator.& pause >NUL&exit)

::chcp 1252
chcp 65001
cls
:: File paths
set APPDATA_ANYDESK=%APPDATA%\AnyDesk
set ALLUSERSPROFILE_ANYDESK=%ProgramData%\AnyDesk
::%ALLUSERSPROFILE%\AnyDesk\ ile %ProgramData%\AnyDesk\ aynı.
set TEMP_ANYDESK=%temp%\AnyDesk

:: Control operations and setting installedversion
if exist "%ALLUSERSPROFILE_ANYDESK%\system.conf" if exist "%ALLUSERSPROFILE_ANYDESK%\service.conf" (
    set installedversion=installed
    echo Installed version found.
) else (
    set installedversion=
    echo Portable version found.
)

:: We check the installedversion variable
echo Installed version: %installedversion%

:: If service.conf and system.conf are not present in both paths, finish the process
::if not exist "%ALLUSERSPROFILE_ANYDESK%\service.conf" if not exist "%APPDATA_ANYDESK%\service.conf" if not exist "%ALLUSERSPROFILE_ANYDESK%\system.conf" if not exist "%APPDATA_ANYDESK%\system.conf" (
::    echo No files found, terminating the process.
::    goto :eof
::)

:: If service.conf and system.conf files are not together in the same path, finish the process
if not exist "%ALLUSERSPROFILE_ANYDESK%\service.conf" if not exist "%ALLUSERSPROFILE_ANYDESK%\system.conf" (
    if not exist "%APPDATA_ANYDESK%\service.conf" if not exist "%APPDATA_ANYDESK%\system.conf" (
        echo No files found, terminating the process.
		pause
        goto :eof
    )
)

:: If there is only one file, delete the current one
if exist "%ALLUSERSPROFILE_ANYDESK%\service.conf" if not exist "%ALLUSERSPROFILE_ANYDESK%\system.conf" (
    del /f "%ALLUSERSPROFILE_ANYDESK%\service.conf"
	echo The missing files were found and the existing service.conf file was deleted.
)
if exist "%ALLUSERSPROFILE_ANYDESK%\system.conf" if not exist "%ALLUSERSPROFILE_ANYDESK%\service.conf" (
    del /f "%ALLUSERSPROFILE_ANYDESK%\system.conf"
	echo The missing files were found and the existing system.conf file was deleted.
)
if exist "%APPDATA_ANYDESK%\service.conf" if not exist "%APPDATA_ANYDESK%\system.conf" (
    del /f "%APPDATA_ANYDESK%\service.conf"
	echo The missing files were found and the existing service.conf file was deleted.
)
if exist "%APPDATA_ANYDESK%\system.conf" if not exist "%APPDATA_ANYDESK%\service.conf" (
    del /f "%APPDATA_ANYDESK%\system.conf"
	echo The missing files were found and the existing system.conf file was deleted.
)


call :stop_any

echo The process starts...
:: Closing AnyDesk in tray
::taskkill /f /im "AnyDesk.exe" 2>NUL
::for /f "tokens=1,2 delims= " %%A in ('tasklist /FI "IMAGENAME eq Anydesk.exe" /NH') do echo %%A=%%B &tskill %%B>nul
::for /f "tokens=1,2 delims= " %%A in ('tasklist /FI "IMAGENAME eq Anydesk.exe" /NH') do echo %%A=%%B &tskill %%B>nul
::for /f "tokens=1,2 delims= " %%A in ('tasklist /FI "IMAGENAME eq Anydesk.exe" /NH') do echo %%A=%%B &tskill %%B>nul


:: First check the service.conf.bak file and delete it if it exists
if exist "%ALLUSERSPROFILE_ANYDESK%\service.conf.bak" (
    del /f "%ALLUSERSPROFILE_ANYDESK%\service.conf.bak"
	echo The old service.conf.bak backup has been deleted.
)
timeout 1
:: Backup if you have service.conf
if exist "%ALLUSERSPROFILE_ANYDESK%\service.conf" (
    rename "%ALLUSERSPROFILE_ANYDESK%\service.conf" "service.conf.bak" 2>NUL
	echo service.conf file renamed to service.conf.bak and backed up.
)
timeout 1
:: Do the same for system.conf
if exist "%ALLUSERSPROFILE_ANYDESK%\system.conf.bak" (
    del /f "%ALLUSERSPROFILE_ANYDESK%\system.conf.bak"
	echo The old system.conf.bak backup was deleted.
)
timeout 1
if exist "%ALLUSERSPROFILE_ANYDESK%\system.conf" (
    rename "%ALLUSERSPROFILE_ANYDESK%\system.conf" "system.conf.bak" 2>NUL
	echo system.conf file renamed to system.conf.bak and backed up.
)
timeout 1
:: Do the same again on the APPDATA path
if exist "%APPDATA_ANYDESK%\service.conf.bak" (
    del /f "%APPDATA_ANYDESK%\service.conf.bak"
	echo Old service.conf.bak backup deleted.
)
timeout 1
if exist "%APPDATA_ANYDESK%\service.conf" (
    rename "%APPDATA_ANYDESK%\service.conf" "service.conf.bak" 2>NUL
	echo service.conf file renamed to service.conf.bak and backed up.
)
timeout 1
if exist "%APPDATA_ANYDESK%\system.conf.bak" (
    del /f "%APPDATA_ANYDESK%\system.conf.bak"
	echo The old system.conf.bak backup was deleted.
)
timeout 1
if exist "%APPDATA_ANYDESK%\system.conf" (
    rename "%APPDATA_ANYDESK%\system.conf" "system.conf.bak" 2>NUL
	echo system.conf file renamed to system.conf.bak and backed up.
)
timeout 1
:: Restore operations
goto :start_any
::call :start_any

:SonGiris
goto :Son


:start_any
echo Running the startup part...

:: If you have an installed version
if "%installedversion%"=="installed" (
    echo Found installed version, starting the Anydesk service...
    call :start_installed_any
) else (
    echo Portable version found. Run the Anydesk program manually.
	call :start_portable_any
)
goto :eof

:start_portable_any
echo Run the AnyDesk program and continue.
echo Run the AnyDesk program and continue.
echo Run the AnyDesk program and continue.
echo Run the AnyDesk program and continue.
echo Run the AnyDesk program and continue.

timeout /t 10 /nobreak >NUL
pause
goto :lic
goto :eof

:start_installed_any
echo Trying to start the Anydesk service

:: Check if the service is working
sc query AnyDesk | find "STATE" | find "RUNNING" >NUL
if %errorlevel% neq 0 (
    echo Launching the AnyDesk service
    sc start AnyDesk
    timeout /t 5 /nobreak >NUL
    sc query AnyDesk | find "STATE" | find "RUNNING" >NUL
    if %errorlevel% neq 0 (
        echo Service failed to start. Trying again...
        goto :start_installed_any
    ) else (
        echo AnyDesk service has been successfully launched.
    )
) else (
    echo AnyDesk service is already running.
    echo Anydesk.exe will be started.
	call :start_any_exe
)

goto :eof


:start_any_exe
set "AnyDesk1=%SystemDrive%\Program Files (x86)\AnyDesk\AnyDesk.exe"
set "AnyDesk2=%SystemDrive%\Program Files\AnyDesk\AnyDesk.exe"
if exist "%AnyDesk1%" start "" "%AnyDesk1%"
if exist "%AnyDesk2%" start "" "%AnyDesk2%"
echo 10 If you wait a second and AnyDesk does not open, wait for it to open and then continue.
timeout /t 10 /nobreak >NUL
goto :lic

:::start_any_exe_backup
::if exist "c:\Program Files (x86)" (set ostype=64) else (set ostype=32)
::if %ostype%==32 (set pdir="C:\Program Files\AnyDesk\") else (set pdir="C:\Program Files (x86)\AnyDesk\")
::c:
::cd\
::cd %pdir%
::start Anydesk.exe
::goto :Son

:stop_any
echo stop any

:: Check the status of the service
sc query AnyDesk | find "STATE" | find "RUNNING" >NUL
if %errorlevel% equ 0 (
    :: If the service is running, try stopping it
    echo Anydesk service is being discontinued...
    sc stop AnyDesk
    :: Wait for the service to stop
    timeout /t 5 /nobreak >NUL
    :: Check if the service stops
    sc query AnyDesk | find "STATE" | find "STOPPED" >NUL
    if %errorlevel% neq 0 (
        :: Error message if the service has not stopped
        echo Service could not be stopped. Trying again...
		goto :stop_any
    ) else (
        echo AnyDesk service has been successfully stopped.
    )
) else (
    echo AnyDesk service is already down.
)

:: 	Close AnyDesk processes
taskkill /f /im "AnyDesk.exe" 2>NUL

goto :eof

:lic
:: If you have an installed version
if "%installedversion%"=="installed" (
    echo  Found installed version, starting the Anydesk service...
    goto :installed_lic
) else (
    echo Portable version found. Run the Anydesk program manually.
    goto :portable_lic_check
)
goto :lic

:portable_lic_check
:: ad.anynet.id check is being done for the portable version.
if exist "%APPDATA_ANYDESK%\system.conf" (
    echo %APPDATA_ANYDESK%\system.conf file found.
	goto :portable_lic
) else (
    echo %APPDATA_ANYDESK%\system.conf file not found. Please run the AnyDesk software. 
    timeout /t 15 /nobreak >NUL
    goto :portable_lic_check
)
goto :eof

:portable_lic
echo checking ad.anynet.id for the installed version.
type "%APPDATA_ANYDESK%\system.conf" | find "ad.anynet.id=" || goto lic
goto :Son

:installed_lic
echo checking ad.anynet.id for the installed version.
type "%ALLUSERSPROFILE_ANYDESK%\system.conf" | find "ad.anynet.id=" || goto lic
::type "C:\ProgramData\AnyDesk\system.conf" | find "ad.anynet.id=" || goto lic
goto :Son

:Son
echo *********
echo *********
echo *********
echo *********
echo *********
echo AnyDesk ID Reset completed successfully.
timeout /t 10 /nobreak >NUL
pause
exit /b

:Hata
echo *********
echo *********
echo *********
echo *********
echo *********
echo An error occurred somewhere. It is not known if the operation was successful. Check manually.
echo If conf files were backed up and deleted, they were reset and the ID changed.
timeout /t 10 /nobreak >NUL
pause
exit /b
