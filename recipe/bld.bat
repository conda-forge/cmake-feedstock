
if "%ARCH%"=="32" (set CPU_ARCH=x86) else (set CPU_ARCH=x64)
curl https://cmake.org/files/v%PKG_VERSION:~0,4%/cmake-%PKG_VERSION%-win%ARCH%-%CPU_ARCH%.zip -o cmake-win.zip
7z x cmake-win.zip > nil
set PATH=%CD%\cmake-%PKG_VERSION%-win%ARCH%-%CPU_ARCH%\bin;%PATH%
cmake --version

mkdir build && cd build

set CMAKE_CONFIG="Release"

dir /p %LIBRARY_PREFIX%\lib

cmake -LAH -G"NMake Makefiles"                               ^
    -DCMAKE_BUILD_TYPE=%CMAKE_CONFIG%                        ^
    -DCMAKE_FIND_ROOT_PATH="%LIBRARY_PREFIX%"                ^
    -DCMAKE_USE_SYSTEM_ZLIB=ON                               ^
    -DCMAKE_USE_SYSTEM_EXPAT=ON                              ^
    -DCMAKE_USE_SYSTEM_CURL=ON                               ^
    -DCMAKE_USE_SYSTEM_BZIP2=ON                              ^
    -DCMAKE_USE_SYSTEM_LIBLZMA=ON                            ^
    -DLIBLZMA_LIBRARY="%LIBRARY_PREFIX%\lib\liblzma.lib"     ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ..
if errorlevel 1 exit 1

cmake --build . --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1

cp %RECIPE_DIR%\Windows-Flang-Fortran.cmake %LIBRARY_PREFIX%\share\cmake-3.10\Modules\Platform\
