@echo off

if [%1]==[] goto usage
set boo=%~dfnx1
if not exist %boo% goto usage

set dir=%tmp%\xmpls-%date:/=%
set key=%dir%\key
set sig=%dir%\sig
set img=%dir%\img

md %dir%

for /d %%d in (%systemdrive%\openssl* %userprofile%\Desktop\openssl*) do set ssl=%%d\openssl
for /d %%d in (%systemdrive%\python*) do set pyt=%%d\python


%ssl% genrsa -3 2048 > %key% 2> nul

echo.
echo Example #1: signing 0x1234567890
echo.

echo 0x1234567890 | %ssl% rsautl -sign -inkey %key% > %sig% 2> nul
call :vrfy

echo.
echo Decrypted FORGED signature (showing padding)
echo 0x1234567890 | %pyt% cuber.py | %ssl% rsautl -verify -inkey %key% -hexdump -raw 2> nul
echo.


echo.
echo Example #2: signing '%boo%'
echo.

%pyt% cuboot.py %boo% > %img%
type %img%
for /f "tokens=2 delims==" %%i in ('type %img%') do set off=%%i

%pyt% split.py %boo% %off% %img%
%pyt% split.py %img%.1 256 %sig%

%ssl% dgst -sha256 -binary < %img%.0 2> nul | %ssl% rsautl -sign -inkey %key% > %sig% 2> nul
call :vrfy

echo.
echo Decrypted FORGED signature (showing padding)
%ssl% rsautl -verify -inkey %key% -hexdump -raw < %sig%.0 2> nul
echo.

rd /s /q %dir%

exit /b


:vrfy
echo.
echo Decrypted REAL signature
%ssl% rsautl -verify -inkey %key% -hexdump < %sig% 2> nul
echo.
echo Decrypted REAL signature (showing padding)
%ssl% rsautl -verify -inkey %key% -hexdump -raw < %sig% 2> nul
echo.
exit /b


:usage
echo Usage: %0 boot-image
exit /b 1
