@if not defined _echo echo off
setlocal enableDelayedExpansion

set arch=x64
@REM @REM echo Target-arch: !arch!

set toolpath="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq delims=" %%i in (`%toolpath% -latest -property installationPath`) do (
    set VCVarsAllBat="%%i\VC\Auxiliary\Build\vcvarsall.bat"
    set CMakePath="%%i\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
)

if exist !VCVarsAllBat! (
    call !VCVarsAllBat! !arch! -vcvars_ver=14.36.32532
    if exist !CMakePath! (
        set PATH=!CMakePath!;!PATH!
    )
    @REM Print which version of cmake, should be the one that comes with visual studio/c++
    cmake --version
    @REM Print which version of cl.exe is being used
    cl
    cd cpp/ALVR-OpenXR-Engine
    rmdir /s /q build
    cmake -GNinja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_CUDA_INTEROP:BOOL=OFF -DDISABLE_DECODER_SUPPORT:BOOL=ON -DCMAKE_INSTALL_PREFIX='../../../../../build/libalxr' -B build
    ninja install -C build
    rmdir /s /q build
)
