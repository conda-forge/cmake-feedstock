
if "%ARCH%"=="32" (set CPU_ARCH=i386) else (set CPU_ARCH=x86_64)
curl https://cmake.org/files/v%PKG_VERSION:~0,4%/cmake-%PKG_VERSION%-windows-%CPU_ARCH%.zip -o cmake-win.zip
7za x cmake-win.zip > nil
set PATH=%CD%\cmake-%PKG_VERSION%-windows-%CPU_ARCH%\bin;%PATH%
cmake --version

cmake -LAH -G Ninja                                          ^
    -DCMAKE_BUILD_TYPE:STRING=Release                        ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"                   ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"                ^
    -DCMAKE_USE_SYSTEM_LIBRARIES=ON                          ^
    -DCMAKE_USE_SYSTEM_JSONCPP=OFF                           ^
    -DCMAKE_USE_SYSTEM_LIBARCHIVE=OFF                        ^
    -DCMAKE_USE_SYSTEM_CPPDAP=OFF                            ^
    -DCMAKE_USE_SYSTEM_LIBRHASH=OFF                          ^
    -DCMAKE_USE_SYSTEM_LIBRARY_JSONCPP=OFF                   ^
    -DCMAKE_USE_SYSTEM_LIBRARY_LIBARCHIVE=OFF                ^
    -DCMAKE_USE_SYSTEM_LIBRARY_CPPDAP=OFF                    ^
    -DCMAKE_USE_SYSTEM_LIBRARY_LIBRHASH=OFF                  ^
    -DBUILD_CursesDialog=ON                                  ^
    -DBUILD_QtDialog=OFF                                     ^
    -DCURL_USE_SCHANNEL=ON                                   ^
    -DCURL_WINDOWS_SSPI=ON                                   ^
    .
if errorlevel 1 exit 1

cmake --build . --target install -j%CPU_COUNT%
if errorlevel 1 exit 1

ctest --test-dir . --output-on-failure -j%CPU_COUNT% -R "CTestTestParallel|DOWNLOAD"
if errorlevel 1 exit 1
