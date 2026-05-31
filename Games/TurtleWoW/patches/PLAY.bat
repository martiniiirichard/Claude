@echo off
cd /d "C:\TurtleWoW\server"

:: Kill any leftovers
taskkill /F /IM mysqld.exe   2>nul
taskkill /F /IM apache.exe   2>nul
taskkill /F /IM mangosd.exe  2>nul
taskkill /F /IM realmd.exe   2>nul
ping -n 3 127.0.0.1 >nul

:: Start MySQL
start "MySQL" /D "C:\TurtleWoW\server" mysql\bin\mysqld.exe --console --max_allowed_packet=128M
ping -n 8 127.0.0.1 >nul

:: Start Apache
cd /d "C:\TurtleWoW\server\website\apache\bin"
cscript mh.js >nul 2>nul
start "Apache" apache.exe
cd /d "C:\TurtleWoW\server"
ping -n 4 127.0.0.1 >nul

:: Start Mangosd
start "Mangosd" /D "C:\TurtleWoW\server" mangosd.exe -c mangosd.conf
ping -n 5 127.0.0.1 >nul

:: Start Realmd
start "Realmd" /D "C:\TurtleWoW\server" realmd.exe -c realmd.conf
ping -n 6 127.0.0.1 >nul

:: Launch WoW client via VanillaFixes (DXVK + SuperWoW + NamPower)
start "" "C:\TurtleWoW\client\VanillaFixes.exe"
