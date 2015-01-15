## YCM for Windows

1.  Download  and install [Mingw-w64][mingw-w64-download] 
    Make sure you can access `gcc` from command line. If not, the easiest way is
    to add its directory in your `PATH` My compiler is

        C:\Users\Gokhan>gcc --version
        gcc (x86_64-posix-seh-rev1, Built by MinGW-W64 project) 4.9.2

2.  Install Python 27 and make sure you can run `python` from command line (i.e.
    add Python27 folder to `PATH`)

3.  Install [CMake][cmake-download]. Make sure `cmake.exe` is in your `PATH`. 

4.  Download LLVM and [Clang sources][clang-download]

    We first need to build clang to get ycm worked for C/C++ languages.

    1.  Extract these sources and arrange them in the following way.
        Here how the directories should look like:

            D:\builds\clangbuild\
                build         <---- Create a new directory, name it build
                llvm-3.5.0.src\
                    tools\
                        clang <---- This is clang source, rename it clang and put it
                                                    under llvm's tools directory.

    2.  `cd` into `D:\builds\clangbuild\build`  and issue the following command

            cmake -G "MinGW Makefiles" ^
            -DCMAKE_INSTALL_PREFIX=D:\builds\clangbuild\llvm-3.5.0.dst ^
            -DCMAKE_BUILD_TYPE=Release ..\llvm-3.5.0.src

        Note that the llvm version could be different. Change it into your
        llvm-x.y.z.src or whatever it is.

    3.  When it is done enter the following command, this will take very long time.

        mingw32-make

        NOTE: The last command might generate several errors, without changing
        anything run it again. If you get the same errors again and again,
        delete everything and download the sources, start over. I don't know
        why it should happen. It didn't work several times, then I downloaded
        the sources and started over again, and finally it compiled.

    4.  After compilation, run the command

            mingw32-make install

        `libclang.dll` should be under llvm-3.5.0.dst/bin directory.

5.  Now, we can compile YouCompleteMe for Windows.

        cd /d D:\builds
        mkdir ycmbuild
        cd ycmbuild
        git clone https://github.com/Valloric/YouCompleteMe.git
        cd YouCompleteMe
        git submodule update --init --recursive

6.  We should create **64 bit** `libpython27.a` out of `python27.dll`
    cd into Python27 and run the following commands

        gendef python27.dll
        dlltool --dllname python27.dll --def python27.def --output-lib libpython27.a

    If `libpython27.a` already exists in *libs* folder, just overwrite it.
    In my case it was 32 bit, useless.

        move libpython27.a libs

7.  Create a `build` directory in `ycmbuild`
    `cd` into `ycmbuild` 
    
        mkdir build
        cd build
    
    Generate Makefiles in `build` directory

        cmake -G "MinGW Makefiles" ^
        -DPATH_TO_LLVM_ROOT=D:\builds\clangbuild\llvm-3.5.0.dst ^
        D:\builds\ycmbuild\YouCompleteMe\third_party\ycmd\cpp

8.  When it is done, run

        mingw32-make ycm_support_libs

`ycm_core.pyd`, `ycm_client_support.pyd`, and `libclang.dll` should be available
under `D:\builds\ycmbuild\YouCompleteMe\third_party\ycmd`

**Note:** *build_ycm.bat* can be helpful for the steps above.

[mingw-w64-download]: http://mingw-w64.sourceforge.net/download.php#mingw-builds
[cmake-download]: http://www.cmake.org/download/
[clang-download]: http://llvm.org/releases/download.html
