## Building Vim from source on Windows

Accomplished on a Windows 7 x86-64 machine. For different architectures, make
sure you set ARCH, and modified cleaning sections in `build_vim.bat` accordingly.

Download vim source code and use `build_vim.bat` and `Make_mingw64.mak` to
build it. Adjust the path variables in `build_vim.bat` file, but most probably
we won't have to change anything in the `Make_mingw64.mak` file. Just put them
in the same directory and run `build_vim.bat` after modifications.

Here are some steps:

1.  **Download Mingw-w64**

    Download and install mingw-w64 from [here](http://mingw-w64.sourceforge.net/download.php#mingw-builds).
    Modify `build_vim.bat` according to your mingw-w64 bin path.
    My mingw-w64 is

        C:\Users\Gokhan>gcc --version
        gcc (x86_64-posix-seh-rev1, Built by MinGW-W64 project) 4.9.2

    Different versions of gcc may cause some problem. I have not tried another
    version.

2.  **Setting up mercurial client**

    Download and install TortoiseHg from [here](http://mercurial.selenic.com/wiki/Download).

3.  **Getting vim source code**

    Open `cmd.exe` and run the followings in order.

        mkdir D:\build\vimbuild
        cd /d D:\build\vimbuild
        hg clone https://vim.googlecode.com/hg/ vim

4.  **Running `vim_build.bat`**

    Assuming `build_vim.bat` and `Make_mingw64.mak` are in the same folder, modify
    `build_vim.bat` for your needs. We may want to change Python directories,
    `USERNAME` etc... Run `build_vim.bat` and that will start building vim.

5.  **Accessing vim and gvim from command line**

    DST folder is `vimbuild/vim74` by default. Compiled vim will be copied here.
    Put vim74 folder wherever you like. If you want to run start vim from
    `cmd.exe`, add it to your `PATH`.

`Make_cyg_ming.mak` didn't work properly for me. I had to create
`Make_mingw64.mak` based on `Make_cyg_mingw.mak` The problems with
`Make_cyg_ming.mak` are as follows
 - `OUTDIR` definition is made after it is already used above the definition.
 - For static linking, I had to add `-Wl,-Bstatic lwinpthread`
right after `-Wl,-Bstatic -lstdc++`

In the future, changes to the Vim source and runtime files can be downloaded
with the following.

    cd /d D:\build\vimbuild\vim hg pull -u

In this build, Python and Python3 are supported. Supporting Perl, Lua etc...
must be straightforward.

Note that above steps may not be working as new patches are applied to vim
source. We should solve the problems as they arise.

Here are some useful links:

[Getting the Vim source with Mercurial](http://vim.wikia.com/wiki/Getting_the_Vim_source_with_Mercurial)  
[Python enabled Vim on Windows with MinGW](http://vim.wikia.com/wiki/Build_Python-enabled_Vim_on_Windows_with_MinGW)  
[Build Vim in Windows with Visual Studio](http://vim.wikia.com/wiki/Build_Vim_in_Windows_with_Visual_Studio)  
