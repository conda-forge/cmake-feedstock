#!/bin/sh
set -ex

cmake -LAH -G Ninja ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_PREFIX_PATH=${PREFIX} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
    -DCURSES_INCLUDE_PATH=${PREFIX}/include \
    -DCMAKE_USE_SYSTEM_LIBRARIES=ON \
    -DCMAKE_USE_SYSTEM_JSONCPP=OFF \
    -DCMAKE_USE_SYSTEM_LIBARCHIVE=OFF \
    -DCMAKE_USE_SYSTEM_CPPDAP=OFF \
    -DCMAKE_USE_SYSTEM_LIBRARY_JSONCPP=OFF \
    -DCMAKE_USE_SYSTEM_LIBRARY_LIBARCHIVE=OFF \
    -DCMAKE_USE_SYSTEM_LIBRARY_CPPDAP=OFF \
    -DBUILD_CursesDialog=ON \
    -DBUILD_QtDialog=OFF \
    . || (cat TryRunResults.cmake; false)

cmake --build . --target install -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  ctest --output-on-failure -j${CPU_COUNT} -R "CTestTestParallel|DOWNLOAD"
fi
