@echo off
:PROMPT
echo You must execute this file with "Run as administrator"
SET /P AREYOUSURE=Are you sure you want to delete all contents of DISK 1 (Y/[N])? 
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

echo select disk 0 > answer.txt
echo convert dynamic >> answer.txt
echo select disk 1 >> answer.txt
echo clean >> answer.txt
echo convert gpt >> answer.txt
echo select partition 1 >> answer.txt
echo delete partition override >> answer.txt
echo create partition efi size=100 >> answer.txt
echo format fs=fat32 quick >> answer.txt
echo select partition 1 >> answer.txt
echo assign letter=x >> answer.txt
echo create partition msr size=16 >> answer.txt
echo create partition primary size=953089 >> answer.txt
echo format fs=ntfs quick >> answer.txt
echo create partition primary size=518 >> answer.txt
echo format fs=ntfs quick >> answer.txt
echo select partition 4 >> answer.txt
echo set id=de94bba4-06d1-4d40-a16a-bfd50179d6ac >> answer.txt
echo assign letter=y >> answer.txt
echo convert dynamic >> answer.txt
echo list volume >> answer.txt
echo select partition 3 >> answer.txt
echo delete volume >> answer.txt
echo list volume >> answer.txt
echo select disk 0 >> answer.txt
echo list partition >> answer.txt
echo select partition 4 >> answer.txt
echo add disk 1 >> answer.txt
echo select partition 1 >> answer.txt
echo assign letter=r >> answer.txt
echo select partition 6 >> answer.txt
echo assign letter=s >> answer.txt
echo exit >> answer.txt

diskpart < answer.txt
rem pause
del answer.txt /Q

robocopy.exe r:\ x:\ * /e /copyall /dcopy:t /xf BCD.* /xd "System Volume Information"
robocopy.exe s:\ y:\ * /e /copyall /dcopy:t /xd "System Volume Information"
rem pause

echo select disk 0 > answer.txt
echo list partition >> answer.txt
echo select partition 1 >> answer.txt
echo remove letter=r >> answer.txt
echo select partition 6 >> answer.txt
echo remove letter=s >> answer.txt
echo select disk 1 >> answer.txt
echo list partition >> answer.txt
echo select partition 1 >> answer.txt
echo remove letter=x >> answer.txt
echo select partition 4 >> answer.txt
echo remove letter=y >> answer.txt

echo exit >> answer.txt
diskpart < answer.txt
rem pause
del answer.txt /Q



echo select disk 0 >> answer.txt
echo select partition 1 >> answer.txt
echo assign letter=s >> answer.txt
echo select disk 1 >> answer.txt
echo select partition 1 >> answer.txt
echo assign letter=t >> answer.txt
echo exit >> answer.txt
diskpart < answer.txt
rem pause
del answer.txt /Q

S:
cd EFI\Microsoft\Boot
for /f "tokens=2" %%i in ('bcdedit /enum ^| findstr /C:"resumeobject"') do ^
set GUID=%%i
bcdedit /copy {bootmgr} /d "Windows Boot Manager Backup"
bcdedit /set %GUID% device partition=t:
bcdedit /export T:\EFI\Microsoft\Boot\BCD
C:

echo select disk 0 >> answer.txt
echo select partition 1 >> answer.txt
echo remove letter=s >> answer.txt
echo select disk 1 >> answer.txt
echo select partition 1 >> answer.txt
echo remove letter=t >> answer.txt
echo exit >> answer.txt
diskpart < answer.txt
rem pause
del answer.txt /Q

:END
pause 