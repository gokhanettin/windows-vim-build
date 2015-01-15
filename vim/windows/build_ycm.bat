@echo off
:: Utility to compile YouCompleteMe on Windows

:: --- Where is Mingw-w64 ? ---
set TOOLCHAIN=D:\toolchains\mingw-w64-x86_64\mingw64

:: --- Where is CMake ? ---
set CMAKE=D:\toolchains\CMake

:: --- Where is Python27 directory ? ---
set PYTHON27=%USERPROFILE%\Python27

:: --- Where is YouCompleteMe source ? ---
set YCM=%USERPROFILE%\.vim\bundle\YouCompleteMe

:: --- Where is compiled LLVM ? ---
set LLVM=D:\builds\clangbuild\llvm-3.5.0.dst

:: -- set a build directory for CMake ---
set BUILDDIR=D:\builds\ycmbuild\build

:: If BUILDDIR exists, delete it for a new configuration
IF EXIST %BUILDDIR% (
    call rmdir /S /Q %BUILDDIR%
)

IF NOT EXIST %YCM% (
    echo %YCM% does not exist!
    exit /B
)

IF NOT EXIST %LLVM% (
    echo %LLVM% does not exist!
    exit /B
)


IF NOT EXIST %CMAKE% (
    echo %CMAKE% does not exist!
    exit /B
)

IF NOT EXIST %TOOLCHAIN% (
    echo %TOOLCHAIN% does not exist!
    exit /B
)

:: Add CMake and toolcain to Environment PATH
PATH=%PYTHON27%;%PATH%
PATH=%CMAKE%\bin;%PATH%
PATH=%TOOLCHAIN%\bin;%PATH%

:: Create 64 bit libpython27.a out of python27.dll
chdir /d %PYTHON27%
gendef python27.dll
dlltool --dllname python27.dll --def python27.def --output-lib libpython27.a
:: Overwrite if libpython27.a exists, it is probably 32 bit,
:: useless for our 64 bit compilation, causes errors compiling ycm
move /y libpython27.a libs

:: Create BUILDDIR for CMake
call mkdir %BUILDDIR%
chdir /d %BUILDDIR%
echo Current Directory %CD%

echo Creating Makefiles ...
cmake -G "MinGW Makefiles" ^
-DPATH_TO_LLVM_ROOT=%LLVM% ^
%YCM%\third_party\ycmd\cpp


:: Build YouCompleteMe. On Completion,
:: ycm_core.pyd, ycm_client_support.pyd, and libclang.dll are available under
:: YouCompleteMe\third_party\ycmd
echo Now compiling YouCompleteMe ...
mingw32-make ycm_support_libs
echo Done.
pause
