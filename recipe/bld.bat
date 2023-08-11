
rem cmake is needed to build cmake

if "%ARCH%"=="32" (set CPU_ARCH=x86) else (set CPU_ARCH=x64)
rem https://cmake.org/files/v%PKG_VERSION:~0,4%/cmake-%PKG_VERSION%-windows-%ARCH%_%CPU_ARCH%.zip
set CMAKE_URL=https://cmake.org/files/v3.27/cmake-3.27.2-windows-x86_64.zip
curl %CMAKE_URL% -o cmake-win.zip
7z x cmake-win.zip > nil
rem set PATH=%CD%\cmake-%PKG_VERSION%-windows-%ARCH%-%CPU_ARCH%\bin;%PATH%
set PATH=%CD%\cmake-3.27.2-windows-x86_64\bin;%PATH%
cmake --version

rem Build new cmake
mkdir build

set CMAKE_CONFIG="Release"

dir /p %LIBRARY_PREFIX%\lib

cmake -LAH -G"Ninja"                                         ^
    -DCMAKE_BUILD_TYPE=%CMAKE_CONFIG%                        ^
    -DCMAKE_FIND_ROOT_PATH="%LIBRARY_PREFIX%"                ^
    -DCMAKE_PREFIX_PATH="%PREFIX%"                           ^
    -DCMAKE_CXX_STANDARD:STRING=17                           ^
    -DCMAKE_HAVE_CXX_MAKE_UNIQUE:INTERNAL=TRUE               ^
    -DCMAKE_USE_SCHANNEL:BOOL=ON                             ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"                ^
    -DCURL_WINDOWS_SSPI:BOOL=ON                              ^
    -DBUILD_CursesDialog:BOOL=ON                             ^
    -S . -B build
if errorlevel 1 exit 1

cmake --build ./build --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1

