
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

