
:: The cmake fetched here is not the target it is used to build the target.
:: It should probably be checked.
if "%ARCH%"=="32" (set CPU_ARCH=x86) else (set CPU_ARCH=x64)

set CMAKE_URL=https://cmake.org/files/v3.27/cmake-3.27.2-windows-x86_64.zip
:: set CMAKE_URL=https://cmake.org/files/v%PKG_VERSION:~0,4%/cmake-%PKG_VERSION%-win%ARCH%-%CPU_ARCH%.zip

curl "%CMAKE_URL%" -o cmake-win.zip
IF %ERRORLEVEL% NEQ 0 (
   ECHO error retrieving cmake %ERRORLEVEL%
)
7z x cmake-win.zip > nil
IF %ERRORLEVEL% NEQ 0 (
   ECHO error expanding cmake %ERRORLEVEL%
)
set PATH=%CD%\cmake-%PKG_VERSION%-win%ARCH%-%CPU_ARCH%\bin;%PATH%
cmake --version
IF %ERRORLEVEL% NEQ 0 (
   ECHO error running cmake %ERRORLEVEL%
)
ECHO "CMAKE URL: %CMAKE_URL%"

:: build new cmake executable

set PATH=%PREFIX%\cmake-bin\bin;%PATH%
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
    -S . -B .\build
IF %ERRORLEVEL% NEQ 0 (
   ECHO error configuring cmake %ERRORLEVEL%
   exit 1
)

cmake --build .\build --config %CMAKE_CONFIG% --target install
IF %ERRORLEVEL% NEQ 0  (
   ECHO error building via cmake %ERRORLEVEL%
   exit 1
)

