if "%ARCH%"=="32" (set CPU_ARCH=x86) else (set CPU_ARCH=x64)
curl https://cmake.org/files/v%PKG_VERSION:~0,4%/cmake-%PKG_VERSION%-win%ARCH%-%CPU_ARCH%.zip -o cmake-win.zip
7z x cmake-win.zip > nil
set PATH=%CD%\cmake-%PKG_VERSION%-win%ARCH%-%CPU_ARCH%\bin;%PATH%
cmake --version

mkdir build && cd build

set CMAKE_CONFIG="Release"

dir /p %LIBRARY_PREFIX%\lib

echo "Constructing makefiles"
cmake -LAH -G"NMake Makefiles"                               ^
    -DCMAKE_BUILD_TYPE=%CMAKE_CONFIG%                        ^
    -DCMAKE_FIND_ROOT_PATH="%LIBRARY_PREFIX%"                ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ..
if errorlevel 1 exit 1

type CMakeFiles/CMakeOutput.log
type CMakeFiles/CMakeError.log

REM cmake --build . --config %CMAKE_CONFIG% --target install

echo "Building"
make
if errorlevel 1 exit 1

echo "Installing"
make install
if errorlevel 1 exit 1
