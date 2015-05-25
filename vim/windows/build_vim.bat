@echo off
:: Utility to build Vim on Windows

:: Run this batch file from any directory to build gvim.exe and vim.exe.
:: But first edit the paths and Python version number.

:: --- Add Mingw-w64 /bin directory to PATH ---
set TOOLCHAIN=D:\toolchains\mingw-w64-x86_64\mingw64\bin
PATH=%TOOLCHAIN%;%PATH%

:: --- Specify Vim /src folder ---
set VIMSRC=D:\build\vimbuild\vim\src

:: get location of this batch file
set WORKDIR=%~dp0
set LOGFILE=%WORKDIR%log.txt

:: SRC is vim repo, DST is built binaries and runtime etc..
set SRC=D:\build\vimbuild\vim
set DST=D:\build\vimbuild\vim74

echo Work directory: %WORKDIR%
echo Vim source directory: %VIMSRC%

:: --- Copy out Make_mingw64 file into VIMSRC
xcopy %WORKDIR%Make_mingw64.mak %VIMSRC%\* /D /Y %*

:: change to Vim /src folder
cd /d %VIMSRC%

:: --- Make sure that PYTHON, PYTHON_VER below are correct. ---
:: --- Build Vim ---
echo Building gvim.exe
mingw32-make.exe -f Make_mingw64.mak ^
PYTHON="%USERPROFILE%/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes ^
PYTHON3="%USERPROFILE%/Python34" PYTHON3_VER=34 DYNAMIC_PYTHON3=yes ^
FEATURES=HUGE GUI=yes ARCH=x86-64 OLE=yes STATIC_STDCPLUS=yes ^
USERNAME="Gokhan Karabulut <xgeekonx@gmail.com>" ^
USERDOMAIN= > "%LOGFILE%"

echo Building vim.exe
mingw32-make.exe -f Make_mingw64.mak ^
PYTHON="%USERPROFILE%/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes ^
PYTHON3="%USERPROFILE%/Python34" PYTHON3_VER=34 DYNAMIC_PYTHON3=yes ^
FEATURES=HUGE GUI=no ARCH=x86-64 OLE=yes STATIC_STDCPLUS=yes ^
USERNAME="Gokhan Karabulut <xgeekonx@gmail.com>" ^
USERDOMAIN= vim.exe >> "%LOGFILE%"

echo Copying files ...
:: Copy any new Vim exe + runtime files to current install.
xcopy %SRC%\runtime %DST% /D /E /H /I /Y %*
xcopy %SRC%\src\xxd\xxd.exe %DST%\* /D /Y %*
xcopy %SRC%\src\GvimExt\gvimext.dll %DST%\* /D /Y %*
xcopy %SRC%\src\*.exe %DST%\* /D /Y %*

echo Cleaning 
mingw32-make.exe -f Make_mingw64.mak ^
PYTHON="%USERPROFILE%/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes ^
PYTHON3="%USERPROFILE%/Python34" PYTHON3_VER=34 DYNAMIC_PYTHON3=yes ^
FEATURES=HUGE GUI=yes ARCH=x86-64 OLE=yes STATIC_STDCPLUS=yes ^
USERNAME="Gokhan Karabulut <xgeekonx@gmail.com>" ^
USERDOMAIN= clean >> "%LOGFILE%"

:: Because many files deleted by 'make clean' above,
:: we should delete the rest manually, we should also delete
:: Make_mingw64.mak file
echo Further cleaning ...
IF NOT %CD%==%VIMSRC% GOTO THEEND
IF NOT EXIST vim.h GOTO THEEND
IF EXIST pathdef.c DEL pathdef.c
IF EXIST obj\NUL      RMDIR /S /Q obj
IF EXIST objx86-64\NUL  RMDIR /S /Q objx86-64
IF EXIST gobj\NUL      RMDIR /S /Q gobj
IF EXIST gobjx86-64\NUL  RMDIR /S /Q gobjx86-64
IF EXIST gvim.exe DEL gvim.exe
IF EXIST vim.exe  DEL vim.exe
DEL Make_mingw64.mak 
:THEEND

@echo on
pause
