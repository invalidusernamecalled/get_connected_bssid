@echo off 
setlocal enabledelayedexpansion
set networks=0
for /f "tokens=1,* delims=:" %%i in ('netsh wlan show interfaces ^| findstr /iR "Name BSSID"') do (
set temp_name=%%i
set temp_name=!temp_name: =!
if /i "!temp_name!"=="Name" set /a networks+=1&for /f "tokens=* delims= " %%s in ("%%j") do set "name_[!networks!]=%%s"
set bssid_[!networks!]=
if /i "!temp_name!"=="BSSID" for /f "tokens=* delims= " %%d in ("%%j") do set bssid_[!networks!]=%%d
)
for /l %%a in (1,1,!networks!) do if "!name_[%%a]!"=="%~1" if "!bssid_[%%a]!" NEQ "" echo !bssid_[%%a]!
