@echo off 
setlocal enabledelayedexpansion
for /f "tokens=1 delims=:" %%i in ('netsh wlan show interfaces ^| findstr /i "BSSID.*[:]"') DO for /f "tokens=* delims=" %%a in ("%%i") do set "BSSID_KEY=%%a"
for /f "delims=" %%i in ('powershell -c "$profile=\"%BSSID_KEY%\";$profile = $profile.Trim();$profile"') do set "BSSID_KEY=%%i"
set networks=0
for /f "tokens=1,* delims=:" %%i in ('netsh wlan show interfaces ^| findstr /iR "Name BSSID"') do (
(for /f "delims=" %%x in ('powershell -c "$profile=\"%%i\";$profile = $profile.Trim();$profile"') do set "temp_name=%%x")
if /i "!temp_name!"=="Name" set /a networks+=1&for /f "tokens=* delims= " %%s in ("%%j") do set "name_[!networks!]=%%s"
if /i "!temp_name!"=="%BSSID_KEY%" for /f "tokens=* delims= " %%d in ("%%j") do set bssid_[!networks!]=%%d
)
for /l %%a in (1,1,!networks!) do if "!name_[%%a]!"=="%~1" if "!bssid_[%%a]!" NEQ "" echo !bssid_[%%a]!
