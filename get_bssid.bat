@echo off
setlocal enabledelayedexpansion
for /f "tokens=1 delims=:" %%i in ('netsh wlan show interfaces ^| findstr /i "BSSID.*[:]"') DO for /f "tokens=* delims=" %%a in ("%%i") do set "BSSID_KEY=%%a"
call :trim "%BSSID_KEY%" BSSID_KEY
set networks=0
for /f "tokens=1,* delims=:" %%i in ('netsh wlan show interfaces ^| findstr /iR "Name BSSID"') do (
call :trim "%%i" temp_name
if /i "!temp_name!"=="Name" set /a networks+=1&for /f "tokens=* delims= " %%s in ("%%j") do set "name_[!networks!]=%%s"
if /i "!temp_name!"=="%BSSID_KEY%" for /f "tokens=* delims= " %%d in ("%%j") do set bssid_[!networks!]=%%d
)
for /l %%a in (1,1,!networks!) do if "!name_[%%a]!"=="%~1" if "!bssid_[%%a]!" NEQ "" echo !bssid_[%%a]!
goto :eof
:trim
set trim_output=
set /a token_number=0
:trim_begin
set /a token_number+=1
set trim_happen=0
for /f "tokens=%token_number% delims= " %%i in (%1) do ( if "%%i"=="" goto trim_end
set "trim_output=!trim_output! %%i"
set /a trim_happen=1
)
if %trim_happen%==1 goto trim_begin
for /f "tokens=* delims= " %%i in ("!trim_output!") do set "trim_output=%%i"
set "%~2=!trim_output!"
:trim_end